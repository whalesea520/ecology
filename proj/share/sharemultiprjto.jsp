
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%

String isclose = Util.null2String(request.getParameter("isclose"));
if("1".equals( isclose)){
%>	
<script>
try {
	parent.getDialog(window).close();
} catch (e) {
	
}
</script>
<%
return;
}
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
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
boolean canEdit = true ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doShare(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
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
<FORM id=weaver name=weaver action="sharemultiprjop.jsp" method=post >
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
			  <option value="11"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'showsharetype'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showsharetype'}">
			<div id="resourceDiv">
				<brow:browser viewType="0" name="relatedshareida_1" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp" ></brow:browser> 
			</div>
			
			<div id="departmentDiv">
				<brow:browser viewType="0" name="relatedshareida_2" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=57" ></brow:browser> 
			</div>
			
			<div id="subcompanyDiv">
				<brow:browser viewType="0" name="relatedshareida_5" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp"
			         isSingle="false" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=164" ></brow:browser> 
			</div>
			
			<div id="roleDiv">
				<brow:browser viewType="0" name="relatedshareida_3" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
			         isSingle="true" hasBrowser="true" width="50%"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=65" ></brow:browser> 
			</div>
			<span id="showrolelevel"   style="display:none;">
						<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
						  <SELECT style="width:60px;" class=InputStyle name=rolelevel>
							<option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
						  </SELECT>
					</span>
			<span id="showrejob" style="display:none;">
			   <brow:browser viewType="0" name="relatedshareida_11" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=hrmjobtitles" />
			</span>
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
		 <wea:item attributes="{'samePair':'jobtitlescope','display':'none'}"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'jobtitlescope','display':'none'}">
			  <SELECT style="width: 60px;float: left;" class=InputStyle name=joblevel onchange="getScope();">
				<option selected value="0"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				<option value="1"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
				<option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
			  </SELECT>
			  <div>
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
			  </div>
			  <INPUT type=hidden name=scopeid value="">
			  <INPUT type=hidden id=scopeidname name=scopeidname value="">
		</wea:item>
		 <wea:item><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></wea:item>
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
					<td class=Field><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
					<td class=Field><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></td>
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
    if(curindex==0){
    	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(33027, user.getLanguage())%>");
    	return;
    }
    obj.disabled=true;
    weaver.submit();
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
  	checkinput("seclevel","seclevelimage");
  	checkinput("seclevelMax","seclevelMaximage");

  	hideEle('jobtitlescope');
  	jQuery("#resourceDiv").hide();
	jQuery("#subcompanyDiv").hide();
	jQuery("#roleDiv").hide();
	jQuery("#showrolelevel").hide();
	jQuery("#showrejob").hide();
  });
  
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
  	
	showEle('showseclevel',"true");
	showEle('showsharetype',"true");
	hideEle('jobtitlescope');
	jQuery("#resourceDiv").hide();
	jQuery("#departmentDiv").hide();
	jQuery("#subcompanyDiv").hide();
	jQuery("#roleDiv").hide();
	jQuery("#showrolelevel").hide();
	jQuery("#showrejob").hide();
	if(thisvalue==1){
		hideEle('showseclevel','true');
		jQuery("#resourceDiv").show();
	}
	
	if(thisvalue==2){
 		jQuery("#departmentDiv").show();
	}

	if(thisvalue==3){
 		jQuery("#roleDiv").show();
		jQuery("#showrolelevel").show();
	}
	if(thisvalue==4){
		hideEle("showsharetype","true");
	}
	if(thisvalue==5){
 		jQuery("#subcompanyDiv").show();
	}
	if(thisvalue==11){
		jQuery("#showrejob").show();
		hideEle('showseclevel','true');
		showEle('jobtitlescope');
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
function checkValid(){
	thisvalue=document.weaver.sharetype.value;
	if(thisvalue==4){
		jQuery("#relatedshareid").val("");
		jQuery("#showrelatedsharename").val("");
	}else{
		jQuery("#relatedshareid").val(jQuery("#relatedshareida_"+thisvalue).val());
		var index = 0;
		jQuery("#relatedshareida_"+thisvalue).parents("div").find(".e8_showNameClass").find("a").each(function (){
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
		checkinfo = "seclevel,seclevelMax";
	}
	if(thisvalue==11){
		var joblevel = jQuery("select[name=joblevel]").val();
 		if(joblevel==1){
 			jQuery("input[name=scopeid]").val(jQuery("#scopedeptid").val());
 			var index = 0;
 			jQuery("#scopeidname").val("");
 			jQuery("#scopedeptidspan").find("a").each(function (){
 				var name = $(this).html();
 				if(name != "" && typeof(name) != 'undefined') {
 					if(index > 0) {
 						name = jQuery("#scopeidname").val() + ','+name;
 					}
 					jQuery("#scopeidname").val(name); 
 					index ++;
 				}
 				
 			});
 			checkinfo = "relatedshareid,scopedeptid";
 		}else if(joblevel==2){
 			jQuery("input[name=scopeid]").val(jQuery("#scopesubcomid").val());
 			checkinfo = "relatedshareid,scopesubcomid";
 			var index = 0;
 			jQuery("#scopeidname").val(""); 
 			jQuery("#scopesubcomidspan").find("a").each(function (){
 				var name = $(this).html();
 				if(name != "" && typeof(name) != 'undefined') {
 					if(index > 0) {
 						name = jQuery("#scopeidname").val() + ','+name;
 					}
 					jQuery("#scopeidname").val(name); 
 					index ++;
 				}
 				
 			});
	 	}
		
		
	}
	return check_form(weaver,checkinfo);
}


function addRow(){
    if(!checkValid()){
        return;
    }
    var sharetype = document.weaver.sharetype.value;
    var relatedshareids = jQuery("#relatedshareid").val();
    var showrelatedsharenames = jQuery("#showrelatedsharename").val();
    if(sharetype==4){
   		addRows('','');
    }else{
	    if(relatedshareids != "") {
	    	var relateidarr = relatedshareids.split(",");
	    	var sharenamearr = showrelatedsharenames.split(",");
	    	for(var i =0;i< relateidarr.length; i++) {
	    		addRows(relateidarr[i], sharenamearr[i]);
	    	}
	    }
    }
}
var curindex=0;
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
    sHtml = showrelatedsharename;
    sHtml += "<input type='hidden' name='relatedshareid_"+curindex+"' value='"+relatedshareid+"'>";
    if(document.all("sharetype").value == "3"){
        sHtml += "/"+document.all("rolelevel").options[document.all("rolelevel").selectedIndex].text;
    }
    if(document.all("sharetype").value == "11"){
        var tempname = jQuery("#scopeidname").val();
        if(""!=tempname){
        	tempname="("+tempname+")";
        }
        sHtml += "/"+document.all("joblevel").options[document.all("joblevel").selectedIndex].text+tempname;
    }
    sHtml += "<input type='hidden' name='rolelevel_"+curindex+"' value='"+document.all("rolelevel").value+"'>";
    sHtml += "<input type='hidden' name='joblevel_"+curindex+"' value='"+document.all("joblevel").value+"'>";
    sHtml += "<input type='hidden' name='scopeid_"+curindex+"' value='"+document.all("scopeid").value+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
    
    oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    oDiv = document.createElement("div");
    sHtml = "";
    if(document.all("sharetype").value!="1"&&document.all("sharetype").value!="11"){
        sHtml += ""+document.all("seclevel").value+" - "+document.all("seclevelMax").value;
    }
    sHtml += "<input type='hidden' name='seclevel_"+curindex+"' value='"+document.all("seclevel").value+"'>";
	sHtml += "<input type='hidden' name='seclevelMax_"+curindex+"' value='"+document.all("seclevelMax").value+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
    
    
    oCell = oRow.insertCell(-1);
    oCell.style.background= rowColor;
    oDiv = document.createElement("div");
    sHtml = ""+document.all("sharelevel").options[document.all("sharelevel").selectedIndex].text;
    sHtml += "<input type='hidden' name='sharelevel_"+curindex+"' value='"+document.all("sharelevel").value+"'>";
    oDiv.innerHTML = sHtml;
    oCell.appendChild(oDiv);
    
	curindex++;
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
