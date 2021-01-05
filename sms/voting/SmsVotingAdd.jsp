
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="../../js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="../../js/selectDateTime_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script src="/js/tabs/jquery.tabs_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22304, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(82, user.getLanguage());
String needfav = "1";
String needhelp = "";

if(!HrmUserVarify.checkUserRight("SmsVoting:Manager", user)){
	response.sendRedirect("/notice/noright.jsp");
	return ;
}
String selectStr = "";
Calendar today = Calendar.getInstance();
String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currentTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":00";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:onFrmSubmit(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javascript:btn_cancle(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="onFrmSubmit()"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<div class="zDialog_div_content" style="overflow:auto;">

	<form name=frmmain action="SmsVotingOperation.jsp" method=post >
		<input type=hidden name=method value="add">
		<input type=hidden name=votingcount value="0">
		<input type=hidden name=status value="0">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>
					</wea:item>
					<wea:item>
						<input type="text" id="subject" name="subject" temptitle="<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>" value="" class="inputStyle" onchange=checkinput('subject','subjectspan') style="width:80%">
						<span id="subjectspan"><IMG src="/images/BacoError_wev8.gif" align=absMiddle></span>
					</wea:item>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(21723, user.getLanguage())%>
					</wea:item>
					<wea:item>
						<input type=checkbox class="inputStyle" name="isseeresult" value="1">
					</wea:item>
					<wea:item> <%=SystemEnv.getHtmlLabelName(18961, user.getLanguage())%></wea:item>
					<wea:item>
						<input type="hidden" class=wuiDate id="senddate" name="senddate" value="">
						<SELECT name="sendtime" onChange="changeSendtime()" style="width:80px;">
						<%
						for(int i = 0; i < 24; i++){
							if(i == 9){
								selectStr = " selected ";
							}else{
								selectStr = "";
							}
							out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" "+selectStr+">"+Util.add0(i, 2)+":00</OPTION>");
						}
						%>
						</SELECT>
						<font color="red"><%=SystemEnv.getHtmlLabelName(22354, user.getLanguage())%></font>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(743, user.getLanguage())%></wea:item>
					<wea:item>
						<input type="hidden" class=wuiDate name="enddate" value="" >
						<SELECT name="endtime" style="width:80px;">
						<%
						for(int i = 0; i < 24; i++){
							if(i == 0){
								selectStr = " selected ";
							}else{
								selectStr = "";
							}
							out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" "+selectStr+">"+Util.add0(i, 2)+":00</OPTION>");
						}
						%>
						</SELECT>
						<font color="red"><%=SystemEnv.getHtmlLabelName(22355, user.getLanguage())%></font>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(16284, user.getLanguage())%></wea:item>
					<wea:item>
						<textarea name="remark" class="inputStyle" rows=3 style="width:70%"></textarea>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15525, user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser viewType="0" name="hrmids" browserValue="" 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="300px"
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue=""></brow:browser>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(18529, user.getLanguage())%></wea:item>
					<wea:item>
						<textarea id="smscontent" name="smscontent" class="inputStyle" rows=4 style="width:70%" onchange="checkinput_self(smscontent, smscontentspan)" onkeydown=printStatistic(this) onkeypress=printStatistic(this) onpaste=printStatistic(this)></textarea>
						<span id="smscontentspan" name="smscontentspan"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
						<FONT color=#ff0000><%=SystemEnv.getHtmlLabelName(20074,user.getLanguage())%><B><SPAN id="wordsCount" name="wordsCount">0</SPAN></B><%=SystemEnv.getHtmlLabelName(20075,user.getLanguage())%></FONT>
					</wea:item>
					<wea:item attributes="{'isTableList':'true'}">
						<input type="hidden"  name="rowcount" id="rowcount" value="" >
						<div class="listdiv"  style="width:100%"></div>
						<script>
							var rowindex = 0;
							var optionStr = "";
							for(var i=0; i<26; i++){
								var chooseStr = String.fromCharCode(i+97);
								optionStr += "<option value='"+chooseStr+"'>"+chooseStr+"</option>";
							}
							var selectStr = "<select name='regcontent' style='width:80%'>";
							selectStr += optionStr;
							selectStr += "</select>";
							var items=[
								{width:"20%",colname:"<%=SystemEnv.getHtmlLabelName(1025, user.getLanguage())%>",itemhtml:selectStr},
								{width:"77%",colname:"<%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%>",itemhtml:"<input class='inputStyle' id='remark' name='remark' value='' style='width:80%'"}
							];

							var option= {
								 navcolor:"#00cc00",
								 basictitle:"<%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%>",
								 toolbarshow:true,
								 colItems:items,
								 openindex:true,
								 addrowtitle:true,
								 deleterowstitle:true,
								 copyrowtitle:false,
								 addrowCallBack:function() {
									// alert("回调函数!!!");
									rowindex++;
									jQuery("#rowcount").val(rowindex);
								 },
								configCheckBox:true,
								checkBoxItem:{"itemhtml":"<input type='checkbox' class='groupselectbox'><input type='hidden'  name='rowid' value='1' >",width:"3%"}
							};
							var group=new WeaverEditTable(option);
							$(".listdiv").append(group.getContainer());
						</script>
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
					value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>"
					id="zd_btn_cancle" class="e8_btn_cancel" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}

