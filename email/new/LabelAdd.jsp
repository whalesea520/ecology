<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />


<div class="w-160 h-30" style="background-image: url('/email/images/leftBtnBg_wev8.png')">
	<table class="w-all h-30">
		<tr>
			<td id="addMail"  class="bold colo333  relative p-r-15 hand"  align="right" width="50%" style="border-right: 1px solid #96bdc5;">
				<img class="absolute" style="top:7px;left:15px" src="/email/images/newEmail_wev8.png"><%=SystemEnv.getHtmlLabelName(30912,user.getLanguage()) %>
			</td>
			<td id="receiveMail" class="bold colo333 lh-30 relative p-l-30 hand" width="50%">
				<img class="absolute" style="top:7px;left:5px" src="/email/images/getEmail_wev8.png"><%=SystemEnv.getHtmlLabelName(30913,user.getLanguage()) %>
			</td>
		</tr>
	</table>
</div>
<div class="p-t-15">
	<div class="h-25  hand" id="inboxBtn">
		<div class="left p-l-15"><img src="/email/images/inbox_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
	
	<div class="h-25  hand">
		<div class="left p-l-15"><img src="/email/images/outbox_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(2038,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
	
	<div class="h-25  hand">
		<div class="left p-l-15"><img src="/email/images/draftbox_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(2039,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
		<div class="h-25  hand">
		<div class="left p-l-15"><img src="/email/images/delbox_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(18967,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
		
	<div class="h-25  hand">
		<div class="left p-l-15"><img src="/email/images/internalbox_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
		<div class="h-25  hand">
		<div class="left p-l-15"><img src="/email/images/importantbox_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(30914,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
</div>
<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
<div class="p-t-10">
	<div class="h-25  hand" id="mailSetting">
		<div class="left p-l-15"><img src="/email/images/setting_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(24751,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
	
	<div class="h-25  hand" id='contactsBtn'>
		<div class="left p-l-15"><img src="/email/images/contacts_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(572,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
</div>
<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
<div class="m-t-10">
	<div class="h-25  hand" id="forder" target="subFolder">
		<div class="left p-l-15"><img src="/email/images/folder_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(30915,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
	<div class="p-l-30" id="subFolder">
		<div class="h-25  hand">
			<div class="left"><img src="/email/images/subfolder_wev8.png"></div>
			<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(30916,user.getLanguage()) %></div>
			<div class="clear"></div>
		</div>
		<div class="h-25  hand">
			<div class="left "><img src="/email/images/subfolder_wev8.png"></div>
			<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(30917,user.getLanguage()) %></div>
			<div class="clear"></div>
		</div>
	</div>
</div>
<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
<div class="m-t-10">
	<div class="h-25  hand" id="tag" target="subTag">
		<div class="left p-l-15"><img src="/email/images/folder_wev8.png"></div>
		<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(30918,user.getLanguage()) %></div>
		<div class="clear"></div>
	</div>
	<div class="p-l-30" id="subTag">
		<div class="h-25  hand">
			<div class="left"><img src="/email/images/subfolder_wev8.png"></div>
			<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(30919,user.getLanguage()) %></div>
			<div class="clear"></div>
		</div>
		<div class="h-25  hand">
			<div class="left "><img src="/email/images/subfolder_wev8.png"></div>
			<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(30920,user.getLanguage()) %></div>
			<div class="clear"></div>
		</div>
	</div>
</div>

<script type="text/javascript">

jQuery("#addMail").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/MailAdd.jsp");
})

jQuery("#contactsBtn").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/Contacts.jsp");
})

jQuery("#inboxBtn").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/inbox.jsp");
})

jQuery("#mailSetting").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/MailSetting.jsp");
})
jQuery("#receiveMail").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/inbox.jsp?method=receive");
})

</script>
