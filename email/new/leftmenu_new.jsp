<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.domain.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<link rel="stylesheet" href="/email/js/jscrollpane/jquery.jscrollpane_wev8.css" />
<link rel="stylesheet" href="/wui/theme/ecology8/skins/default/page/left_wev8.css" />
<script type="text/javascript" src="/email/js/jscrollpane/jquery.mousewheel_wev8.js"></script>
<script type="text/javascript" src="/email/js/jscrollpane/jquery.jscrollpane.min_wev8.js"></script>
<style>
.menu{}
.menu .item{color:#c3c3c3}
.menu .active{background-color:#646d7d;color:#fff}
.menu .icon{margin-left:20px;margin-right:25px;height:40px;width:16px;}
.menu .inbox_icon_a{background: url('/email/images/mail_inbox_a_wev8.png') no-repeat center}
.menu .inbox_icon{background: url('/email/images/mail_inbox_wev8.png') no-repeat center}
.menu .outbox_icon_a{background: url('/email/images/mail_outbox_a_wev8.png') no-repeat center}
.menu .outbox_icon{background: url('/email/images/mail_outbox_wev8.png') no-repeat center}

.menu .drafbox_icon_a{background: url('/email/images/mail_drafbox_a_wev8.png') no-repeat center}
.menu .drafbox_icon{background: url('/email/images/mail_drafbox_wev8.png') no-repeat center}

.menu .delbox_icon_a{background: url('/email/images/mail_delbox_a_wev8.png') no-repeat center}
.menu .delbox_icon{background: url('/email/images/mail_delbox_wev8.png') no-repeat center}

.menu .delbox_clear{height:40px; background: url(/email/images/clear_wev8.png) no-repeat center center;}

.menu .active .delbox_clear{background: url(/email/images/clear_a_wev8.png) no-repeat center center;}

.menu .internal_icon_a{background: url('/email/images/mail_internal_a_wev8.png') no-repeat center}
.menu .internal_icon{background: url('/email/images/mail_internal_wev8.png') no-repeat center}

.menu .star_icon_a{background: url('/email/images/mail_star_a_wev8.png') no-repeat center}
.menu .star_icon{background: url('/email/images/mail_star_wev8.png') no-repeat center}

.menu .setting_icon_a{background: url('/email/images/mail_setting_a_wev8.png') no-repeat center}
.menu .setting_icon{background: url('/email/images/mail_setting_wev8.png') no-repeat center}

.menu .contacts_icon_a{background: url('/email/images/mail_contacts_a_wev8.png') no-repeat center}
.menu .contacts_icon{background: url('/email/images/mail_contacts_wev8.png') no-repeat center}

.menu .attachment_icon_a{background: url('/email/images/mail_attachment_a_wev8.png') no-repeat center}
.menu .attachment_icon{background: url('/email/images/mail_attachment_wev8.png') no-repeat center}

.menu .forder_icon_a{background: url('/email/images/mail_forder_a_wev8.png') no-repeat center}
.menu .forder_icon{background: url('/email/images/mail_forder_wev8.png') no-repeat center}

.menu .folderManage{height:40px; background: url(/email/images/manage_wev8.png) no-repeat center center ;}
.menu .active .folderManage{background: url(/email/images/manage_a_wev8.png) no-repeat center center;}

.menu .tag_icon_a{background: url('/email/images/mail_tag_a_wev8.png') no-repeat center}
.menu .tag_icon{background: url('/email/images/mail_tag_wev8.png') no-repeat center}



</style>
<center>
<div class="center" id="emailCenter" style="height:323px;">

<%
	mss.selectMailSetting(user.getUID());
	int userLayout = Util.getIntValue(mss.getLayout(),0);
	
	rs.execute("select innerMail , outterMail from MailConfigureInfo");
	int innerMail = 1;
	int outterMail = 1;
	while(rs.next()){
		innerMail = rs.getInt("innerMail");
		outterMail = rs.getInt("outterMail");
	}
 %>
 
<div class=" h-30 center">
	<table class="w-all h-30" id="emailBtn" cellpadding="0" cellspacing="0">
		<tr>
			<td  class=" colo333  relative  hand"  align="right" width="50%" style="background-color:#383f45;z-index:99999;">
				
				<div class="left <%if(user.getLanguage() != 8){out.print("p-l-30");} %> relative hand mail" id="addMail" target='' style="padding-top: 10px;color:#fffefe;text-align: center;">
					<%=SystemEnv.getHtmlLabelName(81300, user.getLanguage())%>
				</div>
				
				<%if(innerMail == 1 && outterMail == 1){ %>
				<div class="right hand" id="addMailsBtn" style="width:30px;height:30px;;background:url('/email/images/mail_arrow_wev8.png') no-repeat center center;"></div>
				
				<div class="clear"></div>
				<ul id="ulWriteBtn" class="btnGrayDropContent addMailsBtnDown hide " style="left: 0px;top:30px;background-color:#383f45" >
					<li class="p-l-30"  style="font-weight: normal;line-height:25px;height:25px;color:#fffefe;padding-left:30px !important;" onclick="addMail(1,this)" ><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%></li>
					<li class="p-l-30"  style="font-weight: normal;line-height:25px;height:25px;color:#fffefe;padding-left:30px !important;" onclick="addMail(0,this)"><%=SystemEnv.getHtmlLabelName(31139,user.getLanguage())%></li>
				</ul>
				<%} %>
			</td>
			<td id="" class="colo333 lh-30 relative   relative  mail" width="50%" style="border-left:1px solid #565555;;background-color:#4d545f;z-index:99999;">
				<div class="left p-l-30  relative hand" id="receiveMail"  style="padding-top: 10px;color:#fff">
					<%=SystemEnv.getHtmlLabelName(81346, user.getLanguage())%>
				</div>
				<div class="right hand" id="accountsBtn" style="float:right;width:30px;height:30px;;background:url('/email/images/mail_arrow_wev8.png') no-repeat center center;"></div>
				
				<div class="clear"></div>
				<ul id="ulReceiveBtn" class="btnGrayDropContent accountsBtnDown hide " style="top:28px;background-color:#4d545f;" >
							<%
								mas.clear();
								mas.setUserid(user.getUID()+"");
								mas.selectMailAccount();
								while(mas.next()){
									
											%>
										
											<li class=""  style="font-weight: normal;line-height: 20px;line-height:25px;height:25px;color:#fffefe;" target="<%=mas.getId()%>" ><%=mas.getAccountname() %></li>
										
									<%
								}
							%>
				</ul>
						
			</td>
		</tr>
	</table>
</div>

<div id="autoHight" class="scroll-pane menu" style="height: auto;overflow: auto;">
				<div class="p-t-10">
					<div class="h-40 lh-40 hand item active" _menuType="inbox" id="inboxBtn">
						<div class="left icon inbox_icon_a"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%></div>
						<div class="left">(<span id="unreadMailCount_id">0</span>)</div>
						<div class="clear"></div>
					</div>
					
					<div class="h-40 lh-40 hand item" _menuType="outbox" id="outboxBtn">
						<div class="left icon outbox_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(19558, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					
					<div class="h-40 lh-40 hand item" _menuType="drafbox" id="drafboxBtn">
						<div class="left icon drafbox_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(2039, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					<div class="h-40 lh-40 hand item" _menuType="delbox" id="delboxBtn">
						<div class="left icon delbox_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(2040, user.getLanguage())%></div>
						<div class="left p-l-15 colorddd hide  hand m-l-10 delbox_clear" id="delbox_clear" title="<%=SystemEnv.getHtmlLabelName(15504, user.getLanguage())%>"  ></div>
						<div class="clear"></div>
					</div>
					<div class="h-40 lh-40 hand item" id="waitDealBtn"  _waitdeal='1'>
						<div class="left p-l-15"><img src="/email/images/mail_70_waitdeal_wev8.png"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(83090, user.getLanguage())%></div>
						<div class="left">(<span id="waitDealCount_id"></span>)</div>
						<div class="clear"></div>
					</div>
					<%if(innerMail==1){ %>	
					<div class="h-40 lh-40 hand item" _menuType="internal" id="internal">
						<div class="left icon internal_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(24714, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					<%} %>
					<div class="h-40 lh-40 hand item" _menuType="star" id="star">
						<div class="left icon star_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(81337, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
			</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="">
				<div class="h-40 lh-40 hand item" _menuType="setting" id="mailSetting">
					<div class="left icon setting_icon"></div>
					<div class="left title"><%=SystemEnv.getHtmlLabelName(24751, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
				
				<div class="h-40 lh-40 hand item" _menuType="attachment" id='attachmentBtn'>
					<div class="left icon attachment_icon"></div>
					<div class="left title"><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(426, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
				
				<div class="h-40 lh-40 hand item" _menuType="contacts" id='contactsBtn'>
					<div class="left icon contacts_icon"></div>
					<div class="left title"><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
			</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="">
				
				<div class="h-40 lh-40 hand main item" _menuType="forder" id="forder" target="subFolder">
					<div class="left icon forder_icon"></div>
					<div class="left title"><%=SystemEnv.getHtmlLabelName(81348, user.getLanguage())%></div>
					<div class="left p-l-15 colorddd hide  hand m-l-10 folderManage" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:40px;" id="folderManage"></div>
					<div class="clear"></div>
				</div>
				<div class="hide" id="subFolder">
				<%
						ArrayList<MailFolder> folderList= fms.getFolderManagerList(user.getUID());
							for(int i=0; i<folderList.size();i++){
								MailFolder mf = folderList.get(i);
								%>
								<div class="h-40 lh-40 subfolder  hand item" target="<%=mf.getId()%>">
									
									<div class="left p-l-30 title" style="padding-left:60px;" title="<%=mf.getFolderName()%>"><%=Util.getMoreStr(mf.getFolderName(),4,"...") %></div>
									<div class="clear"></div>
								</div>
								
								<%
							}
						%>
					
				</div>
				
				<div class="h-40 lh-40 hand main item" _menuType="tag" id="tag" target="subTag">
					<div class="left icon tag_icon"></div>
					<div class="left title"><%=SystemEnv.getHtmlLabelName(81349, user.getLanguage())%></div>
					<div class="left p-l-15 colorddd hide  hand m-l-10 folderManage" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:40px;" id="tagManage"></div>
					<div class="clear"></div>
				</div>
				<div class="hide" id="subTag" >
				<%
						 ArrayList<MailLabel> lmsList= lms.getLabelManagerList(user.getUID());
							for(int i=0; i<lmsList.size();i++){
								MailLabel ml = lmsList.get(i);
								%>
								<div class="h-40 lh-40 label hand item" style="padding-left:60px;" target="<%=ml.getId()%>">
									<div class="left center p-t-5"><div style="margin-top:10px;width: 8px; height: 8px; overflow:hidden; background: <%=ml.getColor()%>"></div></div>
									<div class="left p-l-5 lh-40 title" title="<%=ml.getName()%>"><%=Util.getMoreStr(ml.getName(),4,"...") %></div>
									<div class="clear"></div>
								</div>
								<%
							}
				%>
				</div>
				
				<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
				<div class="h-40 lh-40 hand main item" _menuType="mailMonitor" id="mailMonitor">
					<div class="left icon tag_icon"></div>
					<div class="left title"><%=SystemEnv.getHtmlLabelName(71, user.getLanguage())+SystemEnv.getHtmlLabelName(665, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
				
			</div>
			
</div>
</div>
</center>
<input type="hidden" name="menu_userLayout"  id="menu_userLayout"  value="<%=userLayout%>"/>
<script type="text/javascript">

$(document).ready(function(){
	$(".menu .item").bind("click",function(){
		var activeMenu=$(".menu .active");
		var menuType=activeMenu.attr("_menuType");
		activeMenu.removeClass("active");
		activeMenu.find(".icon").removeClass(menuType+"_icon_a").addClass(menuType+"_icon");
		
		var currentMenuType=$(this).attr("_menuType");
		$(this).addClass("active");
		$(this).find(".icon").addClass(currentMenuType+"_icon_a").removeClass(currentMenuType+"_icon");
		if(currentMenuType=="delbox")
		   $("#delbox_clear").show();
		else
		   $("#delbox_clear").hide();   
		   
		if(currentMenuType=="forder")
		   $("#folderManage").show();
		else
		   $("#folderManage").hide();      
		   
		if(currentMenuType=="tag")
		   $("#tagManage").show();
		else
		   $("#tagManage").hide();   
		    
	});
	
	mailUnreadUpdate();
});


function changeUserLayout(objvalue){
		//刷新树菜单的布局的值
		jQuery("#menu_userLayout").attr("value",objvalue);
}
var fileid = "";//选中附件直接发送邮件
jQuery("#addMail").bind("click",function(){
	//jQuery("#mainFrame").attr("src","/email/new/MailAdd.jsp");
	//写信
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?opNewEmail=1");
	try{
				document.getElementById("mainFrame").contentWindow.addTab("1","/email/new/MailAdd.jsp?fileid="+fileid+"&isInternal="+$(this).attr("target"),"<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>");
	}catch(e){
					//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?fileid="+fileid+"&opNewEmail=1&folderid=0&isInternal="+$(this).attr("target");
					
	}
	fileid = "";
	if(!jQuery(this).hasClass("aSelected")){
		jQuery(".aSelected").removeClass("aSelected");
		jQuery(this).addClass("aSelected");
	}
	$(this).attr("target","");
});

function addMail(type,obj){
	jQuery("#addMail").attr("target",type).trigger("click");
	if(!jQuery(obj).hasClass("aSelected")){
		jQuery(".aSelected").removeClass("aSelected");
		jQuery(obj).addClass("selected");
	}
}

jQuery("#receiveMail").bind("click",function(){
	//收信
	
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=0&receivemail=true&"+new Date().getTime());
	var menu_userLayout=jQuery("#menu_userLayout").val();
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("2","/email/new/MailInboxList.jsp?folderid=0&receivemail=true&"+new Date().getTime());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=0&receivemail=true&"+new Date().getTime();
		}
	}else{
			try{
				document.getElementById("mainFrame").contentWindow.refreshTab("2","/email/new/MailInboxListMain.jsp?folderid=0&receivemail=true&"+new Date().getTime());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=0&receivemail=true&"+new Date().getTime();
		}
	}
	if(!jQuery(this).hasClass("aSelected")){
		jQuery(".aSelected").removeClass("aSelected");
		jQuery(this).addClass("aSelected");
	}
});

jQuery("#contactsBtn").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/Contacts.jsp");
	changeColor(this);
});

//附件下载
jQuery("#attachmentBtn").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/MailAttachmentTab.jsp");
	changeColor(this);
});

