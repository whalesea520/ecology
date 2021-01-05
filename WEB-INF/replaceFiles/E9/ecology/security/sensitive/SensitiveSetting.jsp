
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML><HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(67,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<link rel="stylesheet" href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type="text/css" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
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

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver action="/security/sensitive/SensitiveWordOperation.jsp" method=post>
<input type=hidden name="operation" value="setting">
<input type=hidden name="id" id="id" value="<%=id%>">
<%

	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
%>

<wea:layout>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(32165,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="status" id="status" value="1" tzCheckbox="true" <%=status==1?"checked":"" %>/>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124780,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="handleWay" id="handleWay">
				<option value="0" <%=!handleWay.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(131637,user.getLanguage())%></option>
				<option value="1" <%=handleWay.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(131636,user.getLanguage())%></option>
			</select>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26731,user.getLanguage())%></wea:item>
		<wea:item>
			 <brow:browser viewType="0" name="remindUsers" browserValue='<%= ""+remindUsers %>' 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp"
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
					completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" width="49%"
					browserSpanValue='<%=userNames%>'></brow:browser>
		</wea:item>
	</wea:group>
</wea:layout>
       
</form>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="javascript">

function onSave(isEnterDetail){
	try{
		parent.disableTabBtn();
	}catch(e){}
	if(check_form(document.weaver,'remindUsers')){
			document.weaver.submit();
	}else{
		try{
			parent.enableTabBtn();
		}catch(e){}
	}
}

try{
	parent.enableTabBtn();
}catch(e){}

</script>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
					</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>	
</BODY></HTML>