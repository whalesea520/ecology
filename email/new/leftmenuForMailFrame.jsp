<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.domain.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<html>
	<head>
		<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
		<style type="text/css">
			div{
 				font-size: 12px;
 			}
		</style>
	</head>
	<body style="background: #ffffff">
		<div class="" style="width:160px;background: #ffffff;">

<%
	String frame = Util.null2String(request.getParameter("frame"));
	if(frame.equals("")){
		frame = "mainFrame";
	}
	mss.selectMailSetting(user.getUID());
	int userLayout = Util.getIntValue(mss.getLayout(),0);
 %>
 
<div class=" h-30 center" style=" background-image: url('/email/images/leftBtnBg_wev8.png');margin-left: 0px">
	<table class="w-all h-30">
		<tr>
			<td  class="bold colo333  "  align="right" width="50%" style="border-right: 1px solid #96bdc5;">
				
				
				
				
				<div class="left p-l-30  relative hand" id="addMail" target='' style="padding-top: 5px">
					<img class="absolute" style="top:7px;left:5px" src="/email/images/newEmail_wev8.png">
					<%=SystemEnv.getHtmlLabelName(81300, user.getLanguage())%>
				</div>
				<div class="left hand relative" id="addMailsBtn" style="padding-top: 5px;width: 20px;height: 22px;">
					<img class="absolute" style="top:12px;right:5px" src="/email/images/iconDArr_wev8.png"/>
				</div>
				
				<div class="clear"></div>
				<ul class="btnGrayDropContent addMailsBtnDown hide " style="width: 155px;left: 0px;top:28px;" >
				
								
					<li class=""  style="font-weight: normal;line-height: 20px;" onclick="addMail(1)" ><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%></li>
					<li class=""  style="font-weight: normal;line-height: 20px;" onclick="addMail(0)"><%=SystemEnv.getHtmlLabelName(31139,user.getLanguage())%></li>
								
						
				</ul>
				
				
				
				
				
			</td>
			<td id="" class="bold colo333 lh-30 " width="50%">
				<div class="left p-l-30  relative hand" id="receiveMail"  style="">
					<img class="absolute" style="top:7px;left:5px" src="/email/images/getEmail_wev8.png">
					<%=SystemEnv.getHtmlLabelName(81346, user.getLanguage())%>
				</div>
				<div class="left hand relative" id="accountsBtn" style="padding-top: 5px;width: 20px;height: 22px;">
					<img class="absolute" style="top:12px;right:5px" src="/email/images/iconDArr_wev8.png"/>
				</div>
				
				<div class="clear"></div>
						<ul class="btnGrayDropContent accountsBtnDown hide " style="width: 155px;top:28px;" >
							<%
								mas.clear();
								mas.setUserid(user.getUID()+"");
								mas.selectMailAccount();
								while(mas.next()){
									
											%>
										
											<li class=""  style="font-weight: normal;line-height: 20px;" target="<%=mas.getId()%>" ><%=mas.getAccountname() %></li>
										
									<%
								}
							%>
						</ul>
						
			</td>
		</tr>
	</table>