jQuery("#inboxBtn").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//收件箱
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=0&receivemail=false&"+new Date().getTime());
	//MailInboxListMain.jsp
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("2","/email/new/MailInboxList.jsp?folderid=0&receivemail=false&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=0&receivemail=false&"+new Date().getTime();
		}
		
	}else{
		try{
		document.getElementById("mainFrame").contentWindow.refreshTab("2","/email/new/MailInboxListMain.jsp?folderid=0&receivemail=false&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
			//表示右边结构被切换到邮件设计或联系人界面
			document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=0&receivemail=false&"+new Date().getTime();
		}
	}
	changeColor(this);
});

function changeColor(obj){
	jQuery(".aSelected").removeClass("aSelected");
	jQuery(obj).children("div").addClass("aSelected");
}

jQuery("#mailSetting").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/MailSetting.jsp");
	changeColor(this);
});


jQuery("#outboxBtn").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//发件箱
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime());
	if(menu_userLayout==3){
			try{
				document.getElementById("mainFrame").contentWindow.refreshTab("3","/email/new/MailInboxList.jsp?folderid=-1&"+new Date().getTime(),$(this).find(".title").text());
			}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime();
			}
	}else{
			try{
     			document.getElementById("mainFrame").contentWindow.refreshTab("3","/email/new/MailInboxListMain.jsp?folderid=-1&"+new Date().getTime(),$(this).find(".title").text());
     		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-1&"+new Date().getTime();
			}
	}
	changeColor(this);
});

