
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceConditionManager" class="weaver.workflow.request.ResourceConditionManager" scope="page"/>
<%   
String resourceCondition = Util.null2String(request.getParameter("resourceCondition"));
String isFromMode = Util.null2String(request.getParameter("isFromMode"));//是否来自于图形化表单，如果来自于图形化表单，则返回的值中将不带链接。
String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19303,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>

<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
           <script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
    <script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("19303",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}
	catch(e){}
	function getBrowserUrlFn(){
		var type=jQuery("#sharetype").val();
		var url = "";
		if(type=="1"){
			url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
		}else if(type=="2"){
			url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=#id#&selectedDepartmentIds=#id#";
		}else if(type=="3"){
			url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&selectedDepartmentIds=#id#";
		}else if(type=="4"){
			url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
		}
		return url;
	}
	function getajaxurl() {
		var type=jQuery("#sharetype").val();
		var value = "1";
		if (type == '1') {
			value = "1";
		} else if (type == '2') {
			value = "164";
		} else if (type == '3') {
			value = "4";
		} else if (type == '4') {
			value = "65";
		}else if (type == '6') {
			value = "24";
		}
      	return "/data.jsp?type=" + value;
    }
	function setrelatedsharenameofnolink(e,datas,name,params){
		 if (datas) {
		 	 jQuery("#showrelatedsharenameofnolink").html(datas.name);
		 }
	}
</script>
</HEAD>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/leftMenuCommon.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick();,_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear();,_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose();,_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
	%>
	<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<div class="zDialog_div_content">
