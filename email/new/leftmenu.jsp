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
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<link rel="stylesheet" href="/email/js/jscrollpane/jquery.jscrollpane_wev8.css" />
<script type="text/javascript" src="/email/js/jscrollpane/jquery.mousewheel_wev8.js"></script>
<script type="text/javascript" src="/email/js/jscrollpane/jquery.jscrollpane.min_wev8.js"></script>
<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<script charset="utf-8" type="text/javascript" src="/email/js/leftmenu_wev8.js"></script>
<style>
div{
 	font-size: 12px;
 	font-family:Microsoft YaHei
}
</style>
<%
	mss.selectMailSetting(user.getUID());
	int userLayout = Util.getIntValue(mss.getLayout(),0);
	int isScroll = Util.getIntValue(request.getParameter("isScroll"),0);
	String frame = Util.null2String(request.getParameter("frame"),"mainFrame");

	rs.execute("select innerMail , outterMail from MailConfigureInfo");
	int innerMail = 1;
	int outterMail = 1;
	while(rs.next()){
		innerMail = rs.getInt("innerMail");
		outterMail = rs.getInt("outterMail");
	}
 %>
<center>
<div class="center" style="width:160px;<%=frame.equals("mainFrame")?"":"margin-top:10px;"%>">

 
<div class=" h-30 center" style="width:161px; background: url('/email/images/leftBtnBg_wev8.png') no-repeat;margin-left: 0px">
	<table class="w-all h-30" cellpadding="0" cellspacing="0">
		<tr>
			<td  class="bold colo333  relative  hand"  align="right" width="50%" style="border-right: 1px solid #96bdc5;">
				
				<div class="left <%if(user.getLanguage() != 8){out.print("p-l-30");} %>  relative hand" id="addMail" onclick="addMail()" style="padding-top: 5px">
					<img class="absolute" style="top:7px;left:5px" src="/email/images/newEmail_wev8.png"/>
					<%=SystemEnv.getHtmlLabelName(30912, user.getLanguage())%>
				</div>
				<div class="left hand" id="addMailsBtn" style="padding-top: 5px;width: 20px;height: 22px;">
					<img class="absolute" style="top:12px;right:5px" src="/email/images/iconDArr_wev8.png"/>
				</div>
				
				<div class="clear"></div>
				<ul class="btnGrayDropContent addMailsBtnDown hide " style="width: 160px;left: 0px;top:28px;" >
					<%
						if(innerMail==1){
					%>
						<li class=""  style="font-weight: normal;line-height: 20px;" onclick="addMail(1)" ><%=SystemEnv.getHtmlLabelName(24714,user.getLanguage())%></li>
					<%
						}
						if(outterMail==1){
					%>
						<li class=""  style="font-weight: normal;line-height: 20px;" onclick="addMail(0)"><%=SystemEnv.getHtmlLabelName(31139,user.getLanguage())%></li>
					<%
						}
					%>
					
				</ul>
			</td>
			<td id="" class="bold colo333 lh-30 relative   relative" width="50%">
				<div class="left p-l-30  relative hand" id="receiveMail" onclick="openMailUrl(this)" _folderid="0" _receivemailid="0">
					<img class="absolute" style="top:7px;left:5px" src="/email/images/getEmail_wev8.png"/>
					<%=SystemEnv.getHtmlLabelName(18526, user.getLanguage())%>
				</div>
				<div class="left hand" id="accountsBtn" style="padding-top: 5px;width: 20px;height: 22px;">
					<img class="absolute" style="top:12px;right:5px" src="/email/images/iconDArr_wev8.png"/>
				</div>
				
				<div class="clear"></div>
				<ul class="btnGrayDropContent accountsBtnDown hide " style="width: 160px;left: -80px;top:28px;" >
					<%
						mas.clear();
						mas.setUserid(user.getUID()+"");
						mas.selectMailAccount();
						if(outterMail == 1){
						while(mas.next()){
					%>
						<li class="" onclick="openMailUrl(this)" _folderid="0" _receivemailid="<%=mas.getId()%>" style="font-weight: normal;line-height: 20px;" target="<%=mas.getId()%>" ><%=mas.getAccountname() %></li>
					<%
					}}
					%>
				</ul>
						
			</td>
		</tr>
	</table>
