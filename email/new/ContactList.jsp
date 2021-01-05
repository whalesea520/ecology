<%@page import="weaver.email.domain.MailContact"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<html>
<head>
	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
	<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<%
int mailgroupid = Util.getIntValue(request.getParameter("mailgroupid"));
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(572,user.getLanguage())+SystemEnv.getHtmlLabelName(527,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<% 
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:searchByKeyword(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(30131,user.getLanguage())+",javascript:addGroup(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!(mailgroupid==Integer.MAX_VALUE ||  mailgroupid==Integer.MIN_VALUE)) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(30908,user.getLanguage())+",javascript:deleteGroup("+mailgroupid+"),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(103,user.getLanguage())+SystemEnv.getHtmlLabelName(81313,user.getLanguage())+",javascript:editGroup(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
}
if(mailgroupid != Integer.MAX_VALUE && mailgroupid != Integer.MIN_VALUE){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+SystemEnv.getHtmlLabelName(31458,user.getLanguage())+",javascript:cacelGroup(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
} 
RCMenu += "{"+SystemEnv.getHtmlLabelName(83079,user.getLanguage())+",javascript:_xtable_getExcel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(81272,user.getLanguage())+",javascript:_xtable_getAllExcel(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
			
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<style>
	.groups {
		border-style: solid;
		border-color: #BBB;
		border-width: 1px;
		border-radius: 3px;
	}
	.groupiteam {
		height: 26px;
		background-color: #F6F6F6;
		color: black;
		padding: 0px 10px 0px 10px;
		line-height: 25px;
	}
	.groupiteamhover {
		background-color: #E6E6E6;;
	}
	.popWindow{
	     width:450px;
	     height:auto;
	     box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
	     border: 2px solid #90969E;
	     background: #ffffff;
	}

</style>
<body>
<%
	
	String keyword = Util.null2String(request.getParameter("keyword"));
	int userId = user.getUID();
	
	String selectType = "checkbox";
	int pagesize = 10;
	
	String tempBackfields = "";
	String tempFromSql = "";
	String tempSQLWhere = "";
	
	if(mailgroupid == Integer.MAX_VALUE) {
		tempBackfields = "a.id, a.mailUserName, a.mailaddress, a.mailUserMobileP";
		tempFromSql = "MailUserAddress a";
		tempSQLWhere = "a.userId="+ userId;
	} else if(mailgroupid == Integer.MIN_VALUE) {
		tempBackfields = "a.id, a.mailUserName, a.mailaddress, a.mailUserMobileP";
		tempFromSql = "MailUserAddress a";
		tempSQLWhere = "a.id not in (select contactId from GroupAndContact) and a.userId="+ userId;
	} else {
		tempBackfields = "a.id, a.mailUserName, a.mailaddress, a.mailUserMobileP, b.groupId";
		tempFromSql = "MailUserAddress a, GroupAndContact b";
		tempSQLWhere = "a.id=b.contactId and a.userId="+ userId +" and b.groupId="+ mailgroupid;
	}
	
	if(!keyword.trim().equals("")){
		tempSQLWhere += " and ( a.mailUserName like '%"+keyword+"%' or a.mailaddress like '%"+keyword+"%'  or a.mailUserMobileP like '%"+keyword+"%')";
	}
	
	
	String backfields = tempBackfields;
	String fromSql  = tempFromSql;
	String sqlWhere = tempSQLWhere;
	String orderby = "a.id" ;
	String tableString =" <table instanceid=\"contacts\" tabletype=\""+ selectType +"\" pageId=\""+PageIdConst.Email_Contact+"\"  pagesize=\""+PageIdConst.getPageSize(PageIdConst.Email_Contact,user.getUID(),PageIdConst.EMAIL)+"\" >"+   
	"	        <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+sqlWhere+"\"  sqlorderby=\""+ orderby +"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Desc\" sqldistinct=\"true\"/>"+
	"			<head>"+
	"				<col width=\"20%\"  text=\""+ SystemEnv.getHtmlLabelName(25034,user.getLanguage()) +"\" column=\"id\" orderkey=\"a.mailUserName\" transmethod=\"weaver.email.service.ContactManagerService.getHrefMailUserName\" otherpara=\"column:mailUserName\" />"+ 
	"				<col width=\"25%\"  text=\""+ SystemEnv.getHtmlLabelName(19805,user.getLanguage()) +"\" column=\"mailaddress\" orderkey=\"a.mailaddress\" transmethod=\"weaver.email.service.ContactManagerService.getHrefMailAddress\" />"+ 
	"				<col width=\"25%\"  text=\""+ SystemEnv.getHtmlLabelName(22482,user.getLanguage()) +"\" column=\"mailUserMobileP\" orderkey=\"a.mailUserMobileP\" />"+ 
	"				<col width=\"30%\"  text=\""+ SystemEnv.getHtmlLabelName(81312,user.getLanguage()) +"\" column=\"id\" transmethod=\"weaver.email.service.ContactManagerService.getGroupNames\" />"+
	"			</head>"+   			
	"</table>";																																							
%>

		
<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="writeMail()" type="button" value="<%=SystemEnv.getHtmlLabelName(81300,user.getLanguage()) %>"/>
			<%if(!(mailgroupid==Integer.MAX_VALUE ||  mailgroupid==Integer.MIN_VALUE)) {%>
				<input id="moveToGroup" target="#moveGroups" class="e8_btn_top middle" onclick="moveToGroup(this,event)" type="button" value="<%=SystemEnv.getHtmlLabelName(81296,user.getLanguage()) %>"/>
			<%}%>
			<input id="copyToGroup" target="#copyGroups" class="e8_btn_top middle" onclick="copyToGroup(this,event)" type="button" value="<%=SystemEnv.getHtmlLabelName(31267,user.getLanguage()) %>"/>
			<input class="e8_btn_top middle" onclick="javascript:window.parent.parent.addContact()" type="button"	
				value="<%=SystemEnv.getHtmlLabelName(81294,user.getLanguage()) %>"/>
			<input id="deleteContact" class="e8_btn_top middle" onclick="deleteContacts()" type="button"value="<%=SystemEnv.getHtmlLabelName(81299,user.getLanguage()) %>"/>
			
			<input type="text" class="searchInput"  name="keyword" id="keyword" value="<%=keyword%>">
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

	<form name="weaver" action="/email/new/ContactList.jsp" method="post">
		<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.Email_Contact%>">
		<wea:SplitPageTag tableString='<%=tableString%>'  mode="run" isShowTopInfo="false" isShowBottomInfo="true" />
	</form>		
		
		
	<!-- Load组列表 -->
	<div id="moveGroups" class="absolute w-120 maxh-400 ofy-scroll groups p-b-5">
		<div id="groupContain"></div>
		<div class="w-all groupiteam hand" method="cmtg" onclick="addGroup(this)">
			<span class="overText w-90"><%=SystemEnv.getHtmlLabelName(31194,user.getLanguage()) %></span>
		</div>
	</div>
	<!-- Load组列表 -->
	<div id="copyGroups" class="absolute w-120 maxh-400 ofy-scroll groups p-b-5">
		<div id="groupContain"></div>
		<div class="w-all groupiteam hand" method="cctg" onclick="addGroup(this)">
			<span class="overText w-90"><%=SystemEnv.getHtmlLabelName(31195,user.getLanguage()) %></span>
		</div>
	</div>
		
</body>
	

	
<script type="text/javascript">

function searchByKeyword(){
	var keyword = jQuery("#keyword").val();
	window.weaver.action = "/email/new/ContactList.jsp?mailgroupid=<%=mailgroupid%>&keyword="+keyword;
	window.weaver.submit();
}

jQuery(document).ready(function() {
	$("div.groups").hide();
	reLoadGroups(<%=mailgroupid %>);
	
	jQuery("#topTitle").topMenuTitle({searchFn:searchByKeyword});
	jQuery("#hoverBtnSpan").hoverBtn();
	
	$(document.body).click(function(){
		hideGroup();
	});
});

function hideGroup(){
	$("div.groups").hide();
}

//刷新【移动到组】和【复制到组】中的组列表
function reLoadGroups(currentGroup) {
	var param = {"currentGroup": currentGroup};
	$.get("/email/new/GroupList.jsp", param, function(data) {
		var _moveGroups = $("#moveGroups").find("#groupContain");
		var _copyGroups = $("#copyGroups").find("#groupContain");
		_moveGroups.html(data);
		_copyGroups.html(data);
		initMoveToGroup(_moveGroups);
		initCopyToGroup(_copyGroups);
		
		inithover();
	});
	
	function inithover() {
		var _groupiteam = $("div.groupiteam");
		_groupiteam.mouseover(function() {
			$(this).addClass("groupiteamhover");
		});
		_groupiteam.mouseout(function(){
			$(this).removeClass("groupiteamhover");
		});
	}
}

//智能显示被隐藏的组列表
function capacity(himself) {
	var _position = $(himself).offset();
	var _targer = $(himself).attr("target");
	$(_targer).css({top: 0, left: _position.left});
	
	$("div.groups").each(function() {
		if(this != $(_targer)[0]) {
			$(this).hide();
		}
	});
	
	$(_targer).toggle();
	
}

//移动到组
function moveToGroup(himself,event){
	stopEvent(event);
	capacity(himself);
}

//移动到组 
function initMoveToGroup(groups){
	$(groups).find("div").bind("click", function(){
		var gourp = this;
		var contactsId = getContactsId();
		if(contactsId.length != 0) {
			var param = {"idSet": contactsId.toString(), "sourceGroup": <%=mailgroupid %>, "destGroup": gourp.id, "method": "move"};
			$.get("/email/new/ContactManageOperation.jsp", param, function(){
				parent.parent.refreshTreeData("data");
				_table.reLoad(); //重新加载当前联系人列表
			});
		} else {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81308,user.getLanguage()) %>"); 
		}
	})
}

//复制到组
function copyToGroup(himself,event){
	stopEvent(event);
	capacity(himself);
}

//复制到组
function initCopyToGroup(groups){
	$(groups).find("div").bind("click", function(){
		var gourp = this;
		var contactsId = getContactsId();
		if(contactsId.length != 0) {
			var param = {"idSet": contactsId.toString(), "sourceGroup": <%=mailgroupid %>, "destGroup": gourp.id, "method": "copy"};
			$.get("/email/new/ContactManageOperation.jsp", param, function(){
				parent.parent.refreshTreeData("data");
				_table.reLoad(); //重新加载当前联系人列表
			});
		} else {
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81308,user.getLanguage()) %>"); 
		}
	})
}

