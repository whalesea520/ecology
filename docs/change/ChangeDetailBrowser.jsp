
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.RecordSet"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocReceiveUnitComInfo" class="weaver.docs.senddoc.DocReceiveUnitComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("20217,33361",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e+"-->CategoryBrowser.jsp");
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
</HEAD>

<%
boolean canResend = true;
if(!HrmUserVarify.checkUserRight("DocChange:Resend", user)){
	canResend = false;
}
String requestid = Util.null2String(request.getParameter("requestid"));
String expandAllGroup = Util.null2String(request.getParameter("expandAllGroup"));
%>
<%
%>
<BODY>
<div class="zDialog_div_content">
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td>
			</td>
			<td class="rightSearchSpan" style="text-align:right;">
				<%if(canResend) { %>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(22408,user.getLanguage())%>" class="e8_btn_top" onclick="reSend(this);"/>
				<%} %>
				<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//if(canResend) {
//RCMenu += "{"+SystemEnv.getHtmlLabelName(22408,user.getLanguage())+",javascript:reSend(this),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
//}
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:dialog.close(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
String attrs = "{'expandAllGroup':'"+(expandAllGroup.equals("true")?"true":"false")+"'}";
String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=offical&url=/docs/sendDoc/DocReceiveUnitBrowserMulti.jsp?isWorkflowDoc=1&requestid="+requestid+"&receiveUnitIds=";
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<LINK href="../css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<FORM name="frmmain" action="/docs/change/DocReceiveCompanyBrowser.jsp" method="post" target="_self">
<input type="hidden" name="requestid" value="<%=requestid%>">
<%if(canResend) {%>
<div>
<wea:layout attributes='<%=attrs %>'>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(27808,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(126832,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20217,user.getLanguage())%></wea:item>
		<wea:item>
			<brow:browser name="receiveUnitIds" viewType="0" hasBrowser="true" hasAdd="false" idKey="id" nameKey="name"
			browserUrl='<%=browserUrl %>' isMustInput="1" isSingle="false" hasInput="false"
			temptitle='<%= SystemEnv.getHtmlLabelName(19309,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
			completeUrl="/data.jsp?type=categoryBrowser" _callback="doResend" width="300px" browserValue="" browserSpanValue="" />
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<%}%>
<wea:layout attributes='<%=attrs %>'>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(23104,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<!-- 流程中指定 -->
			<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'4','cws':'20%,40%,20%,20%'}">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(20217,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(23106,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></wea:item>
					<%
					int i = 0;
					rs.executeSql("select * from DocChangeSendDetail WHERE type='0' and requestid="+requestid);
					while(rs.next()) {
					%>
						<wea:item><%=DocReceiveUnitComInfo.getReceiveUnitName(rs.getString("receiver"))%></wea:item>
						<wea:item><%=rs.getString("detail")%></wea:item>
						<wea:item><%=rs.getString("receivedate")%></wea:item>
						<wea:item>
							<%
							int statusText = -1;
							String status = rs.getString("status");
							if(status.equals("0")) statusText = 23079;
							if(status.equals("1")) statusText = 23078;
							if(status.equals("2")) statusText = 22946;
							if(status.equals("3")) statusText = 21983;
							%>
							<%=SystemEnv.getHtmlLabelName(statusText,user.getLanguage())%>
						</wea:item>
					<%} %>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(33565,user.getLanguage())%>'>
		<wea:item attributes="{'isTableList':'true'}">
			<!-- 其他单位 -->
			<wea:layout needImportDefaultJsAndCss="false" type="table" attributes="{'cols':'4','cws':'20%,40%,20%,20%'}">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(20217,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(23106,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></wea:item>
					<%
					int i = 0;
					rs.executeSql("select * from DocChangeSendDetail WHERE type='1' and requestid="+requestid);
					while(rs.next()) {
					%>
						<wea:item><%=DocReceiveUnitComInfo.getReceiveUnitName(rs.getString("receiver"))%></wea:item>
						<wea:item><%=rs.getString("detail")%></wea:item>
						<wea:item><%=rs.getString("receivedate")%></wea:item>
						<wea:item>
							<%
							int statusText = -1;
							String status = rs.getString("status");
							if(status.equals("0")) statusText = 23079;
							if(status.equals("1")) statusText = 23078;
							if(status.equals("2")) statusText = 22946;
							if(status.equals("3")) statusText = 21983;
							%>
							<%=SystemEnv.getHtmlLabelName(statusText,user.getLanguage())%>
						</wea:item>
					<%} %>
				</wea:group>
			</wea:layout>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>
  </div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
    <wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input type="button" accessKey=2  id=btnclose value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancel" class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
</BODY>
</html>
<script>
function selecAll(){
	var flag = document.all('selectAll').checked;
	var ids = document.all('detailId');
	for(i=0; i<ids.length; i++) {
		ids[i].checked = flag;
	}
}
function reSend(mobj) {
	//onReSendCompany();
	//document.frmmain.submit();
	//mobj.disabled = true;
	jQuery("#outreceiveUnitIdsdiv").next("div.e8_innerShow_button").find("button").click();
}

function doResend(e,datas,name,params){
	jQuery.ajax({
		url:"/docs/change/ReSendOpterator.jsp",
		type:"post",
		dataType:"html",
		data:{
			requestid:<%=requestid%>,
			cids:datas.id
		},
		beforeSend:function(xhr){
			try{
				e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(82086,user.getLanguage())%>",true);
			}catch(e){}
		},
		complete:function(xhr){
			e8showAjaxTips("",false);
		},
		success:function(data){
			window.location.href="/docs/change/ChangeDetailBrowser.jsp?requestid=<%=requestid%>&expandAllGroup=true";
		}
	});
}
</script>