jQuery("#drafboxBtn").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//草稿箱
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime());
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("4","/email/new/MailInboxList.jsp?folderid=-2&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime();
			}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("4","/email/new/MailInboxListMain.jsp?folderid=-2&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-2&"+new Date().getTime();
		}
	}
	changeColor(this);
});

jQuery("#delboxBtn").hover(
        function () {
            $(this).find("#delbox_clear").show();
          }, 
          function () {
          	 if(!$(this).hasClass("active"))
          	 	$(this).find("#delbox_clear").hide();
          }
  );
  
  
jQuery("#tag").hover(
        function () {
            $(this).find("#tagManage").show();
          }, 
          function () {
          	if(!$(this).hasClass("active"))
          	 $(this).find("#tagManage").hide();
          }
  );
  
  
jQuery("#forder").hover(
        function () {
            $(this).find("#folderManage").show();
          }, 
          function () {
          	if(!$(this).hasClass("active"))
          	 $(this).find("#folderManage").hide();
          }
  );
  

jQuery("#folderManage").click(function(event){
 
	     jQuery("#mainFrame").attr("src","/email/new/MailSetting.jsp?target=folder");
		 changeColor(this.closest("div"));
		 stopEvent(); 
	 
	
})


jQuery("#tagManage").click(function(event){
	
	     jQuery("#mainFrame").attr("src","/email/new/MailSetting.jsp?target=label");
		 changeColor(this);
		 stopEvent(); 
})


  
jQuery("#delbox_clear").click(function(event){
	 var tip = "<%=SystemEnv.getHtmlLabelName(30838, user.getLanguage()) %>?";
	 window.top.Dialog.confirm(tip,function(){
	 	$.post("/email/new/MailManageOperation.jsp",{operation:'deleteAll',folderid:'-3'},function(){
			 jQuery("#delboxBtn").trigger("click");
		 })
		 stopEvent(); 
	 });	
})

