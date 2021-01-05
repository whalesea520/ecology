<%@page import="weaver.email.domain.MailContact"%>
<%@page import="weaver.email.domain.MailGroup"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="gms" class="weaver.email.service.GroupManagerService" scope="page" />
<jsp:useBean id="cms" class="weaver.email.service.ContactManagerService" scope="page" />

<%
	String imagefilename = "/images/hdReport_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(22398,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitFMailContacter(),_top} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	</head>
	<body style="background-color: #F8F8F8;">
		<%
			int id = Util.getIntValue(request.getParameter("id"));
			MailContact mailContact = cms.getContact(id, user.getUID());
			ArrayList groups = mailContact.getGroups();
			HashSet groupIdSet = new HashSet<Integer>();
			for(int i=0; i<groups.size(); i++) {
				MailGroup tp= (MailGroup)groups.get(i);
				groupIdSet.add(tp.getMailGroupId());
			}
			int groupCount = gms.getGroupCount(user.getUID());
			
			String returnvalue=Util.null2String(request.getParameter("returnvalue"));
			String mailAddress = Util.null2String(request.getParameter("sendFrom"));
			if(!"".equals(mailAddress)){
				mailContact.setMailUserName(mailAddress.substring(0,mailAddress.indexOf("@")));
				mailContact.setMailAddress(mailAddress);
			}
		
		%>
		
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(572,user.getLanguage()) %>"/>
</jsp:include>