//删除联系人
function deleteContacts(){
	var contactsId = getContactsId();
	window.parent.parent.deleteContacts(contactsId, <%=mailgroupid %>);
}

function cacelGroup(){
	var contactsId = getContactsId();
	if("" == contactsId){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81308,user.getLanguage()) %>");
	}
	document.body.click();
	$.get("/email/new/ContactManageOperation.jsp", 
		{"idSet": contactsId.toString(), "sourceGroup": "<%=mailgroupid%>", "method": "cancel"}, function(){
		window.parent.parent.refreshTreeData("data"); //重新加载左侧组列表
		window.parent.parent.refreshChild(); //重新加载当前联系人列表
		window.parent.parent.diag.close();
	});
}

//写信
function writeMail(){
	var contactMailAddresses = getContactMailAddress();
	if(contactMailAddresses.length != 0) {
		var param = contactMailAddresses.toString();
		window.open("/email/new/MailInBox.jsp?opNewEmail=1&isInternal=0&to="+param, "mainFrame", true);
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81306,user.getLanguage()) %>"); 
	}
}

//删除组
function deleteGroup(currentGroup){
	if(currentGroup==<%=Integer.MAX_VALUE %> || currentGroup==<%=Integer.MIN_VALUE %>) {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30909,user.getLanguage()) %>");
	} else {
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83062,user.getLanguage()) %>",function(){
			var param = {"id": currentGroup, "method": "delete"};
			$.get("/email/new/GroupManageOperation.jsp", param, function() {
				jQuery("body").trigger("click")
				window.parent.parent.refreshTreeData("data");
				window.top.Dialog.close();
			});
		});
		
	}
}