jQuery("#delboxBtn").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//垃圾箱
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime());
	if(menu_userLayout==3){
			try{
					
					document.getElementById("mainFrame").contentWindow.refreshTab("5","/email/new/MailInboxList.jsp?folderid=-3&"+new Date().getTime(),$(this).find(".title").text());
			}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				//document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime();
			}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("5","/email/new/MailInboxListMain.jsp?folderid=-3&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid=-3&"+new Date().getTime();
		}
	}
	changeColor(this);
})

jQuery("#internal").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//内部邮件
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime());
	if(menu_userLayout==3){
			try{
				document.getElementById("mainFrame").contentWindow.refreshTab("6","/email/new/MailInboxList.jsp?isInternal=1&"+new Date().getTime(),$(this).find(".title").text());
			}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime();
			}
	}else{
		try{
			document.getElementById("mainFrame").contentWindow.refreshTab("6","/email/new/MailInboxListMain.jsp?isInternal=1&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?isInternal=1&"+new Date().getTime();
		}
	}
	changeColor(this);
});

jQuery("#star").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//标星邮件
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?star=1&"+new Date().getTime());
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("7","/email/new/MailInboxList.jsp?star=1&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?star=1&"+new Date().getTime();
		}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("7","/email/new/MailInboxListMain.jsp?star=1&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?star=1&"+new Date().getTime();
		}
	}
	changeColor(this);
});
jQuery(".subfolder").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//文件夹邮件
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime());
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxList.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxListMain.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?folderid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}
});

