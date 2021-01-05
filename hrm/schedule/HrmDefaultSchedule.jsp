
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<jsp:useBean id = "CompanyComInfo" class = "weaver.hrm.company.CompanyComInfo" scope = "page"/>
<jsp:useBean id = "SubCompanyComInfo" class = "weaver.hrm.company.SubCompanyComInfo" scope = "page"/>
<jsp:useBean id = "DepartmentComInfo" class = "weaver.hrm.company.DepartmentComInfo" scope = "page"/>
<jsp:useBean id = "ResourceComInfo" class = "weaver.hrm.resource.ResourceComInfo" scope = "page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%
if(!HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit" , user)) { 
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
} 
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>

<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<SCRIPT language = "javascript" src = "/js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript">
var parentWin = parent.parent.getParentWindow(parent);
var parentDialog = parent.parent.getDialog(parent);

var dialog = null;
if("<%=isclose%>"=="1"){
		parentWin.onBtnSearchClick();
		parentWin.closeDialog();	
	}

function closeDialog(){
	if(dialog)
		dialog.close();
}

function doSyn(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.Width = 500;
	dialog.Height = 100;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32763,user.getLanguage())%>"
	dialog.URL ="/hrm/schedule/HrmDefaultSynTemple.jsp";
	dialog.OKEvent = function(){
		var copyfrom = dialog.innerFrame.contentWindow.document.getElementById('copyfrom').value;
		var arrayObj = getFromValue(copyfrom);
		if(arrayObj){
			if($GetEle("chkObj1").checked){
				setTimeValue("mon",arrayObj);
			}
			if($GetEle("chkObj2").checked){
				setTimeValue("tue",arrayObj);
			}
			if($GetEle("chkObj3").checked){
				setTimeValue("wed",arrayObj);
			}
			if($GetEle("chkObj4").checked){
				setTimeValue("thu",arrayObj);
			}
			if($GetEle("chkObj5").checked){
				setTimeValue("fri",arrayObj);
			}
			if($GetEle("chkObj6").checked){
				setTimeValue("sat",arrayObj);
			}
			if($GetEle("chkObj7").checked){
				setTimeValue("sun",arrayObj);
			}
		}
		dialog.close();
	};
	dialog.show();
}

function getFromValue(copyfrom){
	var arrayObj = new Array();
	if(copyfrom == 1){
		arrayObj = getTimeValue("mon");
	}else if(copyfrom == 2){
		arrayObj = getTimeValue("tue");
	}else if(copyfrom == 3){
		arrayObj = getTimeValue("wed");
	}else if(copyfrom == 4){
		arrayObj = getTimeValue("thu");
	}else if(copyfrom == 5){
		arrayObj = getTimeValue("fri");
	}else if(copyfrom == 6){
		arrayObj = getTimeValue("sat");
	}else if(copyfrom == 7){
		arrayObj = getTimeValue("sun");
	}
	return arrayObj;
}

function getTimeValue(name){
	var arrayObj = new Array();
	arrayObj[0] = $GetEle(name+"starttime1").value;
	arrayObj[1] = $GetEle(name+"endtime1").value;
	arrayObj[2] = $GetEle(name+"starttime2").value;
	arrayObj[3] = $GetEle(name+"endtime2").value;
	return arrayObj;
}

function setTimeValue(name,arrayObj){
	$GetEle(name+"starttime1").value = arrayObj[0];
	$GetEle(name+"endtime1").value = arrayObj[1];
	$GetEle(name+"starttime2").value = arrayObj[2];
	$GetEle(name+"endtime2").value = arrayObj[3];
	
	$GetEle(name+"starttime1span").innerHTML = arrayObj[0];
	$GetEle(name+"endtime1span").innerHTML = arrayObj[1];
	$GetEle(name+"starttime2span").innerHTML = arrayObj[2];
	$GetEle(name+"endtime2span").innerHTML = arrayObj[3];
}