<div class="zDialog_div_content" style="height:418px;">
	<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="submitFMailContacter()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
	</wea:layout>
	
	<form method="post" id="fMailContacter" name="fMailContacter"  action="/email/new/MailContacterAddOperation.jsp">
		<input type="hidden" name="groups" value="">
		<%
		if(id == -1) {
	%>
	<input type="hidden" name="method" value="contacterAdd">
	<%	
		} else {
	%>
	<input type="hidden" name="method" value="contacterEdit">
	<input type="hidden" name="id" value="<%=id %>">
	<%	
		}
	%>
	
	<wea:layout attributes="{'expandAllGroup':'true'}">
	
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(25034,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
				<wea:required id="mailUserNameImage" required="true">
					<input style="width:90%" value="<%=mailContact.getMailUserName() %>" type="text" 
						name="mailUserName" id="mailUserName" onchange='checkinput("mailUserName","mailUserNameImage")'>
				</wea:required>
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(19805,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
				<wea:required id="mailUserEmailImage" required="true">
					<input style="width:90%" value="<%=mailContact.getMailAddress() %>" type="text" 
						name="mailUserEmail" id="mailUserEmail" onchange='checkinput_email("mailUserEmail","mailUserEmailImage")' >
				</wea:required>
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(25734,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			   	<input style="width:90%" value="<%=mailContact.getMailUserDesc() %>" type="text" name="mailUserDesc">
			</wea:item>
			
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15687,user.getLanguage())%>'>
		
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(422,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%=mailContact.getMailUserTel() %>" type="text" name="mailUserMobileP" id="mailUserMobileP">  
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(421,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%=mailContact.getMailUserTelP() %>" type="text" name="mailUserTelP" id="mailUserTelP">  
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(23525,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%=mailContact.getMailUserIMP() %>" type="text" name="mailUserIMP" id="mailUserIMP">  
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(19814,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%=mailContact.getMailUserAddressP() %>" type="text" name="mailUserAddressP">  
			</wea:item>
			
		</wea:group>
		
		<wea:group context='<%=SystemEnv.getHtmlLabelName(15688,user.getLanguage())%>' >
		
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(421,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%= mailContact.getMailUserTelW() %>" type="text" name="mailUserTelW">  
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(494,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%= mailContact.getMailUserFaxW() %>" type="text" name="mailUserFaxW">  
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(1851,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%= mailContact.getMailUserCompanyW() %>" type="text" name="mailUserCompanyW" id="mailUserCompanyW">  
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(27511,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%= mailContact.getMailUserDepartmentW() %>" type="text" name="mailUserDepartmentW" id="mailUserDepartmentW">  
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(6086,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%= mailContact.getMailUserTmailUserPostWelP() %>" type="text" name="mailUserPostW" id="mailUserPostW">  
			</wea:item>
			
			<wea:item>
			    <%=SystemEnv.getHtmlLabelName(17095,user.getLanguage()) %>  
			</wea:item>
			<wea:item>
			    <input style="width:90%" value="<%= mailContact.getMailUserTemailUserAddressWlP() %>" type="text" name="mailUserAddressW" id="mailUserAddressW">  
			</wea:item>
			
		</wea:group>
		
		<%if(groupCount > 0) { %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(81313,user.getLanguage())%>'>
			
			<wea:item attributes="{'colspan':'full'}">
				<div >
			    <ul>
						<%	
						ArrayList groupList = new ArrayList<MailGroup>();
						if(groupCount > 0) {
							//获得当前用户的所有自定义组列表
							groupList = gms.getGroupsById(user.getUID());
						}
						for(int i=0; i<groupList.size(); i++) {
							MailGroup mailGroup = (MailGroup)groupList.get(i);
							if(groupIdSet.contains(mailGroup.getMailGroupId())) {
						%>
						<li class="left m-2">
							<input type="checkbox" checked="checked" class="" name="groupId" value="<%=mailGroup.getMailGroupId() %>" />
							<span class="overText w-50" title="<%=mailGroup.getMailGroupName() %>"><%=mailGroup.getMailGroupName() %></span>
						</li>	
						<%
							} else {
						%>
						<li class="left m-2">
							<input type="checkbox" class="" name="groupId" value="<%=mailGroup.getMailGroupId() %>" />
							<span class="overText w-50" title="<%=mailGroup.getMailGroupName() %>"><%=mailGroup.getMailGroupName() %></span>
						</li>
						<%
							}
						}
						%>
					</ul> 
					</div>
			</wea:item>
		</wea:group>
		<%} %>
		
	</wea:layout>		
	</form>
</div>
			
			
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
	</body>
</html>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 	
<script type="text/javascript">

var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);

jQuery(function(){
	checkinput("mailUserName","mailUserNameImage");
	checkinput_email("mailUserEmail","mailUserEmailImage");
});

jQuery(document).ready(function() {
	
	<%
		if(!"".equals(returnvalue)){
			if("1".equals(returnvalue)){
	%>
				alert("<%=SystemEnv.getHtmlLabelName(30648,user.getLanguage()) %>!");
				window.parent.closeDialog();
	<%
			}else{
	%>
				alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>!");
	<%		
			}
		}
	%>
	
	checkInput();
	$("div.hand").bind("click", function(){
		$(this).next("table").toggle();
		$(this).find("b").each(function(){
			if($(this).hasClass("hide")) {
				$(this).removeClass("hide");
			} else {
				$(this).addClass("hide");
			}
		});
	});
	//解决弹出的页面按钮在左右和上下模式下，乱码的问题
	try{
		window.parent.document.getElementById("_ButtonOK_0").value="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>";
		window.parent.document.getElementById("_ButtonCancel_0").value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>";
	}catch(e){
		
	}
	//$("#_ButtonOK_0").value("确定");
});

//验证
function checkInput() {
	var _form = $("form#fMailContacter");
	var mailUserName = $.trim(_form.find("input#mailUserName").val());
	var mailUserEmail = $.trim(_form.find("input#mailUserEmail").val());
	eamilReg = /\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/;
	var isName, isEmail;
	
	if(mailUserName==""){
		_form.find("input#mailUserName").next("b").show();
		isName = false;
	} else {
		_form.find("input#mailUserName").next("b").hide();
		isName = true;
	}
	if(mailUserEmail=="" || !eamilReg.test(mailUserEmail)){
		_form.find("input#mailUserEmail").next("b").show();
		isEmail = false;
	} else {
		_form.find("input#mailUserEmail").next("b").hide();
		isEmail = true;
	}
	return isName&&isEmail;
}

//获取表单JSON对象
function getSerialize() {
	var _form = $("form#fMailContacter");
	var _groups = new Array();
	_form.find("input[name=groupId]").each(function(){
		if(this.checked) {
			_groups.push(this.value);
		}
	});
	_form.find("input[name=groups]").val(_groups.toString());
	var _param = _form.serializeArray();
	return _param;
}
function submitDate(){
	if(checkInput()){
				$("#fMailContacter").submit();	
	}else{
	alert(1);
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>");
	}
}


function submitFMailContacter() {
	if(checkInput()) {
		var param = getSerialize();
		$.post("/email/new/ContactManageOperation.jsp", param, function(){
			parent.getParentWindow(window).closeWin();
		});
	} else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage()) %>"); 
	}
}
</script>