function btn_cancle(){
	parentWin.closeDialog();
}

function getName(str){
    re=new RegExp("<.*>","g")
    str1= str.replace(re,"")
    return str1
}
function getNumber(str){
    if(str.indexOf("<")<0)
    return ""
    re=new RegExp(".*<","g")
    str1=str.replace(re,"")
    re=new RegExp(">","g")
    str2=str1.replace(re,"")
    return str2
}



function addChoose(){
	var oRow = jQuery("#oTable")[0].insertRow(-1);
	var oRowIndex = oRow.rowIndex;
	if(oRowIndex%2 == 0){
		oRow.className="DataLight";
	}else{
		oRow.className="DataDark";
	}
	var oDiv;
	var oCell;
	oDiv = document.createElement("div");
	oDiv.innerHTML = "<input type=\"checkbox\" class=\"inputStyle\" id=\"checkid\" name=\"checkid\" value=\""+rowindex+"\"><input type=\"hidden\" id=\"rowid\" name=\"rowid\" value=\""+rowindex+"\">";
	oCell = oRow.insertCell(-1);
	oCell.appendChild(oDiv);

	oDiv = document.createElement("div");
	var htmlStr = "<select id=\"regcontent_"+rowindex+"\" name=\"regcontent_"+rowindex+"\" style=\"width:80%\">";
	htmlStr += selectStr;
	htmlStr += "</select>";
	oDiv.innerHTML = htmlStr;
	oCell = oRow.insertCell(-1);
	oCell.appendChild(oDiv);

	oDiv = document.createElement("div");
	oDiv.innerHTML = "<input class=\"inputStyle\" id=\"remark_"+rowindex+"\" name=\"remark_"+rowindex+"\" value=\"\" style=\"width:80%\">";
	oCell = oRow.insertCell(-1);
	oCell.appendChild(oDiv);

	jQuery("#regcontent_"+rowindex).selectbox('attach');
	jQuery("body").jNice();
	rowindex = rowindex + 1;
	
}

function delChoose(){
	//if(isdel()){
	//	var chks = document.getElementsByName("checkid");
	//	try{
	//		for(var i=chks.length-1; i>=0; i--){
	//			if(chks[i].checked == true){
	//				jQuery("#oTable")[0].deleteRow(chks[i].parentNode.parentNode.parentNode.rowIndex);
	//			}
	//		}
	//	}catch(e){}
	//}
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
			len = document.forms[0].elements.length;
			var i=0;
			var rowsum1 = 0;
			for(i=len-1; i >= 0;i--) {
				if (document.forms[0].elements[i].name=='checkid')
					rowsum1 += 1;
			}
			for(i=len-1; i >= 0;i--) {
				if (document.forms[0].elements[i].name=='checkid'){
					if(document.forms[0].elements[i].checked==true) {
						oTable.deleteRow(rowsum1-1);	
					}
					rowsum1 -=1;
				}
			
			}
		}, function () {}, 320, 90,false);
	
}

function onFrmSubmit(){
	var senddate = $("senddate").val();
	var sendtime = $("sendtime").val();
	if(check_form(document.frmmain,"subject") && check_self() && checkTime() ){
		if(senddate==null || senddate=="" || senddate<"<%=currentDate%>" || (senddate=="<%=currentDate%>" && sendtime<="<%=currentTime%>")){
			window.top.Dialog.confirm("\"<%=SystemEnv.getHtmlLabelName(18961, user.getLanguage())%>\"<%=SystemEnv.getHtmlLabelName(21423, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(22369, user.getLanguage())%>。\n<%=SystemEnv.getHtmlLabelName(22370, user.getLanguage())%>？",function (){
				document.frmmain.submit();
				enableAllmenu();
			}, function () {}, 320, 90,false);
		}else{
			document.frmmain.submit();
			enableAllmenu();
			
		}
	}
}

function check_sendNow(){
	try{
		var senddate = $("senddate").val();
		var sendtime = $("sendtime").val();
		if(senddate==null || senddate=="" || senddate<"<%=currentDate%>" || (senddate=="<%=currentDate%>" && sendtime<="<%=currentTime%>")){
			return confirm("\"<%=SystemEnv.getHtmlLabelName(18961, user.getLanguage())%>\"<%=SystemEnv.getHtmlLabelName(21423, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(22369, user.getLanguage())%>。\n<%=SystemEnv.getHtmlLabelName(22370, user.getLanguage())%>？");
		}else{
			return true;
		}
	}catch(e){}
	return true;
}