jQuery(".label").bind("click",function(){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	//jQuery("#mainFrame").attr("src","/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime());
	//标签
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxList.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxListMain.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime(),$(this).find(".title").text());
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?labelid="+$(this).attr("target")+"&"+new Date().getTime();
		}
	}
});

//邮件监控

jQuery("#mailMonitor").bind("click",function(){
	jQuery("#mainFrame").attr("src","/email/new/MailMonitorFrame.jsp");
	changeColor(this);
});

jQuery("#accountsBtn").click(function(event){
	$(".btnGrayDropContent").hide()
	$(".accountsBtnDown").toggle();
	//$(".addMailsBtnDown").css("background-color","#6a6a6a");
	//jQuery(".addMailsBtnDown").closest("td").css("background-color","#6a6a6a");
	//$(".accountsBtnDown").css("background-color","rgb(85,85,85)");
	//jQuery(this).closest("td").css("background-color","rgb(85,85,85)");
	 stopEvent(); 
}).hover(function(){
	$(this).css("background-color","#404750");
},function(){
	$(this).css("background-color","");
});

jQuery("#addMailsBtn").click(function(event){
	$(".btnGrayDropContent").hide()
	$(".addMailsBtnDown").toggle();
	//$(".accountsBtnDown").css("background-color","#6a6a6a");
	//jQuery(".accountsBtnDown").closest("td").css("background-color","#6a6a6a");
	//$(".addMailsBtnDown").css("background-color","rgb(85,85,85)");
	//jQuery(this).closest("td").css("background-color","rgb(85,85,85)");
	 stopEvent(); 
}).hover(function(){
	$(this).css("background-color","#404750");
},function(){
	$(this).css("background-color","");
});


