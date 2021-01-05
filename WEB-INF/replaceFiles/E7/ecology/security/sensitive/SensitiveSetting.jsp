
<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(30089,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver.js"></script>
</head>
<%

if(!HrmUserVarify.checkUserRight("SensitiveWord:Manage", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
rs.executeQuery("select * from sensitive_settings");
int id = 0;
int status = 0;
String handleWay = "0";
String remindUsers = "1";
if(rs.next()){
	id = rs.getInt("id");
	status = Util.getIntValue(rs.getString("status"),0);
	handleWay = Util.null2String(rs.getString("handleway")); 
	remindUsers = Util.null2String(rs.getString("remindUsers"));
}
String userNames = "";
String[] userArr = remindUsers.split(",");
for(int i=0;i<userArr.length;i++){
	if(userNames.equals("")){
		userNames+=Util.toScreen(rc.getResourcename(userArr[i]+""),user.getLanguage());
	}else{
		userNames= userNames + "," + Util.toScreen(rc.getResourcename(userArr[i]),user.getLanguage());
	}
}

%>
<BODY>

<%@ include file="/systeminfo/TopTitle.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>

<FORM id=weaver name=weaver action="/security/sensitive/SensitiveWordOperation.jsp" method=post>
<input type=hidden name="operation" value="setting">
<input type=hidden name="id" id="id" value="<%=id%>">
<%

	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
%>

<TABLE class=ViewForm>
	 <COLGROUP>
	    <COL width="20%">
	    <COL width="80%">
		</colgroup>
	 <TBODY>
		<tr>
		<td><%=SystemEnv.getHtmlLabelName(32165,user.getLanguage())%></td>
		<td class=Field>
			<input type="checkbox" name="status" id="status" value="1" <%=status==1?"checked":"" %>/>
		</td>
		</tr>
		<tr>
		<td><%=SystemEnv.getHtmlLabelName(124780,user.getLanguage())%></td>
		<td class=Field>
			<select name="handleWay" id="handleWay">
				<option value="0" <%=!handleWay.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(131637,user.getLanguage())%></option>
				<option value="1" <%=handleWay.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(131636,user.getLanguage())%></option>
			</select>
		</td>
		</tr>
		<tr>
		<td><%=SystemEnv.getHtmlLabelName(26731,user.getLanguage())%></td>
		<td class=Field>
					 <button type=button  class=browser onClick="onShowResource()"></button>
					 <input name=remindUsers id="remindUsers" type=hidden value="<%=remindUsers%>">
					<span id=resourcespan>
					<%=userNames%>
					</span>
		</td>
		</tr>
	</tbody>
</table>
       
</form>


<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<script language="javascript">

function onSave(isEnterDetail){
	if(check_form(document.weaver,'remindUsers')){
			document.weaver.submit();
	}
}


function onShowResource() {
	url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp";
	disModalDialog(url, $G("resourcespan"), $G("remindUsers"), false);
}

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}


</script>
</BODY></HTML>