function checkTime(){
	var senddate = $("senddate").val();
	var sendtime = $("sendtime").val();
	var enddate = $("enddate").val();
	var endtime = $("endtime").val();
	if(enddate==null || enddate==""){
		return true;
	}
	if(senddate!=null && senddate!=""){
		if(enddate < senddate){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22374, user.getLanguage())%>");
			return false;
		}else{
			if(enddate==senddate && endtime<=sendtime){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22374, user.getLanguage())%>");
				return false;
			}
		}
	}
	if(enddate < "<%=currentDate%>"){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22373, user.getLanguage())%>");
		return false;
	}else{
		if(enddate=="<%=currentDate%>" && endtime<="<%=currentTime%>"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22373, user.getLanguage())%>");
			return false;
		}
	}
	return true;	
}

function check_self(){
	var senddate = $("#senddate").val();
	try{
		var smscontent = $("#smscontent").val();
		if(senddate==null || senddate==""){
			if(smscontent==null || smscontent==""){
				window.top.Dialog.alert("\"<%=SystemEnv.getHtmlLabelName(18529, user.getLanguage())%>\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
				return false;
			}
		}
		
	}catch(e){}
	var rowids = document.getElementsByName("rowid");
	var chooseStr = ",";
	try{
		for(var i=0; i<rowids.length; i++){
			try{
				var rowid = rowids[i].value;
				var chooseValue = document.getElementById("regcontent_"+rowid).value;
				if(chooseStr.indexOf(","+chooseValue+",")>-1){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22356, user.getLanguage())%>");
					return false;
				}else{
					chooseStr += (chooseValue+",");
				}
			}catch(e){}
		}
	}catch(e){}
	return true;
}

function onShowVotingDate(spanname, inputname){	
	WdatePicker_send(spanname, inputname);
}

function onShowEndDate(spanname, inputname){	
	WdatePicker_end(spanname, inputname);
}

function WdatePicker_send(spanname, inputname){
	WdatePicker(
			{
				onpicked:function(dp){
					returnvalue = dp.cal.getDateStr();	
					$dp.$(spanname).innerHTML = returnvalue;
					$dp.$(inputname).value = returnvalue;
					$dp.$("smscontentspan").innerHTML = "";
					if($dp.$(inputname).value<"<%=currentDate%>" || ($dp.$(inputname).value=="<%=currentDate%>" && $dp.$("sendtime").value<="<%=currentTime%>")){
						if($dp.$("smscontent").value==null || $dp.$("smscontent").value==""){
							$dp.$("smscontentspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
						}else{
							$dp.$("smscontentspan").innerHTML = "";
						}
					}else{
						$dp.$("smscontentspan").innerHTML = "";
					}
				},
				oncleared:function(){
					$(spanname).innerHTML = ""; 
					$(inputname).value = "";
					if($dp.$("smscontent").value==null || $dp.$("smscontent").value==""){
						$dp.$("smscontentspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
					}else{
						$dp.$("smscontentspan").innerHTML = "";
					}
				}
			}
		);
}

function WdatePicker_end(spanname, inputname){
	WdatePicker(
			{
				onpicked:function(dp){
					returnvalue = dp.cal.getDateStr();	
					$dp.$(spanname).innerHTML = returnvalue;
					$dp.$(inputname).value = returnvalue;
				},
				oncleared:function(){
					$(spanname).innerHTML = ""; 
					$(inputname).value = "";
				}
			}
		);
}

function onCheckAll(obj){
	var check = obj.checked;
	var chks = document.getElementsByName("checkid");
	try{
		for(var i=0; i<chks.length; i++){
			chks[i].checked = check;
			var $span = jQuery(chks[i]).next('span');
			if (check) { 
				if(!$span.hasClass('jNiceChecked')){
					$span.addClass('jNiceChecked');
				 }
			} else {
				if($span.hasClass('jNiceChecked')){
					$span.removeClass('jNiceChecked');
				}
			}
		}
	}catch(e){}
}

function changeSendtime(){
	var senddate = document.all("senddate").value;
	var sendtime = document.all("sendtime").value;
	if(senddate==null || senddate=="" || senddate<"<%=currentDate%>" || (senddate=="<%=currentDate%>" && sendtime<="<%=currentTime%>")){
		if(document.all("smscontent").value==null || document.all("smscontent").value==""){
			document.all("smscontentspan").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}
	}else{
		document.all("smscontentspan").innerHTML = "";
	}
}

function checkinput_self(elementname, spanid){
	var senddate = frmmain.senddate.value;
	var sendtime = frmmain.sendtime.value;
	var viewtype = 0;
	if(senddate==null || senddate==""){
		viewtype = 1;
	}else if(senddate=="<%=currentDate%>" && sendtime<="<%=currentTime%>"){
		viewtype = 1;
	}
	if(viewtype==1){
		var tmpvalue = elementname.value;

		while(tmpvalue.indexOf(" ") == 0){
			tmpvalue = tmpvalue.substring(1, tmpvalue.length);
		}
		if(tmpvalue!=""){
			spanid.innerHTML = "";
		}else{
			spanid.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
			elementname.value = "";
		}
	}
}
function printStatistic(o){
	setTimeout(function()
	{
		var inputLength = o.value.length;
		document.all("wordsCount").innerHTML = inputLength;
	}
	,1)
}

jQuery(document).ready(function(){

	resizeDialog(document);
});
</SCRIPT>
