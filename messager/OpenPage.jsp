
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
String type=Util.null2String(request.getParameter("type"));
String sendTo=Util.null2String(request.getParameter("sendTo"));

String sendToUserId="";
if(sendTo.indexOf("@")!=-1) sendTo=sendTo.substring(0,sendTo.indexOf("@"));
rs.executeSql("select id from hrmresource where loginid='"+sendTo+"'");
if(rs.next()){
	sendToUserId=Util.null2String(rs.getString("id"));		
}

int userid=user.getUID();
String username = user.getUsername();
int userLength = username.length()+Util.null2String(String.valueOf(userid)).length()+3;	

if("email".equals(type)) {
%>
<html>
<head>
	<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
	<script type="text/javascript" src="/messager/jquery_wev8.js"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<span id="SendMailResult" style="color: red;"></span>
<table width="100%">
	<tr>
		<td valign="top">
		<form id="weaver" name="weaver" action="MessagerDataForEcology.jsp" method="post">
		<input type="hidden" name="method" value="sendMail">
		<table id="tblForm" class="ViewForm" style="height:100%">
		<colgroup>
			<col width="20%">
			<col width="80%">
		</colgroup>
		<tbody>
		
		<tr height="22">
			<td><%=SystemEnv.getHtmlLabelName(571, user.getLanguage())%></td>
			<td class="Field">
				<select name="mailAccountId" id="mailAccountId" style="width:96%" onChange="checkinput('mailAccountId','mailAccountIdSpan')">
				<%
				int count = 0;
				rs.executeSql("SELECT * FROM MailAccount WHERE userId="+user.getUID()+" ORDER BY accountName");
				while(rs.next()){
				%>
				<option value="<%=rs.getInt("id")%>" 
					<%if(rs.getString("isDefault").equals("1")){out.print("selected=\"selected\"");}%>>
					<%=rs.getString("accountName")%>
				</option>
				<%
				count ++;
				} %>
				</select><span id="mailAccountIdSpan">
				<%if(count==0){%><img src='/images/BacoError_wev8.gif' align="absMiddle"><%}%>
				</span>
			</td>
		</tr>
		<tr style="height: 1px"><td class="Line" colspan="2"></td></tr>
			
		<tr height="22">
			<td><%=SystemEnv.getHtmlLabelName(2046, user.getLanguage())%></td>
			<td class="Field">
			<%=rc.getEmail(sendToUserId)%>
			<input id="receiver" name="receiver" class="inputstyle" type="hidden" style="width:96%" value="<%=rc.getEmail(sendToUserId)%>"><span id="receiverSpan">
			<%if(rc.getEmail(sendToUserId)==null||"".equals(rc.getEmail(sendToUserId))){%><img src='/images/BacoError_wev8.gif' align="absMiddle"><%}%>
			</span>
			</td>
		</tr>
		<tr style="height: 1px"><td class="Line" colspan="2"></td></tr>
			
			
		<tr height="22">
			<td><%=SystemEnv.getHtmlLabelName(848, user.getLanguage())%></td>
			<td class="Field">
				<select name="priority" style="width:96%">
				<option value="3"><%=SystemEnv.getHtmlLabelName(2086, user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(15533, user.getLanguage())%></option>
				<option value="4"><%=SystemEnv.getHtmlLabelName(19952, user.getLanguage())%></option>
				</select>
			</td>
		</tr>
		<tr style="height: 1px"><td class="Line" colspan="2"></td></tr>
			
		<tr height="22">
			<td><%=SystemEnv.getHtmlLabelName(344, user.getLanguage())%></td>
			<td class="Field">
				<input type="text" id="mailSubject" name="mailSubject" class="inputstyle" style="width:96%" value="" onChange="checkinput('mailSubject','mailSubjectSpan')">
				<span id="mailSubjectSpan"><img src='/images/BacoError_wev8.gif' align="absMiddle"></span>
			</td>
		</tr>
		<tr style="height: 1px"><td class="Line" colspan="2"></td></tr>
		
		<tr height="90">
			<td><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></td>
			<td class="Field">
				<textarea class=InputStyle name="mouldtext" id="mouldtext" style="width:96%;height:100%"></textarea>
			</td>
		</tr>
		<tr style="height: 1px"><td class="Line" colspan="2"></td></tr>
		
		<tr height="50">
			<td colspan="2" align="center">  
				<span style="width:48px;height:24px;background:url('/messager/images/buttonbg_wev8.gif') no-repeat;color:#555555;padding:7 12;margin:3px;cursor:hand;" onclick="javascript:sendEmail();"><%=SystemEnv.getHtmlLabelName(2083, user.getLanguage())%></span>
				<span style="width:48px;height:24px;background:url('/messager/images/buttonbg_wev8.gif') no-repeat;color:#555555;padding:7 12;margin:3px;cursor:hand;" onclick="javascript:gotoEmail();"><%=SystemEnv.getHtmlLabelName(17499, user.getLanguage())%></span>
			</td>
		</tr>
		
		</tbody>
		</table>
		
		</form>
		</td>
	</tr>
</table>
<script type="text/javascript">
function sendEmail(){
	if(check_form(weaver,'mailAccountId')&&check_form(weaver,'receiver')&&check_form(weaver,'receiver')&&check_form(weaver,'mailSubject')){
	$.post(
		"/messager/MessagerDataForEcology.jsp",
		$("#weaver").serializeArray(),
		function(data){
			if($.trim(data)=="true"){
				$('#SendMailResult').html("<%=SystemEnv.getHtmlLabelName(2044, user.getLanguage())%>");
				setTimeout("location.reload();", 5000);
			}else{
				$('#SendMailResult').html("<%=SystemEnv.getHtmlLabelName(2045, user.getLanguage())%>");
				setTimeout("location.reload();", 5000);
			}
		}
	);
	}
}

function gotoEmail(){
	window.open("/email/MailAdd.jsp?to=<%=rc.getEmail(sendToUserId)%>");	
}
</script>
</body>
</html>
<%	
	//response.sendRedirect("/email/MailAdd.jsp");
} else if("sms".equals(type)) {
	if(!HrmUserVarify.checkUserRight("CreateSMS:View", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
%>
<html>
<head>
	<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />
	<script type="text/javascript" src="/messager/jquery_wev8.js"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<span id="SendSMSResult" style="color: red;"></span>
<table width="100%">
	<tr>
		<td valign="top">
		<form id="weaver" name="weaver" action="MessagerDataForEcology.jsp" method="post">
		<input type="hidden" name="method" value="sendSMS">
		<input type="hidden" name="sendnumber" value="<%=rc.getMobile(user.getUID()+"")%>">
		<table id="tblForm" class="ViewForm" style="height:100%">
		<colgroup>
			<col width="25%">
			<col width="75%">
		</colgroup>
		<tbody>
		
		<tr height="22">
			<td><%=SystemEnv.getHtmlLabelName(18536,user.getLanguage())%></td>
			<td class="Field">
				<%=rc.getMobile(sendToUserId)%>
				<input type="hidden" id="recievenumber" name="recievenumber" class="inputstyle" style="width:100%" value="<%=rc.getMobile(sendToUserId)%>">
				<input type="hidden" id="recievehrmid" name="recievehrmid" class="inputstyle" style="width:100%" value="<%=sendToUserId%>">
				<span id="recievenumberSpan">
				<%if(rc.getMobile(sendToUserId)==null||"".equals(rc.getMobile(sendToUserId))){%>
				<img src='/images/BacoError_wev8.gif' align="absMiddle">
				<%} %>
				</span>
			</td>
		</tr>
		<tr style="height: 1px"><td class="Line" colspan="2"></td></tr>
		
		<tr height="165">
			<td><%=SystemEnv.getHtmlLabelName(345, user.getLanguage())%></td>
			<td class="Field">
				<FONT color=#ff0000><%=SystemEnv.getHtmlLabelName(20074,user.getLanguage())%> <B><SPAN id="wordsCount" name="wordsCount">0</SPAN></B> <%=SystemEnv.getHtmlLabelName(20075,user.getLanguage())%> <%=SystemEnv.getHtmlLabelName(20076,user.getLanguage())%> <B><SPAN id="messagesCount" name="messagesCount">0</SPAN></B> <%=SystemEnv.getHtmlLabelName(20097,user.getLanguage())%>.</FONT>
				<TEXTAREA class=InputStyle style="width:96%;height:90%;word-break:break-all" id=message name=message onkeydown="printStatistic(this)" onkeypress="printStatistic(this)" onpaste="printStatistic(this)"></TEXTAREA>
				<span id="messageSpan"><img src='/images/BacoError_wev8.gif' align="absMiddle"></span>
			</td>
		</tr>
		<tr style="height: 1px"><td class="Line" colspan="2"></td></tr>
		
		<tr height="50">
			<td colspan="2" align="center">
				<span style="width:48px;height:24px;background:url('/messager/images/buttonbg_wev8.gif') no-repeat;color:#555555;padding:7 12;margin:3px;cursor:hand;" onclick="javascript:sendSMS();"><%=SystemEnv.getHtmlLabelName(2083, user.getLanguage())%></span>
				<span style="width:48px;height:24px;background:url('/messager/images/buttonbg_wev8.gif') no-repeat;color:#555555;padding:7 12;margin:3px;cursor:hand;" onclick="javascript:gotoSMS();"><%=SystemEnv.getHtmlLabelName(17499, user.getLanguage())%></span>
			</td>
		</tr>
		
		</tbody>
		</table>
		
		</form>
		</td>
	</tr>
</table>

<script type="text/javascript">
function sendSMS(){
	if(check_form(weaver,'recievenumber')&&check_form(weaver,'message')){
	$.post(
		"/messager/MessagerDataForEcology.jsp",
		$("#weaver").serializeArray(),
		function(data){
			if($.trim(data)=="true"){
				$('#SendSMSResult').html("<%=SystemEnv.getHtmlLabelName(24543, user.getLanguage())%>");
				setTimeout("location.reload();", 5000);
			}else{
				$('#SendSMSResult').html("<%=SystemEnv.getHtmlLabelName(24544, user.getLanguage())%>");
				setTimeout("location.reload();", 5000);
			}
		}
	);
	}
}

function printStatistic(o)
{
	setTimeout(function()
	{
		var inputLength = o.value.length;
		document.all("wordsCount").innerHTML = inputLength;
		if((inputLength+<%=userLength%>)> 63 ){
			document.all("messagesCount").innerHTML = (0 == inputLength ? 0 : Math.floor((inputLength+<%=userLength%>-1) / 60) + 1);
		}else{
			document.all("messagesCount").innerHTML = 1;
		}
		checkinput('message','messageSpan');
	}
	,1)
}

function gotoSMS(){
	window.open("/sms/SmsMessageEdit.jsp?hrmid=<%=sendToUserId%>");	 
}
</script>

</body>
</html>
<%
	//response.sendRedirect("/sms/SmsMessageEdit.jsp?hrmid="+sendToUserId);
} else if("prop".equals(type)) {
	response.sendRedirect("/hrm/resource/HrmResource.jsp?id="+sendToUserId);
} else if("history".equals(type)) {
	response.sendRedirect("/messager/MsgSearch.jsp?userId="+sendToUserId);
}
%>