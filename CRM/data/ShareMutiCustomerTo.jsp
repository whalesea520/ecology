
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%

String customerids = Util.null2String(request.getParameter("customerids"));
String selectType = Util.null2o(request.getParameter("selectType"));//如果值为 share，则保存结束后，关闭当前弹出窗口
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17221,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(2112,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
boolean canEdit = true ;
	/*if has Seccateory edit right, or has approve right(canapprove=1), or user is the document creater can edit documetn right.*/
/*if(HrmUserVarify.checkUserRight("DocSecCategoryEdit:Edit",user)||canapprove==1||user.getUID()==doccreaterid){
	canEdit = true;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:doSave(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
}
*/
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doShare(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(119,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="doShare(this)" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div class="zDialog_div_content" style="height:395px;">
<FORM id=weaver name=weaver action="ShareMutiCustomerOperation.jsp" method=post >
<input type="hidden" name="customerids" value="<%=customerids%>">
<input type="hidden" name="rownum" id="rownum" value="0">  
<input type="hidden" name="relatedshareid" id="relatedshareid">
<input type="hidden" name="showrelatedsharename" id="showrelatedsharename">

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' >
		<wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></wea:item>
		<wea:item>
			<SELECT  class=InputStyle name=sharetype onchange="onChangeSharetype()" style="width: 120px;">
			  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
			  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="5"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
			  <option value="4"><%=SystemEnv.getHtmlLabelName(235,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%>
			  <option value="6"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%>
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'showsharetype'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showsharetype'}">
			<div id="resourceDiv">
				<brow:browser viewType="0" name="relatedshareid_1" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp" width="180px" ></brow:browser> 
			</div>
			
			<div id="departmentDiv">
				<brow:browser viewType="0" name="relatedshareid_2" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2' 
			         completeUrl="/data.jsp?type=57" width="180px;" ></brow:browser> 
			</div>
			
			<div id="subcompanyDiv">
				<brow:browser viewType="0" name="relatedshareid_5" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=164" width="180px" ></brow:browser> 
			</div>
			
			<div id="roleDiv">
				<brow:browser viewType="0" name="relatedshareid_3" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/MutiRolesBrowser.jsp"
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
			<SELECT class=InputStyle  name=rolelevel id="showrolelevel" style="width: 120px;">
			  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'showseclevelPair'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showseclevelPair'}">
			<wea:required id="seclevelimage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name=seclevel id="showseclevel" onKeyPress="ItemCount_KeyPress()" 
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
	
	
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1279,user.getLanguage())%>'>
		<wea:item type="groupHead">
			<input type="button" class="addbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(15128, user.getLanguage())%>" onclick="addRow();">
			<input type="button" class="delbtn" style="cursor:pointer" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>" onclick="deleteRow()">
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
			<TABLE class="ListStyle" cellpadding=1  cols=7 id="oTable" name="oTable">
				<tr class=header>
					<td class=Field><input type="checkbox" name="node_total" onclick="setCheckState(this)"/></td>
					<td class=Field colspan=3><%=SystemEnv.getHtmlLabelName(21443,user.getLanguage())%></td>
				</tr>
			</table>  
		</wea:item>
	</wea:group>
	
</wea:layout>
</FORM>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</BODY>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<script language=javascript>
function doShare(obj) {
    jQuery("#rownum").val(curindex);
    obj.disabled=true;
    if("<%=selectType%>" == "share"){
    	jQuery.post("/CRM/data/ShareMutiCustomerOperation.jsp",jQuery("form").serialize(),function(){
    		parent.getDialog(window).close();
    	})
    }else{
    	weaver.submit();
    }
    
}
</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js"></script>
<script language="javascript">
function setCheckState(obj){
	var checkboxs = jQuery("input[name='check_node']").each(function(){
		changeCheckboxStatus(this,obj.checked);
 	});
}	
 
 jQuery(function(){
  	hideEle("showrolelevel","true");
  	checkinput("seclevel","seclevelimage");
  	checkinput("seclevelMax","seclevelMaximage");
  	
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
	
	jQuery("#resourceDiv").hide();
	jQuery("#departmentDiv").hide();
	jQuery("#subcompanyDiv").hide();
	jQuery("#roleDiv").hide();
	
	hideEle("item_seclevel");
	hideEle("showrolelevel");
	hideEle("item_jobtitlelevel");
	$GetEle("showjobtitle").style.display='none';
	$GetEle("showjobtitlesubcompany").style.display='none';
	$GetEle("showjobtitledepartment").style.display='none';
	
	
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

function onjobtitlelevelChange(){
	$GetEle("showjobtitlesubcompany").style.display='none';
	$GetEle("showjobtitledepartment").style.display='none';
	if(jQuery("#jobtitlelevel").val()=="1"){
		$GetEle("showjobtitledepartment").style.display='';
	}else if(jQuery("#jobtitlelevel").val()=="2"){
		$GetEle("showjobtitlesubcompany").style.display='';
	}
}

function checkValid(){
	thisvalue=document.weaver.sharetype.value;
	if(thisvalue==4){
		jQuery("#relatedshareid").val("");
		jQuery("#showrelatedsharename").val("");
	}else{
		jQuery("#relatedshareid").val(jQuery("#relatedshareid_"+thisvalue).val());
		
		var index = 0;
		jQuery("#relatedshareid_"+thisvalue).parent().find("a").each(function (){
			var name = $(this).html();
			if(name != "" && typeof(name) != 'undefined') {
				if(index > 0) {
					name = jQuery("#showrelatedsharename").val() + ','+name;
				}
				jQuery("#showrelatedsharename").val(name); 
				index ++;
			}
			
		}); 
		
	}
	
	var checkinfo = "relatedshareid,seclevel,seclevelMax";
	if(thisvalue==1){//人力资源
		checkinfo = "relatedshareid";
	}
	if(thisvalue==4){//所有人
		checkinfo = "";
	}
	return check_form(weaver,checkinfo);
}

var curindex=0;


function addRow() {
    if(!checkValid()){
        return;
    }
    
    var relatedshareids = jQuery("#relatedshareid").val();
    var showrelatedsharenames = jQuery("#showrelatedsharename").val();
    if(relatedshareids != "") {
    	var relateidarr = relatedshareids.split(",");
    	var sharenamearr = showrelatedsharenames.split(",");
    	for(var i =0;i< relateidarr.length; i++) {
    		addRows(relateidarr[i], sharenamearr[i]);
    	}
    }else {
    	addRows('','');
    }
	//addRows();
	

}

function addRows(relatedshareid, showrelatedsharename){

    rowColor = getRowBg();
    var oRow = oTable.insertRow(-1);
    var oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    var oDiv = document.createElement("div");
    var sHtml = "<input type='checkbox' name='check_node' value='0'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
	jQuery("body").jNice();
    oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    oDiv = document.createElement("div");
	sHtml = document.all("sharetype").options[document.all("sharetype").selectedIndex].text;
	sHtml += "<input type='hidden' name='sharetype_"+curindex+"' value='"+document.all("sharetype").value+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
	
    oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    oDiv = document.createElement("div");
    //岗位级别
    if(document.all("sharetype").value == "6"){
    	var jobtitlelevel = document.all("jobtitlelevel").value;
    	
    	if(jobtitlelevel == 1){
    		var jobpartment = '';
	    	jQuery("#showjobtitledepartment").find("a").each(function (){
	    		var name = $(this).html();
				if(name != "" && typeof(name) != 'undefined') {
					jobpartment += name + ',';
				}
	    	});
	    	if(jobpartment.length > 0){
	    		jobpartment = jobpartment.substring(0, jobpartment.length);
	    		showrelatedsharename += '/指定部门('+jobpartment+')';
	    	}
	    	sHtml += "<input type='hidden' name='jobtitledepartment_"+curindex+"' value='"+jQuery("#jobtitledepartment").val()+"'>";
    	}else if(jobtitlelevel == 2){
    		var jobsubcompany = '';
	    	jQuery("#showjobtitlesubcompany").find("a").each(function (){
	    		var name = $(this).html();
				if(name != "" && typeof(name) != 'undefined') {
					jobsubcompany += name + ',';
				}
	    	});
	    	if(jobsubcompany.length > 0){
	    		jobsubcompany = jobsubcompany.substring(0, jobsubcompany.length);
	    		showrelatedsharename += '/指定分部('+jobsubcompany+')';
	    	}
	    	sHtml += "<input type='hidden' name='jobtitlesubcompany_"+curindex+"' value='"+jQuery("#jobtitlesubcompany").val()+"'>";    	
    	}
    		
    	 sHtml += "<input type='hidden' name='jobtitlelevel_"+curindex+"' value='"+jobtitlelevel+"'>";
    }
    
    sHtml += showrelatedsharename;
    sHtml += "<input type='hidden' name='shareid_"+curindex+"' value='"+relatedshareid+"'>";
    
    
    if(document.all("sharetype").value == "3"){
        sHtml += "/"+document.all("rolelevel").options[document.all("rolelevel").selectedIndex].text;
    }
    sHtml += "<input type='hidden' name='rolelevel_"+curindex+"' value='"+document.all("rolelevel").value+"'>";

    if(!(document.all("sharetype").value=="1"||document.all("sharetype").value=="6")){
        sHtml += "&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:"+document.all("seclevel").value+" - "+document.all("seclevelMax").value;
    }
    sHtml += "<input type='hidden' name='seclevel_"+curindex+"' value='"+document.all("seclevel").value+"'>";
	sHtml += "<input type='hidden' name='seclevelMax_"+curindex+"' value='"+document.all("seclevelMax").value+"'>";
    sHtml += "/"+document.all("sharelevel").options[document.all("sharelevel").selectedIndex].text;
    sHtml += "<input type='hidden' name='sharelevel_"+curindex+"' value='"+document.all("sharelevel").value+"'>";
	curindex++;
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
    
}

function deleteRow(){
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
    for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	} 
	if(rowsum1 == 0){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
		return; 
	}
		
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
		jQuery("body").jNice();
		
		
		for(i=len-1; i >= 0;i--) {
			if (document.forms[0].elements[i].name=='check_node'){
				if(document.forms[0].elements[i].checked==true) {
					oTable.deleteRow(rowsum1);	
				}
				rowsum1 -=1;
			}	
		}
	
	});
	 
}

</script>

</HTML>