</div>
<div id="autoHight" class="scroll-pane" style="height: auto;overflow: auto;">
				<div class="p-t-15">
					<div class="h-25  hand" id="inboxBtn">
						<div class="left p-l-15"><img src="/email/images/inbox_wev8.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					
					<div class="h-25  hand " id="outboxBtn">
						<div class="left p-l-15"><img src="/email/images/outbox_wev8.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(19558, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					
					<div class="h-25  hand" id="drafboxBtn">
						<div class="left p-l-15"><img src="/email/images/draftbox_wev8.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(2039, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
						<div class="h-25  hand" id="delboxBtn">
						<div class="left p-l-15"><img src="/email/images/delbox_wev8.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(2040, user.getLanguage())%></div>
						<div class="left p-l-15 colorddd hide  hand m-l-10" title="<%=SystemEnv.getHtmlLabelName(15504, user.getLanguage())%>" style="height:16px; background: url(/email/images/clear_wev8.png) no-repeat center center ;" id="removeAll"></div>
						<div class="clear"></div>
					</div>
					<div class="h-40 lh-40 hand item" id="waitDealBtn"  _waitdeal='1'>
						<div class="left p-l-15"><img src="/email/images/mail_70_waitdeal_wev8.png"></div>
						<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(83090, user.getLanguage())%></div>
						<div class="left">(<span id="waitDealCount_id"></span>)</div>
						<div class="clear"></div>
					</div>						
					<div class="h-25  hand" id="internal">
						<div class="left p-l-15"><img src="/email/images/internalbox_wev8.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(24714, user.getLanguage())%></div>
						
						<div class="clear"></div>
					</div>
						<div class="h-25  hand" id="star">
						<div class="left p-l-15"><img src="/email/images/importantbox_wev8.png"></div>
						<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(81337, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
			</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="p-t-10">
				<div class="h-20  hand" id="mailSetting">
					<div class="left p-l-15"><img src="/email/images/setting_wev8.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(24751, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
				
				<div class="h-25  hand" id='contactsBtn'>
					<div class="left p-l-15"><img src="/email/images/contacts_wev8.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
			</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="" >
			<div class="m-t-10">
				<div class="h-25  hand main" id="forder" target="subFolder">
					<div class="left p-l-15"><img src="/email/images/folder_wev8.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(81348, user.getLanguage())%></div>
					<div class="left p-l-15 colorddd hide  hand m-l-10" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:16px; background: url(/email/images/manage_wev8.png) no-repeat center center ;" id="folderManage"></div>
					<div class="clear"></div>
				</div>
				<div class="p-l-30 hide" id="subFolder">
				<%
						ArrayList folderList= fms.getFolderManagerList(user.getUID());
							for(int i=0; i<folderList.size();i++){
								MailFolder mf = (MailFolder)folderList.get(i);
								%>
								<div class="h-25 subfolder  hand" target="<%=mf.getId()%>">
									<div class="left"><img src="/email/images/subfolder_wev8.png"></div>
									<div class="left color333 p-l-5 " title="<%= mf.getFolderName() %>"><%=Util.getMoreStr(mf.getFolderName(),4,"...")  %></div>
									<div class="clear"></div>
								</div>
								
								<%
							}
						%>
					
				</div>
			</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="m-t-10"  >
				
				<div class="h-25  hand main" id="tag" target="subTag">
					<div class="left p-l-15"><img src="/email/images/folder_wev8.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(81349, user.getLanguage())%></div>
					<div class="left p-l-15 colorddd hide  hand m-l-10" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:16px; background: url(/email/images/manage_wev8.png) no-repeat center center ;" id="tagManage"></div>
					<div class="clear"></div>
				</div>
				<div class="p-l-30 hide" id="subTag" >
				<%
						 ArrayList lmsList= lms.getLabelManagerList(user.getUID());
							for(int i=0; i<lmsList.size();i++){
								MailLabel ml = (MailLabel)lmsList.get(i);
								%>
								<div class="h-25 label hand" target="<%=ml.getId()%>">
									<div class="left center p-t-5"><div style="width: 8px; height: 8px; overflow:hidden; background: <%=ml.getColor()%>"></div></div>
									<div class="left color333 p-l-5 " title="<%=ml.getName()%>"><%=Util.getMoreStr(ml.getName(),4,"...") %></div>
									<div class="clear"></div>
								</div>
								<%
							}
				%>
				</div>
			</div>
			
			</div>
</div>
</div>
<input type="hidden" name="menu_userLayout"  id="menu_userLayout"  value="<%=userLayout%>"/>
	</body>
</html>
<script type="text/javascript">


function changeUserLayout(objvalue){
		//请参考页面/email/new/leftmenu.jsp
		jQuery("#menu_userLayout").attr("value",objvalue);
}

//点击内部邮件和外部邮件
jQuery("#addMail").bind("click",function(){
	var right_url=window.parent.parent.document.getElementById("<%=frame%>").src;
	if(right_url.indexOf("MailInBox.jsp")==-1){
			//表示右边结构被切换到邮件设计或联系人界面
			window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?opNewEmail=1&folderid=0&isInternal="+$(this).attr("target");
			return;
	}
	try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.addTab("1","/email/new/MailAdd.jsp?isInternal="+$(this).attr("target"),"<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>");
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?opNewEmail=1&folderid=0&isInternal="+$(this).attr("target");
	}
	//window.open("/email/new/MailInBox.jsp?opNewEmail=1&folderid=0&isInternal="+$(this).attr("target"), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailAdd.jsp");
		$(this).attr("target","");
})