<form name="weaver" id="weaver" action="#">
	<wea:layout>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>'>
			<wea:item>
				 <%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<!-- 
				<span style="float:left;">
				 -->
				<SELECT class=InputStyle  name=sharetype id="sharetype" onchange="onChangeSharetype(this)" style="float:left;width: 120px;">   
                    <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option><!-- 人员 -->
                    <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
                    <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
                    <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 --> 
                    <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
                    <option value="6"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option><!-- 岗位 -->
                </SELECT>
                <!--</span>
                &nbsp;&nbsp;
                <span id="browserBtn">
				<brow:browser width="250px" isSingle="false" hasInput="true" hasBrowser="true" _callback="setrelatedsharenameofnolink" name="relatedshareid" viewType="0" getBrowserUrlFn="getBrowserUrlFn" completeUrl="javascript:getAjaxUrl()" isMustInput="2"></brow:browser>
				<span id=showrelatedsharenameofnolink name=showrelatedsharenameofnolink style="display:none"></span> 
				</span>
				-->
			</wea:item>
			
			<wea:item attributes="{'samePair':\"objtr\"}" ><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></wea:item>
			<wea:item attributes="{'samePair':\"objtr\"}" >	
				<span id="relatedshareSpan">
				<brow:browser name="relatedshareid" viewType="0" hasBrowser="true" hasAdd="false" 
			 	   		   getBrowserUrlFn="onChangeResource"
	    				   isMustInput="2" isSingle="false" hasInput="true"
	     				   completeUrl="javascript:getajaxurl()"  width="150px" browserValue="" browserSpanValue=""/>
	     		</span>
			</wea:item>
			
			<wea:item attributes="{'samePair':'showrolelevel','display':'none'}">
				<%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
			</wea:item>
			<wea:item attributes="{'samePair':'showrolelevel','display':'none'}">
				 <SELECT  name=rolelevel>
                     <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
                     <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
                     <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
                 </SELECT>
			</wea:item>
			
			<wea:item attributes="{'samePair':'showlevel','display':'none'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
	    	<wea:item attributes="{'samePair':'showlevel','display':'none'}">
				<span id=showseclevel name=showseclevel>
					<INPUT class="InputStyle" style="width:50px;" type=text id=seclevel name=seclevel size=6 value="0" onchange="checkinput('seclevel','seclevelimage')">
				    <SPAN id=seclevelimage></SPAN>
				        - <INPUT class="InputStyle" style="width:50px;" type=text id=seclevel2 name=seclevel2 size=6 value="100" onchange="checkinput('seclevel2','seclevelimage2')">
				    <SPAN id=seclevelimage2></SPAN>
				</span>
	    	</wea:item>
	    	<!--  -->
	    	<wea:item attributes="{'samePair':'showjob','display':'none'}">
				<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
	 				</wea:item>
			<wea:item attributes="{'samePair':'showjob','display':'none'}">
				<select class=inputstyle  name=joblevel onchange="onChangeJobtype()" style="float:left;">
					<option value=0 ><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
					<option value=1 ><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
					<option value=2 selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				</select>
				<span id="relatedshareSpan_6" style="float:left;display:none;">
					<brow:browser name="relatedshareid_6" viewType="0" hasBrowser="true" hasAdd="false" 
				 	   		   getBrowserUrlFn="onChangeResourceForJob" 
		    				   isMustInput="2" isSingle="false" hasInput="true" 
		     				   completeUrl="javascript:getajaxurlforjob()"  width="150px" browserValue="" browserSpanValue=""/>
		     	</span>
			</wea:item>
	    	<!--  -->
			<%--
			<wea:item attributes="{'samePair':'showseclevel','display':'none'}">
				<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>
			</wea:item>
			<wea:item attributes="{'samePair':'showseclevel','display':'none'}">
				<INPUT type=text name=seclevel class=InputStyle style="width:50px;" size=6 value="10" onchange='checkinput("seclevel","seclevelimage")' onkeypress="ItemCount_KeyPress()">
                <span id=seclevelimage></span>
			</wea:item>
			 --%>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(19255,user.getLanguage())%>'>
			<wea:item type="groupHead">
				<input type="button" class="addbtn" onclick="addValue();" value=""></input>
				<input type="button" class="delbtn" onclick="group.deleteRows();" value=""></input>
			</wea:item>
			<wea:item attributes="{'isTableList':'true','colspan':'full'}">
				<div id="rcList"></div>
				<%String ajaxDatas = ResourceConditionManager.getBrowserTRString(resourceCondition,user.getLanguage(),true); %>
		     	<script type="text/javascript">
					var group = null;
					var ajaxDatas = <%=ajaxDatas%>
					jQuery(document).ready(function(){
						var items=[
							{width:"25%",colname:"<%=SystemEnv.getHtmlLabelNames("63",user.getLanguage())%>",itemhtml:"<span type='span' name='shareTypeSpan'></span><input type='hidden' name='shareTypeValue'><input type='hidden' name='shareTypeText'></input>"},
							{width:"55%",colname:"<%=SystemEnv.getHtmlLabelNames("106",user.getLanguage())%>",itemhtml:"<span type='span' name='relatedShareSpan'></span><input type='hidden' name='relatedShareIds'></input><input type='hidden' name='relatedShareNames'></input><input type='hidden' name='relatedShareNamesOfNoLink'></input>"},
							{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("683",user.getLanguage())%>",itemhtml:"<span type='span' name='secLevelSpan'></span><input type='hidden' name='secLevelValue'></input><input type='hidden' name='secLevelText'></input><input type='hidden' name='rolelevelValue'></input><input type='hidden' name='rolelevelText'></input>"}
							];
						var option = {
							basictitle:"",
							optionHeadDisplay:"none",
							colItems:items,
							container:"#shareList",
							toolbarshow:false,
							configCheckBox:true,
							usesimpledata:true,
							initdatas:ajaxDatas,
							openindex:false,
		          			checkBoxItem:{"itemhtml":'<input name="chkShareDetail" class="groupselectbox" type="checkbox" >',width:"5%"}
						};
						group=new WeaverEditTable(option);
						jQuery("#rcList").append(group.getContainer());
						});
				</script>
			</wea:item>
		</wea:group>
	</wea:layout>
</form>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{'groupDisplay':'none'}">
			<wea:item type="toolbar">
				<input type="button" accessKey=O  id=btnok value="<%="O-"+SystemEnv.getHtmlLabelName(826,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btnok_onclick();">
				<input type="button" accessKey=2  id=btnclear value="<%="2-"+SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="submitClear();">
		    	<input type="button" accessKey=T  id=btncancel value="<%="T-"+SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onClose();">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">
function btnCancel_Onclick(){
	if(dialog){
		dialog.close();
	}else{ 
	  window.parent.close();
	}
}

function onClose(){
	if(dialog){
		dialog.close();
	}else{
		window.parent.close();
	}
}



function submitClear()
{
	var returnjson = {id:"",name:""};
	if(dialog){
			try{
	        dialog.callback(returnjson);
	   		}catch(e){}
	
			try{
			     dialog.close(returnjson);
			 }catch(e){}
	}else{ 
	  window.parent.returnValue  = returnjson;
	  window.parent.close();
	}
}


function btnok_onclick(){
     setResourceStr();
   	var returnjson = "";
<%
    if("1".equals(isFromMode)){
%>
     returnjson = {id:shareTypeValues,name:shareTypeTexts,relatedIds:relatedShareIdses,relatedLink:relatedShareNamesesOfNoLink,
    	     rolevelIds:rolelevelValues,roleLevelText:rolelevelTexts,secLevelIds:secLevelValues,secLevelTexts:secLevelTexts};
<%
    }else{
%>
     returnjson = {id:shareTypeValues,name:shareTypeTexts,relatedIds:relatedShareIdses,relatedLink:relatedShareNameses,rolevelIds:rolelevelValues,
    		 roleLevelText:rolelevelTexts,secLevelIds:secLevelValues,secLevelTexts:secLevelTexts};
<%
    }
%>
	if(dialog){
		try{
        dialog.callback(returnjson);
   		}catch(e){}

		try{
		     dialog.close(returnjson);
		 }catch(e){}
	}else{ 
	  window.parent.returnValue  = returnjson;
	  window.parent.close();
	}
}

var shareTypeValues = ""
var shareTypeTexts = ""
var relatedShareIdses = ""
var relatedShareNameses = ""
var relatedShareNamesesOfNoLink = ""
var rolelevelValues = ""
var rolelevelTexts = ""
var secLevelValues = ""
var secLevelTexts = ""

function onChangeSharetype(_this){
	var tmpval = $("select[name=sharetype]").val();
	$("#relatedshareSpan").css("display","inline-block");
	jQuery("#relatedshareidspanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	jQuery("#relatedshareid_6spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	showEle("showlevel");
	showEle("objtr");
	hideEle("showrolelevel");
	hideEle("showjob");
	$("#relatedshareidspan").html("");
	$("#relatedshareid").val("");
	$("#relatedshareid_6span").html("");
	$("#relatedshareid_6").val("");
	if(tmpval=="1"){
		hideEle("showlevel");
	}else if(tmpval=="5"){//所有人
		hideEle("objtr");
		$("#relatedshareSpan").css("display","none");
		jQuery("#relatedshareidspanimg").html("");
		//$("div[class=e8_os]").parent().find("img").hide();
		$("#relatedshareid").val("");
	}else if(tmpval=="4"){//角色
		showEle("showrolelevel");
	}else if(tmpval=="6"){//岗位
		hideEle("showlevel");
		showEle("showjob");
	}
}

function onChangeResource(){
	var tmpval = $("select[name=sharetype]").val();
	var url = "";
	if (tmpval == "1") {
		url = onShowMutiResource();
	}else if(tmpval=="3"){
		url = onShowMutiDepartment();
	}else if(tmpval=="2"){
	    url = onShowMutiSubcompany();
	}else if(tmpval=="4"){
		url = onShowRole();
	}else if(tmpval=="5"){//所有人
		$("select[name=sharetype]").parent().find(".e8_os").hide();
	}else if(tmpval=="6"){
		url = onShowJob();
	}
	return url;
}

function onChangeJobtype(){
	var tmpval = jQuery("select[name=joblevel]").val();
	jQuery("#relatedshareSpan_6").show();
	jQuery("#relatedshareid_6span").html("");
	jQuery("#relatedshareid_6").val("");
	jQuery("#relatedshareid_6spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	if(tmpval=="2"){
		jQuery("#relatedshareSpan_6").hide();
		jQuery("#relatedshareid_6").val("");
	}
}

function onChangeResourceForJob(){
	var tmpval = jQuery("select[name=joblevel]").val();
	var url = "";
	if (tmpval == "0") {
		//url = onShowMutiDepartment(obj);
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#relatedshareid_6").val();
	}else if(tmpval=="1"){
	    //url = onShowMutiSubcompany(obj);
	    url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="+jQuery("#relatedshareid_6").val();
	}else if(tmpval=="2"){
		jQuery("select[name=joblevel]").parent().find(".e8_os").hide();
	}
	return url;
}

function getajaxurlforjob(){
	var tmpval = jQuery("select[name=joblevel]").val();
	var url = "";
	if (tmpval == "0") {
		url = "/data.jsp?type=4";
	}
	if (tmpval == "1") {
		url = "/data.jsp?type=194";
	}
	return url;
}

function check_by_permissiontype() {
    var re=/^\d+$/;
    var thisvalue=jQuery("select[name=sharetype]").val();
    var seclevel = jQuery("#seclevel").val();
    var seclevel2 = jQuery("#seclevel2").val();
    if (thisvalue == 1) {//人员
        return check_form(weaver, "relatedshareid");
    }else if (thisvalue == 2 || thisvalue == 3) {//分部、部门
        if(!re.test(seclevel) || !re.test(seclevel2) || parseInt(seclevel)>parseInt(seclevel2))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>");
            return false;
        }
        return check_form(weaver, "relatedshareid, seclevel, seclevel2")
    } else if (thisvalue == 4) {//角色
        if(!re.test(seclevel) || !re.test(seclevel2) || parseInt(seclevel)>parseInt(seclevel2))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>");
            return false;
        }
        return check_form(weaver, "relatedshareid, rolelevel, seclevel, seclevel2");
    } else if (thisvalue == 5) {//所有人
        if(!re.test(seclevel) || !re.test(seclevel2) || parseInt(seclevel)>parseInt(seclevel2))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>");
            return false;
        }
        return check_form(weaver, "seclevel,seclevel2")
    } else if (thisvalue == 6) {//岗位
        var joblevel = jQuery("select[name=joblevel]").val();
    	if(joblevel == "2"){
	        return check_form(weaver, "relatedshareid")
    	}else{
	        return check_form(weaver, "relatedshareid,relatedshareid_6")
    	}
    } else {
        return false;
    }
}