//获取被选中联系人id
function getContactsId(){
	var _contactsId = _xtable_CheckedCheckboxIdForCP();
	
	if(_contactsId.length > 0){
		_contactsId = _contactsId.substring(0,_contactsId.length-1);
	}
	
	return _contactsId;
}

//获取被选中联系人的邮箱地址
function getContactMailAddress(){
	var contactMailAddresses = new Array();
	$("table.ListStyle tbody").find(":checked").each(function(){
		var _mailAddress = $(this.parentNode.parentNode.parentNode).find("a#mailAddress").html();
		if(_mailAddress!=null || _mailAddress!="") {
			contactMailAddresses.push(_mailAddress);
		}
	});
	return contactMailAddresses;
}

//删除页面中选中的联系人
function deletePageContact(){
	$("table.ListStyle tbody").find(":checked").each(function(){
		var iteam = $(this).parent().parent();
		$(iteam).remove();
	});
}

//阻止事件冒泡
function stopEvent(event) {
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation();
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}

//载入指定的联系人
function loadContact(id) {
	window.parent.parent.loadContact(id);
}

//【新建并移动到组】，【新建并复制到组】
function addGroup(himself) {
	window.parent.parent.addGroup(himself);
}

function editGroup(){
	window.parent.parent.editGroup("<%=mailgroupid%>");
}
</script>
</html>