jQuery("#contactsBtn").bind("click",function(){
	window.open("/email/new/Contacts.jsp", "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/Contacts.jsp");
})

jQuery("#inboxBtn").bind("click",function(){
	//window.open("/email/new/MailInBox.jsp?folderid=0&receivemailid=0&receivemail=true&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid=0&receivemailid=0&receivemail=true&"+new Date().getTime());
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//收件箱
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid=0&receivemailid=0&receivemail=true&"+new Date().getTime());
	//MailInboxListMain.jsp
	if(menu_userLayout==3){
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("2","/email/new/MailInboxList.jsp?folderid=0&receivemailid=0&receivemail=true&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=0&receivemailid=0&receivemail=true&"+new Date().getTime();
		}
	}else{
		try{
			window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("2","/email/new/MailInboxListMain.jsp?folderid=0&receivemailid=0&receivemail=true&"+new Date().getTime(),$(this).text());
		}catch(e){
			//表示右边结构被切换到邮件设计或联系人界面
			window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=0&receivemailid=0&receivemail=true&"+new Date().getTime();
		}
	}
})

jQuery("#mailSetting").bind("click",function(){
	window.open("/email/new/MailSetting.jsp", "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailSetting.jsp");
})
jQuery("#receiveMail").bind("click",function(){
	//收信
	//window.open("/email/new/MailInBox.jsp?folderid=0&receivemailid=-1&receivemail=true&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid=0&receivemailid=-1&receivemail=true&"+new Date().getTime());
	var menu_userLayout=jQuery("#menu_userLayout").val();
	if(menu_userLayout==3){
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("2","/email/new/MailInboxList.jsp?folderid=0&receivemailid=-1&receivemail=true&"+new Date().getTime());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=0&receivemailid=-1&receivemail=true&"+new Date().getTime();
		}
	}else{
			try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("2","/email/new/MailInboxListMain.jsp?folderid=0&receivemailid=-1&receivemail=true&"+new Date().getTime());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=0&receivemailid=-1&receivemail=true&"+new Date().getTime();
		}
	}
})

jQuery("#outboxBtn").bind("click",function(){
	//window.open("/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime());
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//发件箱
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime());
	if(menu_userLayout==3){
			try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("3","/email/new/MailInboxList.jsp?folderid=-1&"+new Date().getTime(),$(this).text());
			}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime();
			}
	}else{
			try{
     			window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("3","/email/new/MailInboxListMain.jsp?folderid=-1&"+new Date().getTime(),$(this).text());
     		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime();
			}
	}
	
})

jQuery("#drafboxBtn").bind("click",function(){
	//window.open("/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime());
	//草稿箱
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime());
	if(menu_userLayout==3){
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("4","/email/new/MailInboxList.jsp?folderid=-2&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime();
			}
	}else{
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("4","/email/new/MailInboxListMain.jsp?folderid=-2&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime();
		}
	}
})

jQuery("#delboxBtn").bind("click",function(){
	window.open("/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime());
	/* var menu_userLayout=jQuery("#menu_userLayout").val();
	//垃圾箱
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime());
	if(menu_userLayout==3){
			try{
					
					window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("5","/email/new/MailInboxList.jsp?folderid=-3&"+new Date().getTime(),$(this).find(".title").text());
			}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime();
			}
	}else{
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("5","/email/new/MailInboxListMain.jsp?folderid=-3&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime();
		}
	} */
})

jQuery("#star").bind("click",function(){
	//window.open("/email/new/MailInBox.jsp?star=1&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?star=1&"+new Date().getTime());
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//标星邮件
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?star=1&"+new Date().getTime());
	if(menu_userLayout==3){
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("7","/email/new/MailInboxList.jsp?star=1&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?star=1&"+new Date().getTime();
		}
	}else{
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("7","/email/new/MailInboxListMain.jsp?star=1&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?star=1&"+new Date().getTime();
		}
	}
})

jQuery("#internal").bind("click",function(){
	//window.open("/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime());
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//内部邮件
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime());
	if(menu_userLayout==3){
			try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("6","/email/new/MailInboxList.jsp?isInternal=1&"+new Date().getTime(),$(this).text());
			}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime();
			}
	}else{
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("6","/email/new/MailInboxListMain.jsp?isInternal=1&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime();
		}
	}
})