function addValue(){
	if(!check_by_permissiontype()){
        return ;
    }
	var thisvalue=jQuery("select[name=sharetype]").val();

	var shareTypeValue = thisvalue;
	var shareTypeText = jQuery(jQuery("select[name=sharetype]")[0].options.item(jQuery("select[name=sharetype]")[0].selectedIndex)).text();

    //人力资源(1),分部(2),部门(3),角色后的那个选项值不能为空(4),岗位(6)
    var relatedShareIds="0";
    var relatedShareNames="";
	var relatedShareNamesOfNoLink="";
    if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==6) {
        relatedShareIds = jQuery("input[name=relatedshareid]").val();
        //relatedShareNames= jQuery("#relatedshareidspan").html();
        jQuery("#relatedshareidspan").find("a").each(function (i,e){
			if(relatedShareNames == ""){
				relatedShareNames = jQuery(e).parent().html();
			}else{
				relatedShareNames += "," + jQuery(e).parent().html();
			}
		});
        
        //relatedShareNamesOfNoLink= $("#showrelatedsharenameofnolink").html();
        jQuery("#relatedshareidspan").find("a").each(function (i,e){
			if(relatedShareNamesOfNoLink == ""){
				relatedShareNamesOfNoLink = jQuery(e).text();
			}else{
				relatedShareNamesOfNoLink += "," + jQuery(e).text();
			}
		});
    }
    var rsarrayids = new Array();
    var secLevelValue="0";
    var secLevelText="";
    var relatedtemp = relatedShareNames;
	//非链接的共享人员
    var relatedShareNamesOfNoLinkTemp = relatedShareNamesOfNoLink;	
    rsarrayids = relatedShareIds.split(",");
    
    if(rsarrayids.length>0){
	    for(var i=0;i < rsarrayids.length;i++){
		    if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4 || thisvalue==6){
		    	relatedShareNames = relatedtemp.split(",")[i];
				relatedShareNamesOfNoLink = relatedShareNamesOfNoLinkTemp.split(",")[i];
		    }
		    
		    //岗位
		    if(thisvalue==6){
		    	//relatedShareNames = relatedShareNamesOfNoLink.split(",")[i];
		    	joblevel = jQuery("select[name=joblevel]").val();
		    	jobobj = jQuery("#relatedshareid_6").val();
				showiscanread = jQuery("#iscanread option:selected").text();
				iscanread = jQuery("#iscanread").val();
				if(joblevel == "0"){
					var rs6span = "";
					jQuery("#relatedshareid_6span").find("a").each(function (i,e){
						if(rs6span == ""){
							rs6span = jQuery(e).text();
						}else{
							rs6span += "," + jQuery(e).text();
						}
					});
					relatedShareNames += "/" + "<%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>" + "(" + rs6span + ")";
				}else if(joblevel == "1"){
					var rs6span = "";
					jQuery("#relatedshareid_6span").find("a").each(function (i,e){
						if(rs6span == ""){
							rs6span = jQuery(e).text();
						}else{
							rs6span += "," + jQuery(e).text();
						}
					});
					relatedShareNames += "/" + "<%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>" + "(" + rs6span + ")";
				}else{
					jobobj = "2";
					relatedShareNames += "/" + "<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
				}
				
				//岗位级别记录
				secLevelValue = joblevel + "|@|" + jobobj;
		    }
		    relatedShareIds = rsarrayids[i];
		    
		    //安全级别处理
		    //部门、分部、所有人安全级别记录,岗位与人员没有安全级别
		    if(thisvalue==2 || thisvalue==3 || thisvalue==4 || thisvalue==5){
		    	secLevelValue = jQuery("input[name=seclevel]").val();
		    	var seclevel2 = jQuery("input[name=seclevel2]").val();
				//if (secLevelText=="0") secLevelText="";
		        secLevelText=secLevelValue + "-" +seclevel2;
		        secLevelValue += "|@|" + seclevel2;
		    }
		    
		    var rolelevelValue=0;
		    var rolelevelText="";
		    if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
		       rolelevelValue = $("select[name=rolelevel]").val();
		       rolelevelText=$($("select[name=rolelevel]")[0].options.item($("select[name=rolelevel]")[0].selectedIndex)).text();
		       relatedShareNames += "/" + rolelevelText;
		    }
		
		    //共享类型 + 共享者ID +共享角色级别 +共享级别
		    //类型为岗位时，共享级别=岗位级别+"|@|"+指定对象，类型为部门、分部、角色、所有人时，共享级别=级别1+"|@|"+级别2
		    var totalValue=shareTypeValue+"_"+relatedShareIds+"_"+rolelevelValue+"_"+secLevelValue;
		   
		    var jsonArr = [
				{name:"chkShareDetail",type:"checkbox",value:totalValue,"iseditable":true},
				{name:"shareTypeValue",type:"input",value:shareTypeValue,"iseditable":true},
				{name:"shareTypeSpan",type:"span",value:shareTypeText,"iseditable":true},
				{name:"shareTypeText",type:"input",value:shareTypeText,"iseditable":true},
				{name:"relatedShareIds",type:"input",value:relatedShareIds,"iseditable":true},
				{name:"relatedShareSpan",type:"span",value:relatedShareNames,"iseditable":true},
				{name:"relatedShareNames",type:"input",value:relatedShareNames,"iseditable":true},
				//{name:"showrelatedsharenameofnolink",type:"input",value:showrelatedsharenameofnolink,"iseditable":true},
				{name:"rolelevelValue",type:"input",value:rolelevelValue,"iseditable":true},
				{name:"rolelevelSpan",type:"span",value:rolelevelText,"iseditable":true},
				{name:"rolelevelText",type:"input",value:rolelevelText,"iseditable":true},
				{name:"secLevelValue",type:"input",value:secLevelValue,"iseditable":true},
				{name:"secLevelSpan",type:"span",value:secLevelText,"iseditable":true},
				{name:"secLevelText",type:"input",value:secLevelText,"iseditable":true},
				{name:"relatedShareNamesOfNoLink",type:"input",value:relatedShareNamesOfNoLink,"iseditable":false}
			];
			group.addRow(jsonArr);
	    }
    }
	
}