</div>
<div id="autoHight" class="scroll-pane" style="height: auto;overflow: auto;">
				<div class="p-t-15">
					<div class="h-25  hand mailMenuItem" id="inboxBtn" _folderid="0" _receivemailid="0">
						<div class="left p-l-15"><img src="/email/images/inbox_wev8.png"></div>
						<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(19816, user.getLanguage())%></div>
						<div class="left">(<span id="unreadMailCount_id">0</span>)</div>
						<div class="clear"></div>
					</div>
					
					<div class="h-25  hand mailMenuItem" id="outboxBtn" id="outboxBtn" _folderid="-1">
						<div class="left p-l-15"><img src="/email/images/outbox_wev8.png"></div>
						<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(19558, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					
					<div class="h-25  hand mailMenuItem" id="drafboxBtn" _folderid="-2">
						<div class="left p-l-15"><img src="/email/images/draftbox_wev8.png"></div>
						<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(2039, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
					<div class="h-25  hand mailMenuItem" id="delboxBtn" _folderid="-3">
						<div class="left p-l-15"><img src="/email/images/delbox_wev8.png"></div>
						<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(2040, user.getLanguage())%></div>
						<div class="left p-l-15 colorddd hide  hand m-l-10" title="<%=SystemEnv.getHtmlLabelName(15504, user.getLanguage())%>" style="height:16px; background: url(/email/images/clear_wev8.png) no-repeat center center ;" id="removeAll"></div>
						<div class="clear"></div>
					</div>
						
					<div class="h-25  hand mailMenuItem" id="waitDealBtn"  _waitdeal='1'>
						<div class="left p-l-15"><img src="/email/images/mail_70_waitdeal_wev8.png"></div>
						<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(83090, user.getLanguage())%></div>
						<div class="left">(<span id="waitDealCount_id">0</span>)</div>
						<div class="clear"></div>
					</div>
						
					<div class="h-25  hand mailMenuItem" id="internal" _internal="1">
						<div class="left p-l-15"><img src="/email/images/internalbox_wev8.png"></div>
						<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(24714, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
						<div class="h-25  hand mailMenuItem" id="star" _star="1">
						<div class="left p-l-15"><img src="/email/images/importantbox_wev8.png"></div>
						<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(81337, user.getLanguage())%></div>
						<div class="clear"></div>
					</div>
			</div>
			
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="m-t-10">
				<div class="h-25  hand main" id="forder" target="subFolder">
					<div class="left p-l-15"><img src="/email/images/folder_wev8.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(81348, user.getLanguage())%></div>
					<div class="left p-l-15 colorddd hide  hand m-l-10" onclick="openMailUrl(this)" _url="/email/new/MailSetting.jsp?target=folder" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:16px; background: url(/email/images/manage_wev8.png) no-repeat center center ;" id="folderManage"></div>
					<div class="clear"></div>
				</div>
				<div class="p-l-30 hide" id="subFolder">
				<%
						ArrayList folderList= fms.getFolderManagerList(user.getUID());
							for(int i=0; i<folderList.size();i++){
								MailFolder mf = (MailFolder)folderList.get(i);
								%>
								<div class="h-25 subfolder  hand mailMenuItem" target="<%=mf.getId()%>" _folderid="<%=mf.getId()%>">
									<div class="left"><img src="/email/images/subfolder_wev8.png"></div>
									<div class="left color333 p-l-5 title" title="<%=mf.getFolderName()%>"><%=Util.getMoreStr(mf.getFolderName(),4,"...") %></div>
									<div class="clear"></div>
								</div>
								
								<%
							}
						%>
					
				</div>
				
				<div class="h-25  hand main" id="tag" target="subTag">
					<div class="left p-l-15"><img src="/email/images/tag_green_wev8.png"></div>
					<div class="left color333 p-l-5 "><%=SystemEnv.getHtmlLabelName(81349, user.getLanguage())%></div>
					<div class="left p-l-15 colorddd hide  hand m-l-10" onclick="openMailUrl(this)" _url="/email/new/MailSetting.jsp?target=label" title="<%=SystemEnv.getHtmlLabelName(633, user.getLanguage())%>" style="height:16px; background: url(/email/images/manage_wev8.png) no-repeat center center ;" id="tagManage"></div>
					<div class="clear"></div>
				</div>
				<div class="p-l-30 hide" id="subTag" >
				<%
						 ArrayList lmsList= lms.getLabelManagerList(user.getUID());
							for(int i=0; i<lmsList.size();i++){
								MailLabel ml = (MailLabel)lmsList.get(i);
								%>
								<div class="h-25 menulabel hand mailMenuItem" _labelid="<%=ml.getId()%>">
									<div class="left center p-t-5"><div style="width: 8px; height: 8px; overflow:hidden; background: <%=ml.getColor()%>"></div></div>
									<div class="left color333 p-l-5 title" title="<%=ml.getName()%>"><%=Util.getMoreStr(ml.getName(),4,"...") %></div>
									<div class="clear"></div>
								</div>
								<%
							}
				%>
				</div>
			</div>
			
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="p-t-10">
				<!-- 联系人 -->
				<div class="h-25  hand mailMenuItem" id='contactsBtn' _url="/email/new/Contacts.jsp">
					<div class="left p-l-15"><img src="/email/images/contacts_wev8.png"></div>
					<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(572, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
				<!-- 附件中心 -->
				<div class="h-25  hand mailMenuItem" id='contactsBtn' _url="/email/new/MailAttachmentTab.jsp">
					<div class="left p-l-15"><img src="/email/images/attach_wev8.png"></div>
					<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelNames("156,426", user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
			</div>
			
			<div class="line-gray1 m-l-15 m-r-30">&nbsp;</div>
			<div class="p-t-10">
				<!-- 邮件设置 -->
				<div class="h-25  hand mailMenuItem" id="mailSetting" _url="/email/new/MailSetting.jsp">
					<div class="left p-l-15"><img src="/email/images/setting_wev8.png"></div>
					<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelName(24751, user.getLanguage())%></div>
					<div class="clear"></div>
				</div>
				<!-- 邮件监控 -->
				<%if(HrmUserVarify.checkUserRight("Email:monitor",user)){ %>
				<div class="h-25  hand mailMenuItem" id="mailSetting" _url="/email/new/MailMonitorFrame.jsp">
					<div class="left p-l-15"><img src="/email/images/email_link_wev8.png"></div>
					<div class="left color333 p-l-5 title"><%=SystemEnv.getHtmlLabelNames("71,665", user.getLanguage())%></div> 
					<div class="clear"></div>
				</div>
				<%}%>
			</div>
</div>
</div>
</center>
<input type="hidden" name="menu_userLayout"  id="menu_userLayout"  value="<%=userLayout%>"/>
<script type="text/javascript">

var targetFrame="<%=frame%>";

jQuery(document).ready(function(){

	$(".mailMenuItem").click(function(){
		openMailUrl(this);
	});
	
	$("#inboxBtn").click(); //进入收件箱
	
    var clientScreenHeight = document.body.clientHeight;
	if("<%=isScroll%>"=="1"){
		$("#autoHight").css("height",clientScreenHeight-310+"px");
		$("#autoHight").css("width",$("#leftMenu").width()+4+"px");
		$('.scroll-pane').jScrollPane({
		        autoReinitialise: true  //内容改变后自动计算高度
		})
	}   
	
	jQuery("#delboxBtn").hover(
        function () {
            $(this).find("#removeAll").show();
          }, 
          function () {
          	 $(this).find("#removeAll").hide();
          }
  );
  
  
	jQuery("#tag").hover(function () {
		    $(this).find("#tagManage").show();
		 }, 
		 function(){
		    $(this).find("#tagManage").hide();
		 }
	 );
	  
	  
	jQuery("#forder").hover(function (){
	     $(this).find("#folderManage").show();
	  },
	  function(){
	      $(this).find("#folderManage").hide();
	  }
	);
	
	jQuery("#removeAll").click(function(event){
		 var tip = "<%=SystemEnv.getHtmlLabelName(30838, user.getLanguage()) %>?";
		 stopEvent();
		 window.top.Dialog.confirm(tip,function(){
		 	$.post("/email/new/MailManageOperation.jsp",{operation:'deleteAll',folderid:'-3'},function(){
				 jQuery("#delboxBtn").trigger("click");
			 })
		 });	
	})
	
	jQuery("#accountsBtn").click(function(event){
		$(".btnGrayDropContent").hide()
		$(".accountsBtnDown").toggle();
		 stopEvent(); 
	})
	
	jQuery("#addMailsBtn").click(function(event){
		$(".btnGrayDropContent").hide()
		$(".addMailsBtnDown").toggle();
		stopEvent(); 
	})
	
	jQuery(document).click(function(event){
		$(".btnGrayDropContent").hide();
		 stopEvent(); 
	})
	
	jQuery(".main").click(function(){
		if(jQuery("#"+jQuery(this).attr("target")).is(":hidden")){
			jQuery("#"+jQuery(this).attr("target")).show();
		}else{
			jQuery("#"+jQuery(this).attr("target")).hide();
		}
	})
	
	mailUnreadUpdate();

})

</script>
<style>
.jspPane{
	margin-left: 0px!important;
	left:0px!important;
	width: 100%;
	
}
.scroll-pane{
	outline-color:#fff !important;
} 

-webkit-focus-ring-color{#fff !important}
.line-gray1{background:#a0c0c7;height:1px;line-height:1px;}
.line-gray2{background:#a0c0c7;height:2px;line-height:2px;}
.line-gray3{background:#a0c0c7;height:3px;line-height:3px;}
.center{text-align:center;margin-left:auto;margin-right:auto;} 

.btnGrayDropContent  li{
	background-color:#f8f8f8;
	cursor:pointer;
	text-align:left;
	font-size: 12px;
	padding-left:5px;
	padding-top: 2px;
	color:#555555;
	height: 20px;
	padding:3px;
	list-style-type: none;
	
}

.btnGrayDropContent  li:hover{
	background-color:#cccccc;
}
.btnGrayDropContent{
	border: #bbb solid 1px;
	border-collapse: collapse;
	border-spacing: 0px;
	cursor: pointer;
	display: block;
	font-size: 12px;
	font-weight: bold;
	margin: 0px;
	padding: 0px;
	z-index: 1000;
	width: 160px;
	top: 28px;
	position: absolute;
	text-align: center;
	line-height: 30px;
	left: -138px;
}
.hide{
	display: none;
}
</style>