function resetCondtion(){
	//清空浏览按钮及对应隐藏域
	hideEle("spanShowRelatedIdLabel");
	changeSelectValue($GetEle("scheduleType").id,"3");
	changeSelectValue($GetEle("signType").id,"1");
	changeCheckboxStatus(jQuery("input[name=chkAllObj]"),false);
	changeCheckboxStatus(jQuery("input[name=chkObj1]"),false);
	changeCheckboxStatus(jQuery("input[name=chkObj2]"),false);
	changeCheckboxStatus(jQuery("input[name=chkObj3]"),false);
	changeCheckboxStatus(jQuery("input[name=chkObj4]"),false);
	changeCheckboxStatus(jQuery("input[name=chkObj5]"),false);
	changeCheckboxStatus(jQuery("input[name=chkObj6]"),false);
	changeCheckboxStatus(jQuery("input[name=chkObj7]"),false);
	//清空浏览按钮及对应隐藏域
	jQuery("#frmmain").find(".Browser").siblings("span").html("");
	jQuery("#frmmain").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#frmmain").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#frmmain").find(".e8_outScroll .e8_innerShow span").html("");
	//清空日期
	jQuery("#frmmain").find(".calendar").siblings("span").html("<IMG src = '/images/BacoError_wev8.gif' align = absMiddle>");
	jQuery("#frmmain").find(".calendar").siblings("input[type='hidden']").val("");
	jQuery("#frmmain").find(".Clock").siblings("span").html("");
	jQuery("#frmmain").find(".Clock").siblings("input[type='hidden']").val("");
	jQuery("#trTotal").hide();
}

function changeType(obj) {
	if(obj.value == 2){
		$(".signStartTimeDiv").show();
	} else {
		$(".signStartTimeDiv").hide();
	}
}
</script>
</head>
<%
String id = Util.null2String(request.getParameter("id")) ;
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16254 , user.getLanguage()) + "：" +    SystemEnv.getHtmlLabelName(93 , user.getLanguage()) ; 

String needfav = "1" ; 
String needhelp = "" ; 
boolean CanEdit = HrmUserVarify.checkUserRight("HrmDefaultScheduleEdit:Edit" , user) ; 
String totaltime = "" ; 
%>