function setResourceStr(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
		shareTypeValues += "~"+document.getElementsByName("shareTypeValue")[i].value;
		shareTypeTexts += "~"+document.getElementsByName("shareTypeText")[i].value;
		relatedShareIdses += "~"+document.getElementsByName("relatedShareIds")[i].value;
		relatedShareNameses += "~"+document.getElementsByName("relatedShareNames")[i].value;
		relatedShareNamesesOfNoLink += "~"+document.getElementsByName("relatedShareNamesOfNoLink")[i].value;
		rolelevelValues += "~"+document.getElementsByName("rolelevelValue")[i].value;
		rolelevelTexts += "~"+document.getElementsByName("rolelevelText")[i].value;
		secLevelValues += "~"+document.getElementsByName("secLevelValue")[i].value;
		secLevelTexts += "~"+document.getElementsByName("secLevelText")[i].value;

    }
}

</SCRIPT>
<script type="text/javascript">

function onShowMutiDepartment() {
	var thisvalue=$("select[name=sharelevel]").val();
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	return url;
}

function onShowMutiSubcompany() {
	var thisvalue=$("select[name=sharelevel]").val();
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	return url;
}
function onShowMutiResource() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+jQuery("#relatedshareid").val();
	return url;
}
function onShowRole() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
	return url;
}
function onShowJob() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	return url;
}

function btndelete_onclick(){
	removeValue();
}

function btnclear_onclick(){
     window.parent.parent.returnValue = {id:"",name:"",relatedIds:"",relatedLink:"",rolevelIds:"",roleLevelText:"",secLevelIds:"",secLevelTexts:""}
     window.parent.parent.close();
}

</script>


</body>
</html>
