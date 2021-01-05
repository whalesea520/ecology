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
<link href="/email/css/leftmenu_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/email/js/leftmenu_wev8.js"></script>
<center>
<div class="center" id="emailCenter">

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
 
<div class=" h-30 center mailMenu">
	<table class="w-all h-30 " id="emailBtn" cellpadding="0" cellspacing="0">
		<tr>
			<td class="relative hand mail addMail"  align="right" width="50%">
				<div class="left relative hand " id="addMail" onclick="addMail()" style="padding-top: 10px;color:#fffefe;text-align: center;<%if(innerMail == 1 && outterMail == 1){out.print("width:72%;");}else{out.print("width:100%;");}%>" >
					<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>
				</div>
				
				<%if(innerMail == 1 && outterMail == 1){ %>
				<div class="right hand addMailsBtn" id="addMailsBtn"></div>
				
				<div class="clear"></div>
				<ul id="ulWriteBtn" class="btnGrayDropContent addMailsBtnDown hide addMail" style="left: 0px;top:30px;padding-top:5px;">
					<li id="li1" class="p-l-30" onclick="addMail(1)" ><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%></li>
					<li id="li2" class="p-l-30" onclick="addMail(-1)"><%=SystemEnv.getHtmlLabelName(31139,user.getLanguage())%></li>
				</ul>
				<%} %>
			</td>
			<td class="relative  hand mail receiveMail" width="50%">
				<div id="receiveMail" onclick="openMailUrl(this)" _folderid="0" _receivemailid="0" class="left relative hand " style="padding-top: 10px;color:#fffefe;text-align: center;width:72%;">
					<%=SystemEnv.getHtmlLabelName(18526, user.getLanguage())%>
					<div class="left title hide"><%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%></div>
				</div>
				<div class="right hand accountsBtn" id="accountsBtn"></div>
				
				<div class="clear"></div>
				<ul id="ulReceiveBtn" class="btnGrayDropContent accountsBtnDown hide receiveMail" style="top:28px;padding-top:5px;" >
				<%
					mas.clear();
					mas.setUserid(user.getUID()+"");
					mas.selectMailAccount();
					if(outterMail == 1){
					while(mas.next()){
				%>
						<li class="" onclick="openMailUrl(this)" _folderid="0" _receivemailid="<%=mas.getId()%>"  style="font-weight: normal;line-height: 20px;line-height:25px;height:25px;" target="<%=mas.getId()%>" ><%=mas.getAccountname() %><div class="left title hide"><%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%></div></li>
							
						<%
						}
					}
				%>
				</ul>
						
			</td>
		</tr>
	</table>
</div>

