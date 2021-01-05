
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.text.SimpleDateFormat,net.sf.json.JSONArray,net.sf.json.JSONObject" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs_smsvotingdetail" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_smsvoting" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="sptmForSmsVoting" class="weaver.splitepage.transform.SptmForSmsVoting" scope="page" />
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
if(!HrmUserVarify.checkUserRight("SmsVoting:Manager", user)){
	response.sendRedirect("/notice/noright.jsp");
	return ;
}
int smsvotingid = Util.getIntValue(request.getParameter("id"), 0);
if(smsvotingid == 0){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int isreopen = Util.getIntValue(request.getParameter("isreopen"), 0);
String subject = "";
String senddate = "";
String sendtime = "";
String enddate = "";
String endtime = "";
int isseeresult = 0;//0，投票人可查看；1，不可查看
String smscontent = "";
String remark = "";
String hrmids = "";
String hrmidsStr = "";
String hrmidsStrnew = "";
int status = -1;
int creater = 0;
String sql = "select * from smsvoting where id="+smsvotingid;
rs_smsvoting.execute(sql);
if(!rs_smsvoting.next()){
	response.sendRedirect("/notice/noright.jsp");
	return;
}else{
	creater = Util.getIntValue(rs_smsvoting.getString("creater"), 0);
	status = Util.getIntValue(rs_smsvoting.getString("status"), -1);
	if((status!=0 && isreopen==0) || creater!=user.getUID()){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	subject = Util.null2String(rs_smsvoting.getString("subject"));
	senddate = Util.null2String(rs_smsvoting.getString("senddate"));
	sendtime = Util.null2String(rs_smsvoting.getString("sendtime"));
	enddate = Util.null2String(rs_smsvoting.getString("enddate"));
	endtime = Util.null2String(rs_smsvoting.getString("endtime"));
	isseeresult = Util.getIntValue(rs_smsvoting.getString("isseeresult"), 0);
	smscontent = Util.null2String(rs_smsvoting.getString("smscontent"));
	remark = Util.null2String(rs_smsvoting.getString("remark"));
	hrmids = Util.null2String(rs_smsvoting.getString("hrmids"));
	String[] hrmid_sz = Util.TokenizerString2(hrmids, ",");
	if(hrmid_sz!=null && hrmid_sz.length>0){
		for(int i=0; i<hrmid_sz.length; i++){
			int hrmid = Util.getIntValue(hrmid_sz[i], 0);
			if(hrmid == 0){
				continue;
			}
			hrmidsStr += ("<a href=\"/hrm/resource/HrmResource.jsp?id="+hrmid+"\">"+resourceComInfo.getLastname(""+hrmid)+"</a>&nbsp;");
			hrmidsStrnew +=resourceComInfo.getLastname(""+hrmid)+",";
		}
	}
}
int wordsCount = smscontent.length();
String disabledStr = "";
if(isreopen == 1){
	disabledStr = " disabled ";
}

String statusStr = sptmForSmsVoting.getSmsVotingStatus(""+status, ""+user.getLanguage());
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(22304, user.getLanguage())+":"+SystemEnv.getHtmlLabelName(93, user.getLanguage())+"&nbsp;";
titlename += "<B>" + SystemEnv.getHtmlLabelName(602, user.getLanguage()) + ":&nbsp;</B>" + statusStr;
String needfav = "1";
String needhelp = "";

Calendar today = Calendar.getInstance();
String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
String currentTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":00";

String smscontentspanStr = "";
if("".equals(smscontent.trim())){
	SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	boolean hasBefore = false;//已经过了发送时间，直接发送
	hasBefore = inputFormat.parse(currentDate+" "+currentTime+":00").after(inputFormat.parse(senddate+" "+sendtime));
	if("".equals(senddate) || hasBefore==true){
		smscontentspanStr = "<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>";
	}
}

String selectStr = "";
int rowindex = 1;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(isreopen == 0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:onFrmSubmit(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}else if(isreopen == 1){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(244, user.getLanguage())+",javascript:onReopen(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;	
}

RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javascript:btn_cancle(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	   <td>
	    </td>
		<td class="rightSearchSpan" style="text-align:right; ">
			<%if(isreopen == 0){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" class="e8_btn_top middle" onclick="onFrmSubmit()"/>
			<%}else if(isreopen == 1){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(244,user.getLanguage()) %>" class="e8_btn_top middle" onclick="onReopen()"/>
			<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
		</td>
	</tr>
</table>

<div class="zDialog_div_content" style="overflow:auto;">
<form name=frmmain action="SmsVotingOperation.jsp" method=post >
<input type=hidden name=method value="edit">
<input type=hidden name=id value="<%=smsvotingid%>">
<input type=hidden name=status value="<%=status%>">
	<wea:layout type="2col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
			<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
			<wea:item>
				<input type="text" id="subject" name="subject" temptitle="<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>" value="<%=subject%>" class="inputStyle" onchange=checkinput('subject','subjectspan') style="width:80%" <%=disabledStr%>>
				<span id="subjectspan"><%if("".equals(subject.trim())){out.print("<IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle>");}%></span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(21723, user.getLanguage())%></wea:item>
			<wea:item>
				<input type=checkbox class="inputStyle" name="isseeresult" value="1" <%if(isseeresult==1){out.print("checked");}%> <%=disabledStr%>>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18961, user.getLanguage())%></wea:item>
			<wea:item>
				<input type="hidden" id="senddate" name="senddate" class=wuiDate  value="<%=senddate%>" >
				<%if(isreopen == 1){
					try{
						sendtime = sendtime.substring(0, 5);
					}catch(Exception e){}
				%>
				<input id="sendtime" name="sendtime" type="hidden" value="<%=sendtime%>">
				<SELECT id="sendtimeselect" name="sendtimeselect" <%=disabledStr%>>
				<%}else{%>
				<SELECT name="sendtime" onChange="changeSendtime()" <%=disabledStr%> style="width:80px;">
				<%}%>
				<%
				int sendtime_int = 9;
				try{
					sendtime_int = Util.getIntValue(sendtime.substring(0, 2), 9);
				}catch(Exception e){}
				for(int i = 0; i < 24; i++){
					if(i == sendtime_int){
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
				<input type="hidden" class=wuiDate name="enddate" id="enddate" value="<%=enddate%>">
				<SELECT name="endtime" id="endtime" style="width:80px;">
				<%
				int endtime_int = 18;
				try{
					endtime_int = Util.getIntValue(endtime.substring(0, 2), 18);
				}catch(Exception e){}
				for(int i = 0; i < 24; i++){
					if(i == endtime_int){
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
			<wea:item><textarea name="remark" class="inputStyle" rows=3 style="width:70%" <%=disabledStr%>><%=remark%></textarea></wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(15525, user.getLanguage())%></wea:item>
			<wea:item>
				<%if(isreopen == 1){%>
					<span id="hrmidsspan1"><%=hrmidsStr%></span>
				<%}%>
				<input type="hidden" name="hrmids" id="hrmids" value="<%=hrmids%>">
				<span <%if(isreopen == 1){%> style="display:none" <%}%>>
				<brow:browser viewType="0" name="hrmids" browserValue='<%=hrmids%>'  needHidden="false"
				browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
				hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='1'  width="300px"
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
				browserSpanValue='<%=hrmidsStrnew%>'></brow:browser>
				</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(18529, user.getLanguage())%></wea:item>
			<wea:item>
				<textarea id="smscontent" name="smscontent" class="inputStyle" rows=4 style="width:70%" onchange="checkinput_self(smscontent, smscontentspan)" onkeydown=printStatistic(this) onkeypress=printStatistic(this) onpaste=printStatistic(this) <%=disabledStr%>><%=smscontent%></textarea>
				<span id="smscontentspan" name="smscontentspan"><%=smscontentspanStr%></span>
				<FONT color=#ff0000><%=SystemEnv.getHtmlLabelName(20074,user.getLanguage())%><B><SPAN id="wordsCount" name="wordsCount"><%=wordsCount%></SPAN></B><%=SystemEnv.getHtmlLabelName(20075,user.getLanguage())%></FONT>
			</wea:item>
			<wea:item attributes="{\"isTableList\":true}">
				<%
					JSONArray root = new JSONArray(); 
					sql = "select * from smsvotingdetail where smsvotingid="+smsvotingid+" order by id asc";
					rs_smsvotingdetail.execute(sql);
					int rowcnt = 0;
					while(rs_smsvotingdetail.next()){
						String regcontent_tmp = Util.null2String(rs_smsvotingdetail.getString("regcontent"));
						String remark_tmp = Util.null2String(rs_smsvotingdetail.getString("remark"));
						//System.out.println(regcontent_tmp+"---"+remark_tmp);
						JSONArray node = new JSONArray();
						JSONObject nodeChld = new JSONObject();
						nodeChld.put("name","regcontent");
						nodeChld.put("value",regcontent_tmp);
						nodeChld.put("iseditable","true");
						nodeChld.put("type","select");
						node.add(nodeChld);
						
						nodeChld = new JSONObject();
						nodeChld.put("name","remark");
						nodeChld.put("value",remark_tmp);
						nodeChld.put("iseditable","true");
						nodeChld.put("type","input");
						node.add(nodeChld);
						
						root.add(node);
						rowcnt++;
					}
					//System.out.println("rowcnt:"+rowcnt);
				%>
				<input type="hidden"  name="rowcount" id="rowcount" value="<%=rowcnt%>" >
				<div class="listdiv"  style="width:100%"></div>
				<script>
					var rowidx = 0;
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
						 usesimpledata:true,
						 initdatas:eval('(<%=root.toString()%>)'),
						 addrowCallBack:function() {
							// alert("回调函数!!!");
							rowidx++;
							jQuery("#rowcount").val(rowidx);
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

var rowindex = <%=rowindex%>;
var selectStr = "";
for(var i=0; i<26; i++){
	var chooseStr = String.fromCharCode(i+97);
	selectStr += "<option value=\""+chooseStr+"\">"+chooseStr+"</option>";
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

	jQuery("body").jNice();
	jQuery("#regcontent_"+rowindex).selectbox('attach');
	rowindex = rowindex + 1;
}

function delChoose(){
	Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		var chks = document.getElementsByName("checkid");
		try{
			//alert(oTable.rows.length);
			//alert(chks.length);
			for(var i=chks.length-1; i>=0; i--){
				if(chks[i].checked == true){
					var row = chks[i];
					while(row.tagName != "TR"){
						row = row.parentNode;
					}
					//alert(i);
					//alert(row.rowIndex);
					jQuery("#oTable")[0].deleteRow(row.rowIndex);
				}
			}
		}catch(e){}
	}, function () {}, 320, 90,false);
}

function onFrmSubmit(){
	var senddate = document.getElementById("senddate").value;
	var sendtime = $("sendtime").val();
	if(check_form(document.frmmain, "subject") && check_self() && checkTime() ){
		if(senddate==null || senddate=="" || senddate<"<%=currentDate%>" || (senddate=="<%=currentDate%>" && sendtime<="<%=currentTime%>")){
			window.top.Dialog.confirm("\"<%=SystemEnv.getHtmlLabelName(18961, user.getLanguage())%>\"<%=SystemEnv.getHtmlLabelName(21423, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(22369, user.getLanguage())%>。\n<%=SystemEnv.getHtmlLabelName(22370, user.getLanguage())%>？",function (){
				document.frmmain.method.value = "edit";
				document.frmmain.submit();
				enableAllmenu();
			}, function () {}, 320, 90,false)
			
		} else {
			document.frmmain.method.value = "edit";
			document.frmmain.submit();
			enableAllmenu();
		}
	}
}

function onReopen(){
	if(checkTime()){
		document.frmmain.method.value = "reopen";
		document.frmmain.submit();
		enableAllmenu();
	}
}

function checkTime(){
	var senddate = document.getElementById("senddate").value;
	var sendtime = $("sendtime").val();
	var enddate = document.getElementById("enddate").value;
	var endtime = $("endtime").val();

	if(enddate==null || enddate==""){
		return true;
	}
	if(senddate!=null && senddate!=""){
		if(enddate < senddate){
			alert("<%=SystemEnv.getHtmlLabelName(22374, user.getLanguage())%>");
			return false;
		}else{
			if(enddate==senddate && endtime<=sendtime){
				alert("<%=SystemEnv.getHtmlLabelName(22374, user.getLanguage())%>");
				return false;
			}
		}
	}
	if(enddate < "<%=currentDate%>"){
		alert("<%=SystemEnv.getHtmlLabelName(22373, user.getLanguage())%>");
		return false;
	}else{
		if(enddate=="<%=currentDate%>" && endtime<="<%=currentTime%>"){
			alert("<%=SystemEnv.getHtmlLabelName(22373, user.getLanguage())%>");
			return false;
		}
	}
	return true;	
}

function check_sendNow(){
	try{
		if(senddate==null || senddate=="" || senddate<"<%=currentDate%>" || (senddate=="<%=currentDate%>" && sendtime<="<%=currentTime%>")){
			return confirm("\"<%=SystemEnv.getHtmlLabelName(18961, user.getLanguage())%>\"<%=SystemEnv.getHtmlLabelName(21423, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(22369, user.getLanguage())%>。\n<%=SystemEnv.getHtmlLabelName(22370, user.getLanguage())%>？");
		}else{
			return true;
		}
	}catch(e){}
	return true;
}

function check_self(){
	var senddate = document.getElementById("senddate").value;
	try{
		var smscontent = document.getElementById("smscontent").value;
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
var parentWin = null;
var dialog = null;
try{
parentWin = parent.parent.getParentWindow(parent);
dialog = parent.parent.getDialog(parent);
}catch(e){}
function btn_cancle(){
	parentWin.closeDialog();
}
</SCRIPT>