<BODY>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%@ include file = "/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(CanEdit){
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(32761,user.getLanguage())+",javascript:resetCondtion(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(32760,user.getLanguage())+",javascript:doSyn(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
/*
if(HrmUserVarify.checkUserRight("HrmDefaultSchedule:Log" , user)){ 
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem ="+13+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}*/
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
		<%if(CanEdit){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave();">
		  <input type="button" value="<%=SystemEnv.getHtmlLabelName(32761,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="resetCondtion();">
		  <input type="button" value="<%=SystemEnv.getHtmlLabelName(32760,user.getLanguage())%>" id="zd_btn_submit" class="e8_btn_top" onclick="doSyn();">
		<%} %>	
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id = frmmain name = frmmain method = post >
<input class=inputstyle type = "hidden" name = "operation">

<input class=inputstyle type = "hidden" name = "id" value = "<%=id%>">


<%
    RecordSet.executeProc("HrmSchedule_Select_Default" , id) ; 
    if( RecordSet.next() ) {  
		String scheduleType=Util.null2String(RecordSet.getString("scheduleType"));
        int relatedId=Util.getIntValue(RecordSet.getString("relatedId"),0);
        String relatedName="";
            //获得对象名称
        if(scheduleType.equals("3")){
        	relatedName=CompanyComInfo.getCompanyname(""+relatedId);
        }else if(scheduleType.equals("4")){
        	relatedName=SubCompanyComInfo.getSubCompanyname(""+relatedId);
        }else if(scheduleType.equals("5")){
        	relatedName=DepartmentComInfo.getDepartmentname(""+relatedId);
        }else if(scheduleType.equals("6")){
        	relatedName=ResourceComInfo.getResourcename(""+relatedId);
        }            
            
%>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
    <wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
    <wea:item>
	    <select class="inputstyle" id="scheduleType" name="scheduleType" style="width:150px" onChange="javascript:clearRelatedInfo()">
          <option value="3" <% if(scheduleType.equals("3")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
     	    <option value="4" <% if(scheduleType.equals("4")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
		<!--  <option value="5" <% if(scheduleType.equals("5")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
     	    <option value="6" <% if(scheduleType.equals("6")) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>-->
     </select>
    </wea:item>
    <wea:item attributes="{'samePair':'spanShowRelatedIdLabel'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
    <wea:item attributes="{'samePair':'spanShowRelatedIdLabel'}">
	    <brow:browser viewType="0" name="relatedId" browserValue='<%=""+relatedId %>' 
       browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?selectedids="
       hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2' completeUrl="/data.jsp?type=164"
       _callback="jsSetRelatedname" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(""+relatedId) %>'></brow:browser>
			<input id=relatedname name=relatedname type=hidden value="">
    </wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(717 , user.getLanguage())%></wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = calendar type="button" onclick = "onShowDate(validedatefromspan,validedatefrom)"></button><%}%>
    <span id ="validedatefromspan"><%=Util.toScreen(RecordSet.getString("validedatefrom") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "validedatefrom" value ="<%=Util.toScreen(RecordSet.getString("validedatefrom") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = calendar type="button" onclick = "onShowDate(validedatetospan,validedateto)"></button><%}%>
    <span id = "validedatetospan"><%=Util.toScreen(RecordSet.getString("validedateto") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "validedateto" value ="<%=Util.toScreen(RecordSet.getString("validedateto") , user.getLanguage())%>">
    </wea:item>
	
	<wea:item><%=SystemEnv.getHtmlLabelName(82921,user.getLanguage())%></wea:item>
	<wea:item>
		<%
			String signType = weaver.common.StringUtil.vString(RecordSet.getString("sign_type") , "1");
			String signStartTime = weaver.common.StringUtil.vString(RecordSet.getString("sign_start_time"));
		%>
		<select class="inputstyle" id="signType" name="signType" onchange="changeType(this)">
			<option value="1" <%=signType.equals("1") ? "selected" : ""%>>1<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%></option>
			<option value="2" <%=signType.equals("2") ? "selected" : ""%>>2<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%></option>
		</select>
		<span style="margin-left:80px;display:<%=signType.equals("1") ? "none" : ""%>" class='signStartTimeDiv' >
			<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())+"2"+SystemEnv.getHtmlLabelNames("18083,20032,742",user.getLanguage())%>
			<button class="Clock" type="button" onclick="onShowFlowTime(signStartTimeSpan,signStartTime,1)"></button>
			<span id="signStartTimeSpan"><%=signStartTime%><%if(signStartTime.length() == 0){%><IMG src = '/images/BacoError_wev8.gif' align = absMiddle><%}%></span>
			<input type="hidden" name="signStartTime" value="<%=signStartTime%>">
		</span>
	</wea:item>
	</wea:group>
</wea:layout>
	<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'4','cws':'10%,20%,35%,35%','formTableId':'scheduleTable'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}" >
   	<wea:item type="thead"><input id="chkAllObj" name="chkAllObj" onclick="jsCheckAll(this)" type="checkbox" ></wea:item>
    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(28387 , user.getLanguage())%></wea:item>
    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16689 , user.getLanguage())%></wea:item>
    <wea:item type="thead"><%=SystemEnv.getHtmlLabelName(16690 , user.getLanguage())%></wea:item>
		<wea:item><input id="chkObj1" name="chkObj1" type="checkbox" ></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(392 , user.getLanguage())%></wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(monstarttime1span,monstarttime1)"></button><%}%>
    <span id = "monstarttime1span"><%=Util.toScreen(RecordSet.getString("monstarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden id = "monstarttime1" name = "monstarttime1" value = "<%=Util.toScreen(RecordSet.getString("monstarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(monendtime1span,monendtime1)"></button><%}%>
    <span id = "monendtime1span"><%=Util.toScreen(RecordSet.getString("monendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden id = "monendtime1" name = "monendtime1" value = "<%=Util.toScreen(RecordSet.getString("monendtime1") , user.getLanguage())%>">
    </wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(monstarttime2span,monstarttime2)"></button><%}%>
    <span id = "monstarttime2span"><%=Util.toScreen(RecordSet.getString("monstarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden id = "monstarttime2" name = "monstarttime2" value = "<%=Util.toScreen(RecordSet.getString("monstarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(monendtime2span,monendtime2)"></button><%}%>
    <span id = "monendtime2span"><%=Util.toScreen(RecordSet.getString("monendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden id = "monendtime2" name = "monendtime2" value = "<%=Util.toScreen(RecordSet.getString("monendtime2"),user.getLanguage())%>">
    </wea:item>
  	<wea:item><input id="chkObj2" name="chkObj2" type="checkbox" ></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(393 , user.getLanguage())%></wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(tuestarttime1span,tuestarttime1)"></button><%}%>
    <span id = "tuestarttime1span"><%=Util.toScreen(RecordSet.getString("tuestarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "tuestarttime1" value = "<%=Util.toScreen(RecordSet.getString("tuestarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(tueendtime1span,tueendtime1)"></button><%}%>
    <span id = "tueendtime1span"><%=Util.toScreen(RecordSet.getString("tueendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "tueendtime1" value = "<%=Util.toScreen(RecordSet.getString("tueendtime1") , user.getLanguage())%>">
    </wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(tuestarttime2span,tuestarttime2)"></button><%}%>
    <span id = "tuestarttime2span"><%=Util.toScreen(RecordSet.getString("tuestarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type =hidden name = "tuestarttime2" value = "<%=Util.toScreen(RecordSet.getString("tuestarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(tueendtime2span,tueendtime2)"></button><%}%>
    <span id = "tueendtime2span"><%=Util.toScreen(RecordSet.getString("tueendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "tueendtime2" value = "<%=Util.toScreen(RecordSet.getString("tueendtime2") , user.getLanguage())%>">
    </wea:item>
    <wea:item><input id="chkObj3" name="chkObj3" type="checkbox" ></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(394 , user.getLanguage())%></wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(wedstarttime1span,wedstarttime1)"></button><%}%>
    <span id = "wedstarttime1span"><%=Util.toScreen(RecordSet.getString("wedstarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "wedstarttime1" value = "<%=Util.toScreen(RecordSet.getString("wedstarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(wedendtime1span,wedendtime1)"></button><%}%>
    <span id = "wedendtime1span"><%=Util.toScreen(RecordSet.getString("wedendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "wedendtime1" value = "<%=Util.toScreen(RecordSet.getString("wedendtime1") , user.getLanguage())%>">
    </wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(wedstarttime2span,wedstarttime2)"></button><%}%>
    <span id = "wedstarttime2span"><%=Util.toScreen(RecordSet.getString("wedstarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "wedstarttime2" value = "<%=Util.toScreen(RecordSet.getString("wedstarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(wedendtime2span,wedendtime2)"></button><%}%>
    <span id = "wedendtime2span"><%=Util.toScreen(RecordSet.getString("wedendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name="wedendtime2" value = "<%=Util.toScreen(RecordSet.getString("wedendtime2") , user.getLanguage())%>">
    </wea:item>
    <wea:item><input id="chkObj4" name="chkObj4" type="checkbox" ></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(395 , user.getLanguage())%></wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(thustarttime1span,thustarttime1)"></button><%}%>
    <span id="thustarttime1span"><%=Util.toScreen(RecordSet.getString("thustarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "thustarttime1" value = "<%=Util.toScreen(RecordSet.getString("thustarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(thuendtime1span,thuendtime1)"></button><%}%>
    <span id = "thuendtime1span"><%=Util.toScreen(RecordSet.getString("thuendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "thuendtime1" value = "<%=Util.toScreen(RecordSet.getString("thuendtime1") , user.getLanguage())%>">
    </wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(thustarttime2span,thustarttime2)"></button><%}%>
    <span id = "thustarttime2span"><%=Util.toScreen(RecordSet.getString("thustarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "thustarttime2" value="<%=Util.toScreen(RecordSet.getString("thustarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(thuendtime2span,thuendtime2)"></button><%}%>
    <span id = "thuendtime2span"><%=Util.toScreen(RecordSet.getString("thuendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type =hidden name = "thuendtime2" value = "<%=Util.toScreen(RecordSet.getString("thuendtime2") , user.getLanguage())%>">
    </wea:item>
    <wea:item><input id="chkObj5" name="chkObj5" type="checkbox" ></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(396 , user.getLanguage())%></wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(fristarttime1span,fristarttime1)"></button><%}%>
    <span id = "fristarttime1span"><%=Util.toScreen(RecordSet.getString("fristarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "fristarttime1" value = "<%=Util.toScreen(RecordSet.getString("fristarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(friendtime1span,friendtime1)"></button><%}%>
    <span id = "friendtime1span"><%=Util.toScreen(RecordSet.getString("friendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "friendtime1" value="<%=Util.toScreen(RecordSet.getString("friendtime1") , user.getLanguage())%>">
    </wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(fristarttime2span,fristarttime2)"></button><%}%>
    <span id = "fristarttime2span"><%=Util.toScreen(RecordSet.getString("fristarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "fristarttime2" value = "<%=Util.toScreen(RecordSet.getString("fristarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(friendtime2span,friendtime2)"></button><%}%>
    <span id = "friendtime2span"><%=Util.toScreen(RecordSet.getString("friendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "friendtime2" value = "<%=Util.toScreen(RecordSet.getString("friendtime2") , user.getLanguage())%>">
    </wea:item>
    <wea:item><input id="chkObj6" name="chkObj6" type="checkbox" ></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(397 , user.getLanguage())%></wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(satstarttime1span,satstarttime1)"></button><%}%>
    <span id = "satstarttime1span"><%=Util.toScreen(RecordSet.getString("satstarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "satstarttime1" value = "<%=Util.toScreen(RecordSet.getString("satstarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(satendtime1span,satendtime1)"></button><%}%>
    <span id = "satendtime1span"><%=Util.toScreen(RecordSet.getString("satendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "satendtime1" value = "<%=Util.toScreen(RecordSet.getString("satendtime1") , user.getLanguage())%>">
    </wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(satstarttime2span,satstarttime2)"></button><%}%>
    <span id = "satstarttime2span"><%=Util.toScreen(RecordSet.getString("satstarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "satstarttime2" value = "<%=Util.toScreen(RecordSet.getString("satstarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(satendtime2span,satendtime2)"></button><%}%>
    <span id = "satendtime2span"><%=Util.toScreen(RecordSet.getString("satendtime2") , user.getLanguage())%></span>
    <input type = hidden name = "satendtime2" value = "<%=Util.toScreen(RecordSet.getString("satendtime2") , user.getLanguage())%>">
    </wea:item>
    <wea:item><input id="chkObj7" name="chkObj7" type="checkbox" ></wea:item>
    <wea:item><%=SystemEnv.getHtmlLabelName(398 , user.getLanguage())%></wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(sunstarttime1span,sunstarttime1)"></button><%}%>
    <span id = "sunstarttime1span"><%=Util.toScreen(RecordSet.getString("sunstarttime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "sunstarttime1" value = "<%=Util.toScreen(RecordSet.getString("sunstarttime1") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(sunendtime1span,sunendtime1)"></button><%}%>
    <span id = "sunendtime1span"><%=Util.toScreen(RecordSet.getString("sunendtime1") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "sunendtime1" value = "<%=Util.toScreen(RecordSet.getString("sunendtime1") , user.getLanguage())%>">
    </wea:item>
    <wea:item>
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(sunstarttime2span,sunstarttime2)"></button><%}%>
    <span id = "sunstarttime2span"><%=Util.toScreen(RecordSet.getString("sunstarttime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "sunstarttime2" value = "<%=Util.toScreen(RecordSet.getString("sunstarttime2") , user.getLanguage())%>">- 
    <%if(CanEdit){%>
    <button class = Clock type="button" onclick = "onShowTime(sunendtime2span,sunendtime2)"></button><%}%>
    <span id = "sunendtime2span"><%=Util.toScreen(RecordSet.getString("sunendtime2") , user.getLanguage())%></span>
    <input class=inputstyle type = hidden name = "sunendtime2" value = "<%=Util.toScreen(RecordSet.getString("sunendtime2") , user.getLanguage())%>">
    </wea:item>
    <wea:item><span style = "FONT-WEIGHT: bold; COLOR: red;" colspan="3"><%=SystemEnv.getHtmlLabelNames("16253,523" , user.getLanguage())%>
    <%totaltime = Util.toScreen(RecordSet.getString("totaltime") , user.getLanguage()) ; %>
		<%=totaltime%></span>
		</wea:item>	
		</wea:group>
		</wea:layout>
<%} %>  

 </form>
 <%if("1".equals(isDialog)){ %>
 </div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    <wea:group context="">
	    	<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentDialog.closeByHand();">
		    </wea:item>
		  </wea:group>
		</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
</BODY>
</HTML>

<script language = javascript>
function onShowRelatedId(){
	var scheduleType = $GetEle("scheduleType").value;
	if (scheduleType == "4"){
	    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp");
	}else if(scheduleType == "5"){
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp");
	}else if (scheduleType == "6"){
		data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	}
	if(data!=null){
	    if (data.id!= ""){
		    jQuery("#relatedNameSpan").html(data.name);
		    jQuery("input[name=relatedId]").val(data.id);
			jQuery("input[name=relatedname]").val(data.name);
		}else{
		    jQuery("#relatedNameSpan").html("")
		    jQuery("input[name=relatedId]").val("<IMG src = '/images/BacoError_wev8.gif' align = absMiddle>");
			jQuery("input[name=relatedname]").val("");
		}
	}

}

function doSave() {
    document.frmmain.action="HrmDefaultScheduleOperation.jsp" ; 
    document.frmmain.operation.value="editschedule" ; 

	var needToCheck="validedatefrom,validedateto";
	var scheduleType = $GetEle("scheduleType").value;
	if(scheduleType=="4") needToCheck+=",relatedId";
	var signType = $GetEle("signType").value;
	if(signType == 2) needToCheck+=",signStartTime"
	
    if(check_form(document.frmmain , needToCheck))  {
      if(
        ((document.frmmain.monstarttime1.value==""&&
          document.frmmain.monendtime1.value==""&&
          document.frmmain.monstarttime2.value==""&&
          document.frmmain.monendtime2.value=="")
        ||
         (document.frmmain.monstarttime1.value!=""&&
          document.frmmain.monendtime1.value!=""&&
          document.frmmain.monstarttime2.value!=""&&
          document.frmmain.monendtime2.value!=""))
        &&
          ((document.frmmain.tuestarttime1.value==""&&
          document.frmmain.tueendtime1.value==""&&
          document.frmmain.tuestarttime2.value==""&&
          document.frmmain.tueendtime2.value=="")
        ||
         (document.frmmain.tuestarttime1.value!=""&&
          document.frmmain.tueendtime1.value!=""&&
          document.frmmain.tuestarttime2.value!=""&&
          document.frmmain.tueendtime2.value!=""))
        &&
         ((document.frmmain.wedstarttime1.value==""&&
          document.frmmain.wedendtime1.value==""&&
          document.frmmain.wedstarttime2.value==""&&
          document.frmmain.wedendtime2.value=="")
        ||
         (document.frmmain.wedstarttime1.value!=""&&
          document.frmmain.wedendtime1.value!=""&&
          document.frmmain.wedstarttime2.value!=""&&
          document.frmmain.wedendtime2.value!=""))
        &&
         ((document.frmmain.thustarttime1.value==""&&
          document.frmmain.thuendtime1.value==""&&
          document.frmmain.thustarttime2.value==""&&
          document.frmmain.thuendtime2.value=="")
        ||
         (document.frmmain.thustarttime1.value!=""&&
          document.frmmain.thuendtime1.value!=""&&
          document.frmmain.thustarttime2.value!=""&&
          document.frmmain.thuendtime2.value!=""))
        &&
         ((document.frmmain.fristarttime1.value==""&&
          document.frmmain.friendtime1.value==""&&
          document.frmmain.fristarttime2.value==""&&
          document.frmmain.friendtime2.value=="")
        ||
         (document.frmmain.fristarttime1.value!=""&&
          document.frmmain.friendtime1.value!=""&&
          document.frmmain.fristarttime2.value!=""&&
          document.frmmain.friendtime2.value!=""))
        &&
         ((document.frmmain.satstarttime1.value==""&&
          document.frmmain.satendtime1.value==""&&
          document.frmmain.satstarttime2.value==""&&
          document.frmmain.satendtime2.value=="")
        ||
         (document.frmmain.satstarttime1.value!=""&&
          document.frmmain.satendtime1.value!=""&&
          document.frmmain.satstarttime2.value!=""&&
          document.frmmain.satendtime2.value!=""))
        &&
         ((document.frmmain.sunstarttime1.value==""&&
          document.frmmain.sunendtime1.value==""&&
          document.frmmain.sunstarttime2.value==""&&
          document.frmmain.sunendtime2.value=="")
        ||
         (document.frmmain.sunstarttime1.value!=""&&
          document.frmmain.sunendtime1.value!=""&&
          document.frmmain.sunstarttime2.value!=""&&
          document.frmmain.sunendtime2.value!=""))
         ){
			if(!checkSignType()) return;
			document.frmmain.submit();
         }else
             window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16696 , user.getLanguage())%>") ; 
   }
}
function clearTime(span, time) {
	$GetEle(time).value = "";
	$GetEle(span).innerHTML = "";
}
function checkSignType(){
	var signType = $GetEle("signType").value;
	var signStartTime = $GetEle("signStartTime").value;
	if(signType != 2 || signStartTime == "") return true;
	if(
        (document.frmmain.monendtime1.value!="" && document.frmmain.monstarttime2.value <= document.frmmain.monendtime1.value)
        ||
		(document.frmmain.tueendtime1.value!="" && document.frmmain.tuestarttime2.value <= document.frmmain.tueendtime1.value)
        ||
		(document.frmmain.wedendtime1.value!="" && document.frmmain.wedstarttime2.value <= document.frmmain.wedendtime1.value)
		||
		(document.frmmain.thuendtime1.value!="" && document.frmmain.thustarttime2.value <= document.frmmain.thuendtime1.value)
		||
		(document.frmmain.friendtime1.value!="" && document.frmmain.fristarttime2.value <= document.frmmain.friendtime1.value)
		||
		(document.frmmain.satendtime1.value!="" && document.frmmain.satstarttime2.value <= document.frmmain.satendtime1.value)
		||
		(document.frmmain.sunendtime1.value!="" && document.frmmain.sunstarttime2.value <= document.frmmain.sunendtime1.value)
	 ) {
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82930,user.getLanguage())%>", function(){
			if(document.frmmain.monendtime1.value!="" && document.frmmain.monstarttime2.value <= document.frmmain.monendtime1.value) clearTime("monstarttime2span", "monstarttime2");
			if(document.frmmain.tueendtime1.value!="" && document.frmmain.tuestarttime2.value <= document.frmmain.tueendtime1.value) clearTime("tuestarttime2span", "tuestarttime2");
			if(document.frmmain.wedendtime1.value!="" && document.frmmain.wedstarttime2.value <= document.frmmain.wedendtime1.value) clearTime("wedstarttime2span", "wedstarttime2");
			if(document.frmmain.thuendtime1.value!="" && document.frmmain.thustarttime2.value <= document.frmmain.thuendtime1.value) clearTime("thustarttime2span", "thustarttime2");
			if(document.frmmain.friendtime1.value!="" && document.frmmain.fristarttime2.value <= document.frmmain.friendtime1.value) clearTime("fristarttime2span", "fristarttime2");
			if(document.frmmain.satendtime1.value!="" && document.frmmain.satstarttime2.value <= document.frmmain.satendtime1.value) clearTime("satstarttime2span", "satstarttime2");
			if(document.frmmain.sunendtime1.value!="" && document.frmmain.sunstarttime2.value <= document.frmmain.sunendtime1.value) clearTime("sunstarttime2span", "sunstarttime2");
		 });
		 return false;
	 } else if(
		(document.frmmain.monendtime1.value!="" && (signStartTime <= document.frmmain.monendtime1.value || signStartTime >= document.frmmain.monstarttime2.value))
        ||
		(document.frmmain.tueendtime1.value!="" && (signStartTime <= document.frmmain.tueendtime1.value || signStartTime >= document.frmmain.tuestarttime2.value))
        ||
		(document.frmmain.wedendtime1.value!="" && (signStartTime <= document.frmmain.wedendtime1.value || signStartTime >= document.frmmain.wedstarttime2.value))
		||
		(document.frmmain.thuendtime1.value!="" && (signStartTime <= document.frmmain.thuendtime1.value || signStartTime >= document.frmmain.thustarttime2.value))
		||
		(document.frmmain.friendtime1.value!="" && (signStartTime <= document.frmmain.friendtime1.value || signStartTime >= document.frmmain.fristarttime2.value))
		||
		(document.frmmain.satendtime1.value!="" && (signStartTime <= document.frmmain.satendtime1.value || signStartTime >= document.frmmain.satstarttime2.value))
		||
		(document.frmmain.sunendtime1.value!="" && (signStartTime <= document.frmmain.sunendtime1.value || signStartTime >= document.frmmain.sunstarttime2.value))
	 ){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82927,user.getLanguage())%>", function() {$GetEle("signStartTimeSpan").innerHTML = "<IMG src = '/images/BacoError_wev8.gif' align = absMiddle>";$GetEle("signStartTime").value = "";});
		return false;
	 }
	 else return true;
}

function doDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7 , user.getLanguage())%>")) {
        document.frmmain.action="HrmDefaultScheduleOperation.jsp" ; 
		document.frmmain.operation.value = "deleteschedule" ; 
		document.frmmain.submit() ; 
	} 
} 
</script>
<SCRIPT language = javascript>
function ItemCount_KeyPress()
{ 
 if(!((window.event.keyCode>=48) && (window.event.keyCode<=58)))
  { 
     window.event.keyCode=0 ; 
  } 
} 
function checknumber(objectname)
{ 	
	valuechar = jQuery("#"+objectname).val().split("") ; 
	isnumber = false ; 
	for(i=0 ; i<valuechar.length ; i++) { charnumber = parseInt(valuechar[i]) ; if( isNaN(charnumber)&& valuechar[i]!=":") isnumber = true ;}
	if(isnumber) jQuery("#"+objectname).val(""); 
} 

function clearRelatedInfo(){
	var scheduleType = $GetEle("scheduleType").value;
	if(scheduleType=="3"){
		hideEle("spanShowRelatedIdLabel");
		jQuery("#relatedNameSpan").html("");
		jQuery("#relatedIdspan").html("");
		jQuery("input[name=relatedId]").val("");
		$GetEle("scheduleType").value = "";
	}else{
		jQuery("#relatedIdspanimg").html("<IMG src = '/images/BacoError_wev8.gif' align = absMiddle>");
		jQuery("input[name=relatedId]").val("");
		showEle("spanShowRelatedIdLabel");
	}
}

jQuery(document).ready(function(){
	var scheduleType = $GetEle("scheduleType").value;
	if(scheduleType=="3"){
		hideEle("spanShowRelatedIdLabel");
	}else{
		showEle("spanShowRelatedIdLabel");
	}
});

function jsCheckAll(obj){
	changeCheckboxStatus(jQuery("input[name=chkObj1]"),obj.checked);
	changeCheckboxStatus(jQuery("input[name=chkObj2]"),obj.checked);
	changeCheckboxStatus(jQuery("input[name=chkObj3]"),obj.checked);
	changeCheckboxStatus(jQuery("input[name=chkObj4]"),obj.checked);
	changeCheckboxStatus(jQuery("input[name=chkObj5]"),obj.checked);
	changeCheckboxStatus(jQuery("input[name=chkObj6]"),obj.checked);
	changeCheckboxStatus(jQuery("input[name=chkObj7]"),obj.checked);
}

function jsSetRelatedname(e,datas, name){
jQuery("#relatedname").val(datas.name);
}
</SCRIPT>

<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>