jQuery(".accountsBtnDown").find("li").click(function(event){
	var menu_userLayout=jQuery("#menu_userLayout").val();
	$(".btnGrayDropContent").hide();
	 stopEvent(); 
	 
	if(menu_userLayout==3){
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxList.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime(),"<%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%>");
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime();
		}
	}else{
		try{
				document.getElementById("mainFrame").contentWindow.refreshTab("8","/email/new/MailInboxListMain.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime(),"<%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%>");
		}catch(e){
				//表示右边结构被切换到邮件设计或联系人界面
				document.getElementById("mainFrame").src="/email/new/MailInBox.jsp?receivemailid="+$(this).attr("target")+"&folderid=0&receivemail=true&"+new Date().getTime();
		}
	}
	

});


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

jQuery(document).click(function(event){
	$(".btnGrayDropContent").hide();
	 stopEvent(); 
});

jQuery(".main").click(function(){
	if(jQuery("#"+jQuery(this).attr("target")).is(":hidden")){
		jQuery("#"+jQuery(this).attr("target")).show();
	}else{
		jQuery("#"+jQuery(this).attr("target")).hide();
	}
});

jQuery(document).ready(function(){

    var clientScreenHeight = document.body.clientHeight;
	
	//$("#autoHight").css("height",clientScreenHeight-200+"px");
	//$("#autoHight").css("width",$("#leftMenu").width()+4+"px");
	$('.scroll-pane').jScrollPane({
	    autoReinitialise: true  //内容改变后自动计算高度
	})
	
	//jQuery("#emailBtn").width(jQuery("#leftMenu").width()-20);
	jQuery("#ulWriteBtn").width(jQuery("#leftMenu").width());
	jQuery("#ulReceiveBtn").width(jQuery("#leftMenu").width()).css("left",-jQuery("#leftMenu").width()/2);
	
	jQuery("#ulWriteBtn li").hover(function(){
		$(this).css("background-color","#444f55");
	},function(){
		$(this).css("background-color","#383f45");
	});
	
	jQuery("#ulReceiveBtn li").hover(function(){
		$(this).css("background-color","#444a55");
	},function(){
		$(this).css("background-color","#4d545f");
	});
});

//阻止事件冒泡
function stopEvent() {
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation();
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
}

function mailUnreadUpdate(){
	$.post("/email/new/RefreshCountAjAX.jsp", {folderid:"0",status:"0"}, function(data){
				$("#unreadMailCount_id").html(data.unreadMailCount);
	},"json");
}

</script>
<style>
.jspPane{
	margin-left: 0px!important;
	left:0px!important;
	width: 100%;
}

.line-gray1{background:#555353;height:1px;line-height:1px;}
.line-gray2{background:#555353;height:2px;line-height:2px;}
.line-gray3{background:#555353;height:3px;line-height:3px;}
.center{text-align:center;margin-left:auto;margin-right:auto;} 

.btnGrayDropContent  li{
	/*background-color:#f8f8f8;*/
	cursor:pointer;
	text-align:left;
	font-size: 12px;
	padding-left:5px;
	padding-top: 2px;
	color:#A19E9E;
	height: 20px;
	padding:3px;
	list-style-type: none;
	
}

.btnGrayDropContent  li:hover{
	/*background-color:#cccccc;*/
}
.btnGrayDropContent{
	/*border: #5F5F5F solid 1px;*/
	border-collapse: collapse;
	border-spacing: 0px;
	cursor: pointer;
	display: block;
	font-size: 12px;
	/*font-weight: bold;*/
	margin: 0px;
	padding: 0px;
	z-index: 99999;
	width: 160px;
	top: 28px;
	position: absolute;
	text-align: center;
	line-height: 30px;
	background-color:rgb(63,63,63);
	left: -138px;
}
.hide{
	display: none;
}
.p-l-30{padding-left:30px;}
</style>
