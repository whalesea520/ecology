<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.domain.MailGroup"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<html>
<head>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
	String method = Util.null2String(request.getParameter("method"));
	String groupName = Util.null2String(request.getParameter("groupName"));
	groupName = URLDecoder.decode(groupName,"UTF-8");
%>
<body style="background-color: #F8F8F8;">
		
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(81313,user.getLanguage())+SystemEnv.getHtmlLabelName(633,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" type="button"  onclick="doSubmit()" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form method="post" id="fMailContacter" name="fMailContacter"  action="/email/new/MailContacterAddOperation.jsp">
	
	<wea:layout attributes="{'expandAllGroup':'true','cw1':'30%','cw2':'70%'}">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(81303,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
				<wea:required id="groupNameImage" required="true">
					<input style="width:90%" maxlength="12" type="text" name="groupName" id="groupName" value="<%=groupName %>"
						 onchange='checkinput("groupName","groupNameImage")'>
				</wea:required>
			</wea:item>
		</wea:group>
		
	</wea:layout>		
</form>
			
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 	
</body>
</html>

<script type="text/javascript">

var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
var _method = "<%=method%>"

jQuery(function(){
	checkinput("groupName","groupNameImage");
});

function doSubmit() {
	var _groupName = jQuery("#groupName").val();
	if( _groupName == ""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81311,user.getLanguage()) %>"); 
		return;
	}
	if(_method == "addGroup") {
		parentWin.createGroup(_groupName);		//点击确定后调用的方法
	} else if(_method == "cmtg") {
		parentWin.cmtg(_groupName);			//点击确定后调用的方法
	} else if(_method == "cctg") {
		parentWin.cctg(_groupName);			//点击确定后调用的方法
	}else if(_method == "edit"){
		parentWin.editGroupInfo(_groupName);//修改用户组信息
	}
}
</script>