<div id="autoHight" class="mailMenu">
				<div class="p-t-10">
					<div class="h-40 lh-40 hand item mailMenuItem" _menuType="inbox" id="inboxBtn" _folderid="0" _receivemailid="0">
						<div class="left icon inbox_icon_a"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%></div>
						<div class="left">(<span id="unreadMailCount_id">0</span>)</div>
						<div class="clear"></div>
					</div>
					 
					<div class="h-40 lh-40 hand item mailMenuItem" _menuType="outbox" id="outboxBtn" _folderid="-1">
						<div class="left icon outbox_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(19558, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					
					
					<div class="h-40 lh-40 hand item mailMenuItem" _menuType="drafbox" id="drafboxBtn" _folderid="-2">
						<div class="left icon drafbox_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(2039, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					<div class="h-40 lh-40 hand item mailMenuItem" _menuType="delbox" id="delboxBtn" _folderid="-3">
						<div class="left icon delbox_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(2040, user.getLanguage())%></div>
						<div class="left p-l-15 colorddd hide  hand m-l-10 delbox_clear" id="delbox_clear" title="<%=SystemEnv.getHtmlLabelName(15504, user.getLanguage())%>"  ></div>
						<div class="clear"></div>
					</div>
					
					<div class="h-40 lh-40 hand item mailMenuItem" _menuType="waitdeal" id="waitDealBtn"  _waitdeal='1'>
						<div class="left icon waitdeal_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(83090, user.getLanguage())%></div>
						<div class="left">(<span id="waitDealCount_id">0</span>)</div>
						<div class="clear"></div>
					</div>
					
					<%if(innerMail==1){ %>	
					<div class="h-40 lh-40 hand item mailMenuItem" _menuType="internal" id="internal" _internal="1">
						<div class="left icon internal_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(24714, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					<%} %>
					<div class="h-40 lh-40 hand item mailMenuItem" _menuType="star" id="star" _star="1">
						<div class="left icon star_icon"></div>
						<div class="left title"><%=SystemEnv.getHtmlLabelName(81337, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
			</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
				<div class="h-40 lh-40 hand main item" _menuType="forder" id="forder" target="subFolder">
					<div class="left icon forder_icon"></div>
					<div class="left title"><%=SystemEnv.getHtmlLabelName(81348, user.getLanguage())%></div>
					<div class="left p-l-15 colorddd hide  hand m-l-10 folderManage" onclick="openMailUrl(this)" _url="/email/new/MailSetting.jsp?target=folder" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:40px;" id="folderManage"></div>
					<div class="clear"></div>
				</div>
				<div class="hide" id="subFolder">
				<%
						ArrayList<MailFolder> folderList= fms.getFolderManagerList(user.getUID());
							for(int i=0; i<folderList.size();i++){
								MailFolder mf = folderList.get(i);
								%>
								<div class="h-40 lh-40 subfolder  hand item mailMenuItem" _folderid="<%=mf.getId()%>">
									
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
					<div class="left p-l-15 colorddd hide  hand m-l-10 folderManage" onclick="openMailUrl(this)" _url="/email/new/MailSetting.jsp?target=label" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:40px;" id="tagManage"></div>
					<div class="clear"></div>
				</div>
				<div class="hide" id="subTag" >
				<%
						 ArrayList<MailLabel> lmsList= lms.getLabelManagerList(user.getUID());
							for(int i=0; i<lmsList.size();i++){
								MailLabel ml = lmsList.get(i);
								%>
								<div class="h-40 lh-40 label hand item mailMenuItem" style="padding-left:60px;" _labelid="<%=ml.getId()%>">
									<div class="left center p-t-5"><div style="margin-top:10px;width: 8px; height: 8px; overflow:hidden; background: <%=ml.getColor()%>"></div></div>
									<div class="left p-l-5 lh-40 title" title="<%=ml.getName()%>"><%=Util.getMoreStr(ml.getName(),4,"...") %></div>
									<div class="clear"></div>
								</div>
								<%
							}
				%>
				</div>
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
				
			<div class="h-40 lh-40 hand item mailMenuItem" _menuType="contacts" id='contactsBtn' _url="/email/new/Contacts.jsp">
				<div class="left icon contacts_icon"></div>
				<div class="left title"><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%></div>
				<div class="clear"></div>
			</div>
			
			<div class="h-40 lh-40 hand item mailMenuItem" _menuType="attachment" id='attachmentBtn' _url="/email/new/MailAttachmentTab.jsp">
				<div class="left icon attachment_icon"></div>
				<div class="left title"><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(426, user.getLanguage())%></div>
				<div class="clear"></div>
			</div>
			
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			
			<div class="h-40 lh-40 hand item mailMenuItem" _menuType="setting" id="mailSetting" _url="/email/new/MailSetting.jsp">
				<div class="left icon setting_icon"></div>
				<div class="left title"><%=SystemEnv.getHtmlLabelName(24751, user.getLanguage())%></div>
				<div class="clear"></div>
			</div>
			
			<%if(HrmUserVarify.checkUserRight("Email:monitor",user)){ %>
				<div class="h-40 lh-40 hand  item mailMenuItem" _menuType="tag" id="tagBtn" _url="/email/new/MailMonitorFrame.jsp">
					<div class="left icon tag_icon"></div>
					<div class="left title"><%=SystemEnv.getHtmlLabelName(71, user.getLanguage())+SystemEnv.getHtmlLabelName(665, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
			<%} %>
</div>
</div>
</center>
<input type="hidden" name="menu_userLayout"  id="menu_userLayout"  value="<%=userLayout%>"/>
<script type="text/javascript">

var targetFrame="mainFrame";

$(document).ready(function(){
	$(".mailMenu .mailMenuItem ").bind("click",function(){
		$(".mailMenu .active").removeClass("active");
		$(this).addClass("active");
		openMailUrl(this);
		$(".btnGrayDropContent").hide().removeClass("changedisplay");
		$(".mail").removeClass("isUl");    
	});
	
	mailUnreadUpdate();
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
  
  
jQuery("#tagBtn").hover(
        function () {
            $(this).find("#tagManage").show();
          }, 
          function () {
          	if(!$(this).hasClass("active"))
          	 $(this).find("#tagManage").hide();
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

  
jQuery("#delbox_clear").click(function(event){
	 stopLeftMenu8Event(event);
	 var tip = "<%=SystemEnv.getHtmlLabelName(30838, user.getLanguage()) %>?";
	 window.top.Dialog.confirm(tip,function(){
	 	$.post("/email/new/MailManageOperation.jsp",{operation:'deleteAll',folderid:'-3'},function(){
			 jQuery("#delboxBtn").trigger("click");
		 })
	 });	
})

jQuery("#accountsBtn").click(function(event){
	stopLeftMenu8Event(event);
	$(".btnGrayDropContent").hide();
	//$(".accountsBtnDown").toggle();
	$("#ulReceiveBtn").toggleClass("changedisplay");
     $("#ulWriteBtn").removeClass("changedisplay");
	$(".mail").removeClass("isUl");
	$(this).parent().addClass("isUl");
}).hover(function(){
	$(this).addClass("mailBtnOver");
},function(){
	$(this).removeClass("mailBtnOver");
});

jQuery("#addMailsBtn").click(function(event){
	stopLeftMenu8Event(event);
	$(".btnGrayDropContent").hide()
	//$(".addMailsBtnDown").toggle();
	$("#ulWriteBtn").toggleClass("changedisplay");
    $("#ulReceiveBtn").removeClass("changedisplay");
	$(".mail").removeClass("isUl");
	$(this).parent().addClass("isUl");
}).hover(function(){
	$(this).addClass("mailBtnOver");
},function(){
	//todo
	$(this).removeClass("mailBtnOver");
});

jQuery(document).click(function(event){
	$(".btnGrayDropContent").hide().removeClass("changedisplay");
	$(".mail").removeClass("isUl");
	stopLeftMenu8Event(event); 
});

jQuery(".main").click(function(){
	if(jQuery("#"+jQuery(this).attr("target")).is(":hidden")){
		jQuery("#"+jQuery(this).attr("target")).show();
	}else{
		jQuery("#"+jQuery(this).attr("target")).hide();
	}
	 //同步菜单高度
	 $("#drillmenu").height($("#emailCenter").height());
	 jQuery("#leftMenu").scrollTo( {top:'0px',left:+'0px'}, 0 );
     syncLMHeight();
     updateHandleRequest();
});
	

	
	
	
jQuery(document).ready(function(){

    var clientScreenHeight = document.body.clientHeight;
	
	$("#inboxBtn").click(); //进入收件箱
	
	jQuery("#ulWriteBtn").width(jQuery("#leftMenu").width());
	jQuery("#ulReceiveBtn").width(jQuery("#leftMenu").width()).css("left",-jQuery("#leftMenu").width()/2);
	
   //下拉ul的背景色设置
	jQuery(".btnGrayDropContent li").hover(function(){//#ulReceiveBtn li
		//todo
		$(this).addClass("mailLiOver");
	},function(){
		$(this).removeClass("mailLiOver");
	}).click(function(){
		$(this).parents("td:first").removeClass("isUl");
	});
});

function stopLeftMenu8Event(event) {
	try {
		if (event.stopPropagation) {
			event.stopPropagation();
		} else {
			if (window.event) {
				window.event.cancelBubble = true;
			}
		}
	} catch (e) {
		if (window.event) {
			window.event.cancelBubble = true;
		}
	}
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
	color:#fffefe;
	height: 20px;
	padding:3px;
	list-style-type: none;
	
}

.changedisplay{
    display: block !important;
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
    /*background-color:rgb(63,63,63);*/
	left: -138px;
}
.hide{
	display: none;
}
.p-l-30{padding-left:30px;}



</style>