jQuery(".subfolder").bind("click",function(){
	//window.open("/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime());
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//文件夹邮件
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime());
	if(menu_userLayout==3){
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("8","/email/new/MailInboxList.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}else{
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("8","/email/new/MailInboxListMain.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}
})

jQuery(".label").bind("click",function(){
	//window.open("/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime());
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime());
	//标签
	if(menu_userLayout==3){
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("8","/email/new/MailInboxList.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}else{
		try{
				window.parent.parent.document.getElementById("<%=frame%>").contentWindow.refreshMailTab("8","/email/new/MailInboxListMain.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				window.parent.parent.document.getElementById("<%=frame%>").src="/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}
})
jQuery("#waitDealBtn").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("9","/email/new/MailInboxList.jsp?waitdeal=1&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?waitdeal=1&"+new Date().getTime();
		}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("9","/email/new/MailInboxListMain.jsp?waitdeal=1&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?waitdeal=1&"+new Date().getTime();
		}
	}
	changeColor(this);
});
jQuery("#accountsBtn").click(function(event){
	$("#accountsBtn").find(".btnGrayDropContent").toggle();
	stopEvent(event); 
})

jQuery("#accountsBtn").find("li").click(function(event){
	$("#accountsBtn").find(".btnGrayDropContent").hide();
	stopEvent(event);
	 
	window.open("/email/new/MailInBox.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime(), "<%=frame%>");
	//jQuery("#<%=frame%>").attr("src","/email/new/MailInBox.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime());

})



jQuery("#delboxBtn").hover(
        function () {
            $(this).find("#removeAll").show();
          }, 
          function () {
          	 $(this).find("#removeAll").hide();
          }
  );
  
  
jQuery("#tag").hover(
        function () {
            $(this).find("#tagManage").show();
          }, 
          function () {
          	 $(this).find("#tagManage").hide();
          }
  );
  
  
jQuery("#forder").hover(
        function () {
            $(this).find("#folderManage").show();
          }, 
          function () {
          	 $(this).find("#folderManage").hide();
          }
  );
  

jQuery("#folderManage").click(function(event){
	window.open("/email/new/MailSetting.jsp?target=folder", "<%=frame%>");
	    
	stopEvent(event); 
	 
	
})


jQuery("#tagManage").click(function(event){
	     window.open("/email/new/MailSetting.jsp?target=label", "<%=frame%>");
	     
		 stopEvent(event); 
})


  
jQuery("#removeAll").click(function(event){
	 var tip = "<%=SystemEnv.getHtmlLabelName(30838, user.getLanguage()) %>?";
		
	 if(confirm(tip)) {
		 $.post("/email/new/MailManageOperation.jsp",{operation:'deleteAll',folderid:'-3'},function(){
			 jQuery("#delboxBtn").trigger("click");
		 })
		
	 } 
	 stopEvent(event); 
})



jQuery("#accountsBtn").click(function(event){
	$(".btnGrayDropContent").hide();
	$(".accountsBtnDown").toggle();
	stopEvent(event);
})

jQuery("#addMailsBtn").click(function(event){
	$(".btnGrayDropContent").hide();
	$(".addMailsBtnDown").toggle();
	stopEvent(event); 
})


jQuery(".accountsBtnDown").find("li").click(function(event){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	$(".btnGrayDropContent").hide();
	stopEvent(event);
	 
	 window.open("/email/new/MailInBox.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime(), "<%=frame%>");
})

jQuery(document).click(function(event){
	$(".btnGrayDropContent").hide();
	stopEvent(event);
})


function addMail(type){
	//写信
	jQuery("#addMail").attr("target",type).trigger("click");
}

jQuery(".main").click(function(){
	if(jQuery("#"+jQuery(this).attr("target")).is(":hidden")){
		jQuery("#"+jQuery(this).attr("target")).show();
	}else{
		jQuery("#"+jQuery(this).attr("target")).hide();
	}
})
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

</script>