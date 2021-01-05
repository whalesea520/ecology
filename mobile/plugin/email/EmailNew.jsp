
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.splitepage.transform.SptmForMail"%>
<%@page import="weaver.email.service.MailManagerService"%>
<%@page import="weaver.email.MailSend"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mms" class="weaver.email.service.MailManagerService" scope="page" />
<jsp:useBean id="MailConfigService" class="weaver.email.service.MailConfigService" scope="page" />
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/1/js/jquery-1.6.2.min_wev8.js'></script>
	<script type="text/javascript" src="/email/js/autocomplete/jquery.autocomplete_wev8.js"></script>
	<script type="text/javascript" src="/email/js/hotkeys/jquery.hotkeys_wev8.js"></script>
	<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
	<link href="/email/js/autocomplete/jquery.autocomplete_wev8.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="/wui/common/css/w7OVFont_wev8.css" type="text/css">
	

	<style type="text/css">
	html,body {
		height:100%;
		margin:0;
		padding:0;
		font-size:9pt;
		background: white;
	}
	a {
		text-decoration: none;
		cursor: pointer;
	}
	table {
		border-collapse: separate;
		border-spacing: 0px;
	}
	#page {
		width:100%;
		height:100%;
		background: white;
	}
	
	#header {
		width: 100%;
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
			endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),
			to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		/*
			filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;
			*/
	}
	#header_seach {
		width: 100%;
		background-color: #7f94af;
		border-top: #CCC solid 1px;
		border-bottom: #CCC solid 1px;
		height: 44px;
	}
	#header #title {
		color: #336699;
		font-size: 20px;
		font-weight: bold;
		text-align: center;
	}
	
	#loading {
		width: 250px;
		height: 65px;
		line-height: 65px;
		position: absolute;
		background: url("/mobile/plugin/images/loading_bg_wev8.png");
		top: 50%;
		left: 50%;
		display: block;
		text-align: center;
		margin-top: -32px;
		margin-left: -125px;
		z-index: 1002;
	}
	
	#loadingmask {
		position: absolute;
		width: 100%;
		height: 100%;
		z-index: 1001;
		display: block;
		filter:alpha(opacity=30); BACKGROUND-COLOR: #7f94af;
		opacity:0.3;
		overflow: hidden;
		top: 0;
		left: 0;
	}
	
	/* 流程搜索区域 */
	.search {
		width: 100%;
		height:44px;
		text-align: center;
		position: relative;
		background-color: #7f94af;

	}
	
.emailNewText {
	width: 100%;
	height: 30px;
	margin-left: auto;
	margin-right: auto;
	background: #fff;
	padding-top:0px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	border-radius: 5px;
	-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
	-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
	
}
	
	
	
	.prompt {
		color: #777878;
	}
	
	/* 列表区域 */
	.list {
		width: 100%;
		background: url(/images/bg_w_75_wev8.png);
	}
	/* 列表项文本框*/
	.listitem {
		width: 100%;
		height: *;
		background: url(/images/bg_w_25_wev8.png);
		border-bottom: 1px solid #D8DDE4;
		cursor: pointer;
	}
	/* 列表项文本域*/
	.listitem-text {
		width: 100%;
		height: 100px;
		background: url(/images/bg_w_25_wev8.png);
		border-bottom: 1px solid #D8DDE4;
		cursor: pointer;
	}
	/* 列表项后置导航 */
	.itemnavpoint {
		height: 100%;
		width: 26px;
		text-align: center;
	}
	/* 列表项后置导航图  */
	.itemnavpoint img {
		width: 10px;
		heigth: 14px;
	}
	/* 流程创建人头像区域  */
	.itempreview {
		height: 100%;
		width: 5px;
		text-align: center;
	}
	/* 流程创建人头像  */
	.itempreview img {
		width: 40px;
		height: 40px;
		margin-top: 4px;
	}
	
	/* 列表项内容区域 */
	.itemcontent {
		width: *;
		height: 100%;
		font-size: 14px;
		cursor: pointer;
	}
	
	/* 列表项内容名称 */
	.itemcontenttitle {
		width: 100%;
		height: 40px;
		overflow-y: hidden;
		line-height: 40px;
		font-weight: bold;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		font-size: 14px;
	}
	
	/* 列表项内容简介 */
	.itemcontentitdt {
		width: 100%;
		height: 23px;
		overflow-y: hidden;
		line-height: 23px;
		font-size: 12px;
		color: #777878;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	/*底部菜单 */
	.listitemmore {
		height: 50px;
		text-align: center;
		line-height: 50px;
		background-color: #ececec;
	}
	/*底部菜单图标 */
	.listitemmore  img{
		width: 40px;
		height: 38px;
		margin: 0px;
		cursor: pointer;
	}
	
	/* 列表更新时间 */
	.lastupdatedate {
		width: 100%;
		height: 20px;
		text-align: right;
		font-size: 12px;
		line-height: 20px;
		background: #E1E8EC;
		background: -moz-linear-gradient(0, white, #E1E8EC);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(white),
			to(#E1E8EC) );
	}
	/* 间隔 */
	.blankLines {
		width: 100%;
		height: 1px;
		overflow: hidden;
		background-color: #ececec;
		
	
	}
	
	/* 列表项标题 */
	.ictwz {
		width: *;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	
	/* new */
	.ictnew {
		width: 70px;
	}
	
	.tdimg{
		border-top: 1px solid black;
		border-left: 1px solid black;
		border-bottom: 1px solid black;
		border-right:0px;
		background-color: white;
		vertical-align:middle;
		padding-left: 5px;
		padding-top: 3px;
		cursor: pointer;
	}
	
	.tdinput{
		border-top: 1px solid black;
		border-right: 1px solid black;
		border-bottom: 1px solid black;
		border-left:0px;
		background-color: white;
		vertical-align:middle;
	}
	
	
	 .inputSelected{
 			border: 1px solid blue !important;
 	} 
 	
 	 .editableAddr-ipt{
			position:relative;
			left: 0;
			top: 0;
			width: 100%;
			font-family: tahoma,verdana;
			margin: 0;
			padding: 0;
			display: inline;
			border: 0;
			outline: 0;
			background: transparent;
}
.editableAddr-txt{
	visibility: hidden;
	color: #999;
	
}

.editableAddr {
	float: left;
	
	white-space: nowrap;
	position: relative;
	max-width: 465px;
	
	height: 18px;
	line-height: 18px;
	color: #999;
	font-size: 12px;
	cursor: text;
	margin-top: 5px;
	
}

 .mailAdSelect{	
 	color:#ffffff!important;
 	background: #36c!important;
 	border-radius:3px;		
 }
 
 .mailAdOK{
 	background: #DBF2E0;
 	border-color:#8EAF95;
 	border-radius:2px;	
 }
  .mailAdOK span{
  	vertical-align: middle;
  }
 .mailAdError{	
 	color:#c30;
 	background:  #FFEAEA;
 	border-radius:3px;		
 }
 
 .closeLb{
		background: url("/email/images/closeNew_wev8.png") left center;
		background-repeat: no-repeat;
		width: 18px;
		height: 20px;
		margin-right: 5px;
		z-index: 10000;
		cursor: pointer;
	}
	
	.mailInput{
	
	min-height: 28px;
	
	height:auto !important;height:28px;
	
	cursor: text;
	padding: 0px;
	display:inline-block;
}
.operationBt{
		height: 26px;
		margin-left:10%;
		line-height: 26px;
		font-size: 14px;
		padding-left: 10px;
		padding-right: 10px;
		color: #fff;
		text-align: center;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		border-radius: 5px;
		border: 1px solid #0084CB;
		background: #0084CB;
		background: -moz-linear-gradient(0, #30B0F5, #0084CB);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5), to(#0084CB) );
		overflow: hidden;
		float: left;
}

.operationBtright{
		height: 26px;
		margin-right:10%;
		line-height: 26px;
		font-size: 14px;
		padding-left: 10px;
		padding-right: 10px;
		color: #fff;
		text-align: center;
		-moz-border-radius: 5px;
		-webkit-border-radius: 5px;
		border-radius: 5px;
		border: 1px solid #0084CB;
		background: #0084CB;
		background: -moz-linear-gradient(0, #30B0F5, #0084CB);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(#30B0F5), to(#0084CB) );
		overflow: hidden;
		float: right;
}
.mailacc{display:none}
.left{	float:left!important;}   .clear {clear:both;} .right { float:right;}
.m-t-3{margin-top:3px}
.p-b-3{padding-bottom:3px}
.p-l-15{padding-left:15px}
	</style>
</head>
<body style="padding: 0px;margin: 0px">


<%


	int flag = Util.getIntValue(request.getParameter("flag"));
	int mailid = Util.getIntValue(request.getParameter("id"));
	String to = Util.null2String(request.getParameter("to"));
	String type = Util.null2String(request.getParameter("type"));//1，菜单界面点击进入，2其他界面点击进入
	String folderid ="-1";
	MailSend  s=new MailSend();
	String isInternal = Util.null2String(request.getParameter("isInternal"));//1是内部邮件
	String star = Util.null2String(request.getParameter("star"));
	
	//0--收件箱，1--发件箱，2--草稿箱，3--已删除，4内部邮件，5标星邮件，6我的文件夹
	String menuid=Util.null2String(request.getParameter("menuid"));
	String folderid06 ="";
	if("6".equals(menuid)){
			 folderid06 = Util.null2String(request.getParameter("folderid"));
	}
	
	String subject="";
	String sendfrom ="";
	String sendto = "";
	String sendcc = "";
	String sendbcc = "";
	String mailContent="";
	String mailaccountid="";
	String priority="";
	String accStr="";
	String accids ="";
	
	String Prev="";
	
		if(flag!=-1){
				if(flag ==1){//回复
						mms.getReplayMailInfo(mailid+"",user);
				}else if(flag==2){//回复全部
					mms.getReplayAllMailInfo(mailid+"",user);
				}else if(flag==3){//转发
					mms.getForwardMailInfo(mailid+"",user);
				}else if(flag==4){//草稿
					mms.getDraftMailInfo(mailid+"",user);
				}
				subject = Util.HTMLtoTxt(mms.getSubject()).replaceAll("\"", "");//主题
				sendfrom = mms.getSendfrom();//发件人
				sendto = mms.getSendto();
				sendcc = mms.getSendcc();//抄送
				sendbcc = mms.getSendbcc();//密送
				mailContent = mms.getContent();
				priority=mms.getPriority();

				if(flag==2){//回复全部
					sendbcc="";
				}
				
				if(flag==4){
		     			String fengeinput="<br><font style=color:red>"+SystemEnv.getHtmlLabelName(81409,user.getLanguage())+"</font><span id=EmailNew_fengeinput></span><br>";
		     			mailContent=mms.getContent().replace(fengeinput, "");
		     			mailContent=Util.replace(mailContent, "==br==", "\n", 0);
		     	}else{
		     		mailContent = mms.getContent();
		     	}
				accStr = mms.getAccStr();
				accids = mms.getAccids();
				
		}else{
				//表示是新建邮件
				mas.clear();
				mas.setIsDefault("1");
				mas.setUserid(user.getUID()+"");
				mas.selectMailAccount();
				if(mas.next()){
					sendfrom = mas.getAccountMailAddress();
					mailaccountid = mas.getAccountid();
				}
				if(!to.equals("")){
					sendto = to;
				}
		}
		mailContent = Util.replace(mailContent, "==br==", "\n", 0);
		mailContent=mailContent.replaceAll("/weaver/weaver.email.FileDownloadLocation[?]","/download.do?form_email=1&");
		
		String clienttype = Util.null2String((String)request.getParameter("clienttype"));
		String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
		
		String module=Util.null2String((String)request.getParameter("module"));
		String scope=Util.null2String((String)request.getParameter("scope"));
		
		Map mailConfig=MailConfigService.getMailConfig();
		int mailType=Util.getIntValue(Util.null2String(mailConfig.get("mailType")),0);
		
%>

<iframe name='hidden_frame' id="hidden_frame" style='display:none'></iframe>
<form id="dataForm" action="/mobile/plugin/email/EmailFileUpload.jsp" enctype="multipart/form-data" method="post" target="hidden_frame">
	<input id="uploaddata" type="hidden" name="uploaddata" />
	<input id="uploadname" type="hidden" name="uploadname" />
</form>

<table id="page"  style="width: 100%;height: 100%;"  cellpadding="0" cellspacing="0">
	<tr>
	<td width="100%" height="100%" valign="top" align="left">
		<form action="/mobile/plugin/email/EmailNewOperation.jsp" method="post" name="weaver" id="weaver" enctype="multipart/form-data" onsubmit="return checkRequired();">
		
		
		<input type="hidden" name="module"  id="module"  value="<%=module%>"/>
		<input type="hidden" name="scope"  id="scope"  value="<%=scope%>"/>
		<input type="hidden" name="folderid"  id="folderid"  value="<%=folderid%>"/>
		<input type="hidden" name="operation" id="operation" />
		<input type="hidden" name="attachmentCount" id="attachmentCount" value="-1" />
		<input type="hidden" name="savedraft" id="savedraft" value="0" />
		<input type="hidden" name="msgid" id="msgid" value="" />
		<input type="hidden" name="location" id="location" value="1" />
		<input type="hidden" name="type"  id="type" value="<%=type%>" />
		<input type="hidden" name="menuid"  id="menuid" value="<%=menuid%>" />
		<input type="hidden" name="savesend" id="savesend" value="1" />
		<input type="hidden" name="from_mobile" id="from_mobile" value="1" />
		<input type="hidden" name="mailid" id="mailid" value="<%=mailid%>" />
		<input type="hidden" name="flag" id="flag" value="<%=flag %>" />
		<input type="hidden" name="mobile_flag" id="mobile_flag" value="<%=flag%>" />
		<input type="hidden" name="mobile_mailid" id="mobile_mailid" value="<%=mailid%>" />
		
		<div id="header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
					<table style="width: 100%; height: 40px;">
						<tr>
							<td width="10%" align="left" valign="middle" style="padding-left:5px;">
									<%
											if("1".equals(type)){
										%>
												<a href="/mobile/plugin/email/EmailMenu.jsp?module=<%=module%>&scope=<%=scope%>">
										<%	
											}else{
											
													if(menuid.equals("6")){
										%>
												<a href="/mobile/plugin/email/EmailMain.jsp?folderid=<%=folderid06%>&isInternal=<%=isInternal %>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>">
										<%
											}else{
										%>
												<a href="/mobile/plugin/email/EmailMain.jsp?folderid=<%=folderid%>&isInternal=<%=isInternal %>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>">
										
										<%
											}
											}
										 %>
										
											<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
												<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>
											</div>
										</a>
							</td>
							<td align="center" valign="middle">
								<div id="title"><%=SystemEnv.getHtmlLabelName(1995,user.getLanguage()) %></div>
							</td>
							<td width="10%" align="right" valign="middle" style="padding-right:5px;">
								<%if(mailType==2 && flag != 3){%>
									<a href="#" id="inemail"  >
										<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
											<%=SystemEnv.getHtmlLabelName(1994,user.getLanguage()) %>
										</div>
									</a>
								<%}%>	
							</td>
						</tr>
					</table>
			</div>
			
			
			<div class='listitem'  >
			    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
									    
											    	<table style='width:100%;height:40px;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
													    	<colgroup>
												   				<col width="80px">
												   				<col width="*">
												   				<col width="20">
												   			</colgroup>
													    	<tr>
													    	<td class='ictwz'>
													    				<%=SystemEnv.getHtmlLabelName(2034,user.getLanguage()) %>
													    	</td>
													    	
						
													    							<td>
																    					<select name="mailAccountId" id="mailAccountId" style='width:100%;'>
																							<%
																								mas.clear();
																								mas.setUserid(user.getUID()+"");
																								mas.selectMailAccount();
																								boolean flagcheck=true;
																								while(mas.next()){
																									String tempMail = getDefaultSendFrom(mms,mas.getAccountMailAddress());
																									if(!tempMail.equals("")){
																										if(tempMail.equals(mas.getAccountMailAddress())){
																											flagcheck=false;
																											%>
																											<option value="<%=mas.getId()%>" selected="selected"><%=mas.getAccountname() %></option>
																											<%
																										}else{
																											%>
																											<option value="<%=mas.getId()%>"><%=mas.getAccountname()%></option>
																											<%
																										}
																									}else{
																										if(mas.getIsDefault().equals("1")&&flagcheck){
																											%>
																											<option value="<%=mas.getId()%>" selected="selected"><%=mas.getAccountname() %></option>
																											<%
																										}else{
																											%>
																											<option value="<%=mas.getId()%>" ><%=mas.getAccountname() %></option>
																											<%
																										}
																									}
																									%>
																									<%
																								}
																							%>
																							</select>
													    							</td>
															    					<td>
															    						
															    					</td>
													    	</tr>
											    	</table>
									    	
							    	</td>
							    	<td class='itemnavpoint'>
							    	</td>
					    	</tr>
			    	</table>
		    </div> 
		    
		    
		   
				
		      <div class='listitem'  >
			    	<table    style='width:100%;;border:0;cellspacing:0;cellpadding:0;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
									    	
											    	<table style='width:100%;border:0;cellspacing:0;cellpadding:0;'>
													    	<colgroup>
												   				<col width="80px">
												   				<col width="*">
												   				<col width="20">
												   			</colgroup>
													    	<tr>
													    	<td class='ictwz'>
													    					
																		<%=SystemEnv.getHtmlLabelName(2046,user.getLanguage()) %>
													    	</td>
								    					 	<td>
								    					 			
								    					 		<input class="" width="20" style="width: 20" type="hidden" name="to" id="to" >
																<div class="input mailInput " id="toDiv"  target="to" style="min-height:28px; width: 90%;cursor: text;border-bottom: #969696 1px solid;">
																<%
																		ArrayList checklist=new ArrayList();
																	    SptmForMail sm=new SptmForMail();
																		String sendto_sz[]=sendto.split(",");
																		for(int i=0;i<sendto_sz.length;i++){
																			if(!"".equals(sendto_sz[i]) && sendto_sz[i].indexOf("@") != -1){
																			String jieshou=sm.getNameByEmailNoHref(sendto_sz[i],user.getUID()+"");
																			if(null!=jieshou&&!"".equals(jieshou)){
																				jieshou.replace("&gt;", ">").replace("&lt;", "<");
																			}
																			if(checklist.contains(jieshou)==false){
																					checklist.add(jieshou);
																					String temp_sz=jieshou+";";
																%>
																		<div style="margin: 3px; float: left;" class="mailAdItem mailAdOK" title="<%=temp_sz %>" unselectable="on">
																		<em onclick="insertBeforeThis(this,event)">&nbsp;</em>
																		<span onblur="mailUnselect(this)" onmouseover="mailOver(this)" onmouseleave="mailLeave(this)" onclick="selectMail(this,event)">
																			<%=temp_sz %>
																			<em class='hand closeLb' style=''>&nbsp;&nbsp;&nbsp;&nbsp;</em>
																			</span><em onclick="insertAfterThis(this,event)">&nbsp;</em>
																		</div>
																
																		
																<%
																				}
																		 }
																	}
																 %>
																</div>
										    				</td>
										    				<td>
										    							<span  id=tospan >
										    									<%
										    										if("".equals(sendto)){
										    									%>
										    										<img src='/images/BacoError_wev8.gif' align="absMiddle" >
										    									<%	
										    										}
										    									 %>
										    								
										    							</span>
								    						</td>
													    	</tr>
											    	</table>
									    	
							    	</td>
							    	<td class='itemnavpoint'>
							    	</td>
					    	</tr>
			    	</table>
		    </div> 
		    
	
		<div class='listitem'  >
			    	<table    style='width:100%;;border:0;cellspacing:0;cellpadding:0;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
									    
											    	<table style='width:100%;border:0;cellspacing:0;cellpadding:0;'>
													    	<colgroup>
												   				<col width="80px">
												   				<col width="*">
												   				<col width="20">
												   			</colgroup>
													    	<tr>
													    	<td class='ictwz'>
													    			
													    			<%=SystemEnv.getHtmlLabelName(2084,user.getLanguage()) %>
													    	</td>
								    						<td>
								    						
									    						<input class="" width="20" style="width: 20" type="hidden" name="cc" id="cc" >
																<div class="input mailInput "  id="ccDiv" target="cc" style="min-height:28px; width: 90%;cursor: text;border-bottom: #969696 1px solid;">
																	<%
																		ArrayList checklist02=new ArrayList();
																		String sendcc_sz[]=sendcc.split(",");
																		for(int i=0;i<sendcc_sz.length;i++){
																			if(!"".equals(sendcc_sz[i]) && sendcc_sz[i].indexOf("@") != -1){
																			String jieshou=sm.getNameByEmailNoHref(sendcc_sz[i],user.getUID()+"");
																			if(null!=jieshou&&!"".equals(jieshou)){
																				jieshou.replace("&gt;", ">").replace("&lt;", "<");
																			}
																			String temp_sz=jieshou+";";
																				if(checklist02.contains(jieshou)==false){
																					checklist02.add(jieshou);
																	%>
																			<div style="margin: 3px; float: left;" class="mailAdItem mailAdOK" title="<%=temp_sz %>" unselectable="on">
																			<em onclick="insertBeforeThis(this,event)">&nbsp;</em>
																			<span onblur="mailUnselect(this)" onmouseover="mailOver(this)" onmouseleave="mailLeave(this)" onclick="selectMail(this,event)">
																				<%=temp_sz %><em class='hand closeLb' style=''>&nbsp;&nbsp;&nbsp;&nbsp;</em></span><em onclick="insertAfterThis(this,event)">&nbsp;</em>
																			</div>
																	<%
																				}
																			 }
																		}
																	 %>
																</div>
																
									    						 
									    					</td>
									    					<td>
									    					</td>
													    	</tr>
											    	</table>
									    
							    	</td>
							    	<td class='itemnavpoint'>
							    	</td>
					    	</tr>
			    	</table>
		    </div> 
		    
		    <div class='listitem'  >
			    	<table    style='width:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
									   
											    	<table style='width:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
													    	<colgroup>
												   				<col width="80px">
												   				<col width="*">
												   				<col width="20">
												   			</colgroup>
													    	<tr>
													    	<td class='ictwz'>
													    			<%=SystemEnv.getHtmlLabelName(2085,user.getLanguage()) %>
													    	</td>
								    						<td>
								    							<input class="" width="20" style="width: 20" type="hidden" name="bcc" id="bcc" >
																<div class="input mailInput " id="bccDiv" target="bcc" style="min-height:28px; width: 90%;cursor: text;border-bottom: #969696 1px solid;">
																		<%
																		String sendbcc_sz[]=sendbcc.split(",");
																		for(int i=0;i<sendbcc_sz.length;i++){
																			if(!"".equals(sendbcc_sz[i]) && sendbcc_sz[i].indexOf("@") != -1){
																			//String temp_sz=sendbcc_sz[i]+";";
																			String jieshou=sm.getNameByEmailNoHref(sendbcc_sz[i],user.getUID()+"");
																			if(null!=jieshou&&!"".equals(jieshou)){
																				jieshou.replace("&gt;", ">").replace("&lt;", "<");
																			}
																			String temp_sz=jieshou+";";
																			
																		%>
																				<div style="margin: 3px; float: left;" class="mailAdItem mailAdOK" title="<%=temp_sz %>" unselectable="on">
																				<em onclick="insertBeforeThis(this,event)">&nbsp;</em>
																				<span onblur="mailUnselect(this)" onmouseover="mailOver(this)" onmouseleave="mailLeave(this)" onclick="selectMail(this,event)">
																					<%=temp_sz %><em class='hand closeLb' style=''>&nbsp;&nbsp;&nbsp;&nbsp;</em></span><em onclick="insertAfterThis(this,event)">&nbsp;</em>
																				</div>
																		<%
																				 }
																			}
																		 %>
																</div>
																
									    					</td>
									    					<td>
									    					</td>
													    	</tr>
											    	</table>
									   
							    	</td>
							    	<td class='itemnavpoint'>
							    	</td>
					    	</tr>
			    	</table>
		    </div> 
		  
		  <!--附件--start -->
		  <div class='listitem' >
			<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
						<tr>
								<td class='itempreview'>
								</td>
								<td class='itemcontent' >
												<table style='width:100%;border:0;cellspacing:0;cellpadding:0;'>
														<tr>
														<td class='ictwz'>
															<%=SystemEnv.getHtmlLabelName(156,user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														</td>
														<td valign="top">		
															<div onclick='addUpload(event,this)' style="width: 30px; height: 36px; background: url('/images/search_icon_wev8.png') no-repeat ;margin-top: 2px"></div>
															<input type="hidden" id="accids" name="accids" value="<%=accids%>">
															<input type="hidden" name="delaccids" id="delaccids" value="">  
														</td>
														<td id="accstr"  class="itemcontentitdt"  style="width:90%;white-space:normal;">
															<%=accStr%>		
														</td>
														<td>
																
																		
														</td>
														</tr>
												</table>
									
								</td>
								<td class='itemnavpoint'>
								</td>
						</tr>
				</table>
		</div> 
		<!--附件--end -->	


		  <div class='listitem'  >
			    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
									    	
											    	<table style='width:100%;height:40px;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
													    	<colgroup>
												   				<col width="80px">
												   				<col width="*">
												   				<col width="20">
												   			</colgroup>
													    	<tr>
													    	<td class='ictwz'>
													    					<%=SystemEnv.getHtmlLabelName(344,user.getLanguage()) %>
													    	</td>
								    					 	<td>
										    					<input type="text"     style="width: 90%"  name="subject"  id="subject"  class="emailNewText "   value="<%=subject%>" onblur="checkinput02('subject','subjectspan')">
										    				</td>
										    				<td>
										    							<span  id=subjectspan>
										    										<%
										    											if(flag==-1){
											    									%>
											    										<img src='/images/BacoError_wev8.gif' align="absMiddle" >
											    									<%	
											    										}
											    									 %>
										    							</span>
								    						</td>
													    	</tr>
											    	</table>
									    
							    	</td>
							    	<td class='itemnavpoint'>
							    	</td>
					    	</tr>
			    	</table>
		    </div> 
		    
		    
		     <div class='listitem'  >
			    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
									    	
											    	<table style='width:100%;height:40px;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
													    	<colgroup>
												   				<col width="80px">
												   				<col width="*">
												   				<col width="20px">
												   			</colgroup>
													    	<tr>
													    	<td class='ictwz'>
													    					
													    					<%=SystemEnv.getHtmlLabelName(848,user.getLanguage()) %>
													    	</td>
								    					 	<td>
								    					 			
								    					 			
										    						<select name="priority">
										    								<option value=3  <%if("3".equals(priority)){out.println("selected='selected'");} %>><%=SystemEnv.getHtmlLabelName(2086,user.getLanguage()) %></option>
										    								<option value=1  <%if("1".equals(priority)){out.println("selected='selected'");} %>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage()) %></option>
										    						</select>
										    				</td>
										    				<td>
								    						</td>
													    	</tr>
											    	</table>
									    
							    	</td>
							    	<td class='itemnavpoint'>
							    	</td>
					    	</tr>
			    	</table>
		    </div> 
		
			<div class='listitem-text '  style="height: 180px">
		    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
		    	<tr>
				    	<td class='itempreview'>
				    	</td>
				    	<td class='itemcontent'   >
				    		
						    			<table style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
						    			<colgroup>
									   				<col width="80px">
									   				<col width="*">
									   				<col width="20">
									   	</colgroup>
						    			<tr>
						    				<td>
								    			<%=SystemEnv.getHtmlLabelName(345,user.getLanguage()) %>
						    				</td>
						    				<td>
								    				<textarea rows="4"  name="mouldtext"  id="mouldtext" style="width: 100%"><%=mailContent%></textarea>
								    				
								    			
						    				</td>
						    				<td>
											</td>
						    			</tr>
						    			</table>
						    
				    	</td>
				    	<td class='itemnavpoint'>
				    	</td>
		    	</tr>
		    	</table>
		    </div> 
		    </form>
	</td>
</tr>
<tr>
	<td style="background-color: #ececec;">
			<table style="width: 100%; height: 60px;">
							<tr>
								<td   style="text-align: center;">
													<div class="operationBt " onclick="Savedata()">
											       		<%=SystemEnv.getHtmlLabelName(220,user.getLanguage()) %>
											       </div>
								</td>
								<td >
									
								</td>
								<td >
									
								</td>
								<td>
									
								</td>
								<td  style="text-align: center;">
									<div id="mobileSend" class="operationBtright " onclick="submitdata()">
							       		 <%=SystemEnv.getHtmlLabelName(2083,user.getLanguage()) %>
							       </div>
								</td>
							</tr>
						</table>
			
				
		</td>
</tr>	
</table>




<script type="text/javascript">


var clientVersion=0;
var clienttype="<%=clienttype%>";	
var flag="<%=flag%>";

var currentInputId="to";
var editorHeight=0;

var mailobj;


function getRealMailAddress(){
	$(".mailInputHide").val("");
	$(".mailAdOK").each(function(index) {
 	   	
	 	//alert($(this).attr("title"))
	 	if($(this).parent().attr("type")=="hrm"){
	 		var value = $("#"+$(this).parent().attr("target")).val()
	 		var dpvalue =  $("#"+$(this).parent().attr("target")+"dpid").val()
		 	if($(this).attr("dpid")*1==0&&$(this).attr("value")*1==0){
		 		$("#"+$(this).parent().attr("target")+"all").val(1);
		 		$("#"+$(this).parent().attr("target")).val('0')
		 		$("#"+$(this).parent().attr("target")+"dpid").val('0')
		 	}else if($(this).attr("dpid")*1>0&&$(this).attr("value")*1==0){
		 		dpvalue = dpvalue+$(this).attr("dpid")+","
		 		$("#"+$(this).parent().attr("target")+"dpid").val(dpvalue)
		 	}else{
		 		value =value+ $(this).attr("value")+","
		 		$("#"+$(this).parent().attr("target")).val(value)
		 	}
		 	
	 		
	 	}else{
	 		var value = $("#"+$(this).parent().attr("target")).val()
	 		//var value = ""; 
		 	value =value+ $(this).attr("title")+","
		 	
		 	$("#"+$(this).parent().attr("target")).val(value)
	 	}
	 	
	 });
	
	if($("#internalto").val()==''&&($("#internaltodpid").val()!=''||$("#internaltoall").val()!='')){
		$("#internalto").val("0")
	}
	
}


function doInput(obj){
	//$(obj).css('position','relative');	
	//var oTextCount = document.getElementById("char"); 
	iCount = obj.value.replace(/([^\u0000-\u00FF])/g,'aa').length; 
	 
	obj.size=iCount+1; 
	   
	    
}

function doRemove(obj){
	

	if($('.ac_results:visible').length>0){
		//zzl
		if($("#toDiv").find(".mailAdItem").length>0){
		//	alert("进来了");
			//alert($(obj).parent().parent().parent().find("input[id=to]").html()=="");
			//alert($("#toDiv").find(".mailAdItem").length);
			$("#tospan").html("");
		}else{
			$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
		}
		return;
	} else{
		//zzl
		//var  navclass = $(this).attr("class");
		//alert($(obj).parent().parent().parent().find(".mailAdItem").html());
		if($("#toDiv").find(".mailAdItem").length>0){
				$("#tospan").html("");
		}else{
			$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
		}
	} 
		
	$(obj).parent().remove();
	
}

function mailLeave(obj){
	
	$(obj).removeClass('mailAdOver')
}

function mailOver(obj){
	
	$(".mailAdOver").removeClass("mailAdOver");
	$(obj).addClass('mailAdOver')
}

function insertBeforeThis(obj,event){
	$(".mailAdOver").removeClass("mailAdOver");
	$(".mailAdSelect").removeClass("mailAdSelect");
	$('.mailInput').find(".mailinputdiv").remove();
	var edit = $('<span class="mailinputdiv editableAddr " >  <input size=1 style="*width:1px;overflow-x:visible;overflow-y:visible;" onblur="doRemove(this)" class="editableAddr-ipt" oninput="doInput(this)" onpropertychange="doInput(this)" onchange="addMailAddress(this)"><span class="editableAddr-txt"></span></span>')
	edit.insertBefore($(obj).parent());
	$('.mailInput').find('.editableAddr-ipt').focus();
	$(".editableAddr-ipt").bind('keydown', 'backspace',function (evt){
		if($(this).val()==''){
			$(this).parent().prev().remove();
		}
	});
	if($(obj).parent().parent().attr("type")=="hrm"){
		edit.find('.editableAddr-ipt').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
			minChars: 1,
			
			scroll: false,
			max:30,
			width:400,
			multiple:"",
			matchSubset: false,
		    scrollHeight: 500,
			matchContains: "word",
			autoFill: false,
			formatItem: function(row, i, max) {
				return  "\""+row.name +"\"";
			},
			formatMatch: function(row, i, max) {
				return row.name+ " " + row.pinyin+ " " + row.loginid;
			},
			formatResult: function(row) {
				return row.name+"|"+row.id+"|"+row.dpid;
			}
		});
	}else{
		edit.find('.editableAddr-ipt').autocomplete("/email/new/EmailData.jsp", {
			minChars: 1,
			
			scroll: false,
			max:30,
			width:400,
			multiple:"",
		    scrollHeight: 500,
			matchContains: "word",
			autoFill: false,
			formatItem: function(row, i, max) {
				return  row.name +"&lt;" + row.to + "&gt;";
			},
			formatMatch: function(row, i, max) {
				return row.name + " " + row.to;
			},
			formatResult: function(row) {
				return row.name +"|" + row.to;
			}
		});
	}
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation(); 
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
		if($("#toDiv").find(".mailAdItem").length>0){
				$("#tospan").html("");
		}else{
			$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
		}
}

function insertAfterThis(obj,event){
	$(".mailAdOver").removeClass("mailAdOver");
	$(".mailAdSelect").removeClass("mailAdSelect");
	$('.mailInput').find(".mailinputdiv").remove();
	var edit = $('<span class="mailinputdiv editableAddr " ><input size=1 style="*width:1px;overflow-x:visible;overflow-y:visible;" onblur="doRemove(this)" class="editableAddr-ipt" oninput="doInput(this)" onpropertychange="doInput(this)" onchange="addMailAddress(this)"><span class="editableAddr-txt"></span></span>')
	
	edit.insertAfter($(obj).parent());
	$('.mailInput').find('.editableAddr-ipt').focus();
	$(".editableAddr-ipt").bind('keydown', 'backspace',function (evt){
		if($(this).val()==''){
			$(this).parent().prev().remove();
		}
	});
	if($(obj).parent().parent().attr("type")=="hrm"){
		edit.find('.editableAddr-ipt').autocomplete("/email/new/GetData.jsp?searchtype=hrm", {
			minChars: 1,
			
			scroll: false,
			max:30,
			width:400,
			multiple:"",
			matchSubset: false,
		    scrollHeight: 500,
			matchContains: "word",
			autoFill: false,
			formatItem: function(row, i, max) {
				return  "\""+row.name +"\"";
			},
			formatMatch: function(row, i, max) {
				return row.name+ " " + row.pinyin+ " " + row.loginid;
			},
			formatResult: function(row) {
				return row.name+"|"+row.id+"|"+row.dpid;
			}
		});
	}else{
		edit.find('.editableAddr-ipt').autocomplete("/email/new/EmailData.jsp", {
			minChars: 1,
			
			scroll: false,
			max:30,
			width:400,
			multiple:"",
		    scrollHeight: 500,
			matchContains: "word",
			autoFill: false,
			formatItem: function(row, i, max) {
				return  row.name +"&lt;" + row.to + "&gt;";
			},
			formatMatch: function(row, i, max) {
				return row.name + " " + row.to;
			},
			formatResult: function(row) {
				return row.name +"|" + row.to;
			}
		});
	}
	
	
	if (event.stopPropagation) { 
		// this code is for Mozilla and Opera 
		event.stopPropagation(); 
	} 
	else if (window.event) { 
		// this code is for IE 
		window.event.cancelBubble = true; 
	}
	if($("#toDiv").find(".mailAdItem").length>0){
				$("#tospan").html("");
		}else{
			$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
		}
}

function selectMail(obj,event){
	$(".mailAdSelect").removeClass("mailAdSelect");
	$(obj).parent().addClass("mailAdSelect");
	
}

function mailUnselect(obj,event){
	$(obj).remove("mailAdSelect");
	
}




function addMailAddress(obj){
	
	obj.value = obj.value.toLowerCase();
	if($('.ac_results:visible').length>0){
		return;
	}
	
	if(!addToInput($(obj).parent().parent().attr("id"),obj.value,obj)){
		obj.value = "";
	}
}

//添加email地址
function addToInput(targetid,name,input){
	
	var div = $("#"+targetid);
	
	// 判断当前地址是否已存在,存在则不能重复添加
	if(mailIsExist(div,name)){
		//alert("<%=SystemEnv.getHtmlLabelName(31185,user.getLanguage()) %>!")
		return false;
	}
	
	//清除浮动层clear样式
	div.find(".clear").remove();
	
	//判断输入框类型，人力资源或邮件地址
	if(div.attr("type")=="hrm"){
		
		if(input==undefined){ // 由浏览框批量导入
			if(name!=""){
				
				var list = name.split("|")
				var html;
				if(list[1]=='0'){// 人员ID为0,即为部门信息
				
					
					html = $("<div class='mailAdItem mailAdOK' style='float:left;margin:3px'  unselectable='on' dpid='"+list[2]+"'  value='"+list[1]+"' title='"+list[0]+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+list[0]+"<em class='hand closeLb' style=''>&nbsp;&nbsp;&nbsp;&nbsp;</em></span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
					
				}else{
					
					
					html = $("<div class='mailAdItem mailAdOK' style='float:left;margin:3px'  unselectable='on' dpid='"+list[2]+"' value='"+list[1]+"' title='"+list[0]+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+list[0]+"<em class='hand closeLb' style=''>&nbsp;&nbsp;&nbsp;&nbsp;</em></span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
				}
				
				div.append(html);
				
				
				if($("#toDiv").find(".mailAdItem").length>0){
						$("#tospan").html("");
				}else{
					$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
				}
		
			}
			
		}else{// 自动联想输入
			if(name!=""){
				
				if($(input).attr("selected")=="true"){
					
					var list = name.split("|")
					if(list[1]=='0'){// 人员ID为0,即为部门信息
						html = $("<div class='mailAdItem mailAdOK' style='float:left;margin:3px'  unselectable='on' dpid='"+list[2]+"'  value='"+list[1]+"' title='"+list[0]+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+list[0]+"<em class='hand closeLb' style=''>&nbsp;&nbsp;&nbsp;&nbsp;</em></span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
					}else{
						html = $("<div class='mailAdItem mailAdOK' style='float:left;margin:3px'  unselectable='on' dpid='"+list[2]+"'  value='"+list[1]+"' title='"+list[0]+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+list[0]+"<em class='hand closeLb' style=''>&nbsp;&nbsp;&nbsp;&nbsp;</em></span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
					}
					if($(input).parent().prev().length>0){
						html.insertAfter($(input).parent().prev());
					}else if($(input).parent().next().length>0){
						html.insertBefore($(input).parent().prev());
					}else{
						div.append(html);
					}
				}
			
			}
			input.value="";
			
			$(input).parent().remove();
			
			if($("#toDiv").find(".mailAdItem").length>0){
					$("#tospan").html("");
			}else{
				$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
			}
		}
		
	}else{
		
		if(input == undefined){  // 由浏览框批量导入
			
			//name 格式为 xxxx<yyyyy@yyy.com>，需要处理，获取地址和名称
			var re = /([0-9A-Za-z\-_\.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)/gi; 
			var tmpemail = name.match(re); // 邮件地址
			var tmpname  = name.replace("<"+tmpemail+">","") // 名称
			
			var classname='';
			var validate = /^[\w\-\.]+@[\w\-\.]+(\.\w+)+$/;
			 if(!validate.test(tmpemail)){        
				 classname ='mailAdError'
			 }else{
				 classname ='mailAdOK'
			 }
				
			 if(tmpemail!=""){
			 	var html = $("<div class='mailAdItem "+classname+"' style='float:left;margin:3px' unselectable='on' title='"+tmpemail+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+tmpname+"&lt;"+tmpemail+"&gt;<em class='hand closeLb' style=''>&nbsp;&nbsp;&nbsp;&nbsp;</em></span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
				
				div.append(html);
				
			}
			
			if($("#toDiv").find(".mailAdItem").length>0){
					$("#tospan").html("");
			}else{
				$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
			}
			
		}else{
			//name 格式为 xxxx|yyyyy@yyy.com ，需要处理，获取地址和名称
			
			var list = name.split("|")
			if(list.length==1){
				name = name+"|"+name;
				list = name.split("|")
			}
			var tmpemail = list[1]; // 邮件地址
			var tmpname  = list[0] // 名称
			
			var classname='';
			var validate = /^[\w\-\.]+@[\w\-\.]+(\.\w+)+$/;
			 if(!validate.test(tmpemail)){        
				 classname ='mailAdError'
			 }else{
				 classname ='mailAdOK'
			 }
			if(tmpemail!=""){
				var html = $("<div class='mailAdItem "+classname+"' style='float:left;margin:3px' unselectable='on' title='"+tmpemail+"'><em onclick='insertBeforeThis(this,event)'>&nbsp;</em><span class='' onmouseover='mailOver(this)'  onmouseleave='mailLeave(this)' onblur='mailUnselect(this)' onclick='selectMail(this,event)'>"+tmpname+"&lt;"+tmpemail+"&gt;<em class='hand closeLb' style=''>&nbsp;&nbsp;&nbsp;&nbsp;</em></span><em onclick='insertAfterThis(this,event)'>&nbsp</em></div>");
				
				if($(input).parent().prev().length>0){
					html.insertAfter($(input).parent().prev());
				}else if($(input).parent().next().length>0){
					html.insertBefore($(input).parent().prev());
				}else{
					div.append(html);
				}
			}
						
			input.value="";			
			$(input).parent().remove();
			
			if($("#toDiv").find(".mailAdItem").length>0){
					$("#tospan").html("");
			}else{
				$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
			}
		}
		
	}
	div.find(".clear").remove();
	div.append("<div class='clear'></div>")
	if(div.height()>100){
		if(!div.hasClass("mailInputOverDisplay")){
			div.addClass("mailInputOverDisplay")
			//console.log('addClass')
		}		 
	}else if (div.height()<90){
		if(div.hasClass("mailInputOverDisplay")){
			div.removeClass("mailInputOverDisplay")
			//console.log('addClass')
		}
		
		//console.log('removeClass')
	}
	
	return true;
}

function mailIsExist(div,name){
	// 判断当前地址是否已存在,存在则不能重复添加
	var isExist = false;
	
	if(div.attr("type")=="hrm"){
		//alert(name)
		var list = name.split("|");
		//所有人
		if(div.find(".mailAdItem[value=0][dpid=0]").length>0){
			isExist = true;
		}
		//人员
		if(div.find(".mailAdItem[dpid="+list[2]+"][value="+list[1]+"]").length>0){ // 判断是否有相同人员
			
			isExist = true;
		}
		
		//部门
		if(list[1]!=0){ // 判断是该人员部门已存在
			if(div.find(".mailAdItem[dpid="+list[2]+"][value='0']").length>0){
			
				isExist = true;
			}	
		}else{
			if(list[2]==0){
				//div.find(".mailAdItem").remove();
			}else{
				//div.find(".mailAdItem[dpid="+list[2]+"][value!='0']").remove();
			}
			
		}
		
	}else{
		var re = /([0-9A-Za-z\-_\.]+)@([0-9a-z]+\.[a-z]{2,3}(\.[a-z]{2})?)/gi; 
		var tmpemail = name.match(re);
		if(div.find(".mailAdItem[title='"+tmpemail+"']").length>0){
			isExist = true;
		}
	}
	return isExist;
} 

jQuery(document).ready(function(){

if(clienttype=="android"||clienttype=="androidpad"){
			clientVersion=mobileInterface.getClientVersion();
}
		
$(".closeLb").live("click",function(event){
		
		$(this).parent().parent().remove();	
		if (event.stopPropagation) { 
			// this code is for Mozilla and Opera 
			event.stopPropagation(); 
		} 
		else if (window.event) { 
			// this code is for IE 
			window.event.cancelBubble = true; 
		}
		if($("#toDiv").find(".mailAdItem").length>0){
					$("#tospan").html("");
		}else{
			$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
		}
	})
$('.mailInput').click(function(event){
		
		if(event.target.tagName!='DIV'){
			return;
		}
		//alert($(this).attr("disabled"))
		if($(this).attr("disabled")=='true'){
			return;
		}
		$(".mailAdOver").removeClass("mailAdOver");
		
		$(".mailAdSelect").removeClass("mailAdSelect");
		var obj = $('<span class="mailinputdiv editableAddr " > <input size=1 style="*width:1px;overflow-x:visible;overflow-y:visible;" onblur="doRemove(this)" class="editableAddr-ipt" oninput="doInput(this)" onpropertychange="doInput(this)" onchange="addMailAddress(this)"><span class="editableAddr-txt"></span></span>')
		
		if($(this).find(".mailinputdiv").length==0){
			if($(this).find('.clear').length>0){
				obj.insertBefore($(this).find('.clear'));
				$(this).find(".mailinputdiv").find('.editableAddr-ipt').focus();
			}else{
				$(this).append(obj).find('.editableAddr-ipt').focus();
			}
		}else{
			$(this).find(".mailinputdiv").find('.editableAddr-ipt').focus();
		}
		
		try{
		
		$(this).find(".editableAddr-ipt").bind('keydown', 'backspace',function (event){
			if($(this).val()==''){
				
				if($(this).parent().prev().length>0){
					
					if ($(this).parent().prev().parent()[0].clientWidth < $(this).parent().prev().parent()[0].offsetWidth-4){   
						//执行相关脚本。   
					} else{
						
							$(this).parent().prev().parent().removeClass("mailInputOverDisplay");	
					}
					
				}
				$(this).parent().prev().remove();
			}
			if (event.stopPropagation) { 
				// this code is for Mozilla and Opera 
				event.stopPropagation(); 
			} 
			else if (window.event) { 
				// this code is for IE 
				window.event.cancelBubble = true; 
			}
		});
		}catch(e){
			
		}
		
		if($(this).attr("type")=="hrm"){
			//zzl
			var tt=$(this).find(".mailinputdiv").find('.editableAddr-ipt').val();
			obj.find('.editableAddr-ipt').autocomplete("/mobile/plugin/email/GetData.jsp?searchtype=hrm", {
				minChars: 1,
				
				scroll: false,
				max:30,
				width:400,
				multiple:"",
				matchSubset: false,
			    scrollHeight: 500,
				matchContains: "word",
				autoFill: false,
				formatItem: function(row, i, max) {
					return  ""+row.name +"<"+row.department+">";
				},
				formatMatch: function(row, i, max) {
					return row.name+ " " + row.pinyin+ " " + row.loginid;
				},
				formatResult: function(row) {
					return row.name+"|"+row.id+"|"+row.dpid;
				}
			});
			
		}else{
			obj.find('.editableAddr-ipt').autocomplete("/mobile/plugin/email/EmailData.jsp", {
				minChars: 1,
				
				scroll: false,
				max:30,
				width:400,
				multiple:"",
			    scrollHeight: 500,
				matchContains: "word",
				autoFill: false,
				formatItem: function(row, i, max) {
					return  row.name +"&lt;" + row.to + "&gt;";
				},
				formatMatch: function(row, i, max) {
					return row.name + " " + row.to;
				},
				formatResult: function(row) {
					return row.name +"|" + row.to;
				}
			});
		}
	
	});
							
		$("#inemail").click(function(){
					
						var temp_folderid="<%=folderid%>";
						<%
									if(menuid.equals("6")){
						%>
							temp_folderid="<%=folderid06%>";
						<%	
									}
						%>
						
				  		window.location.href="/mobile/plugin/email/EmailNewIn.jsp?folderid="+temp_folderid+"&isInternal=<%=isInternal%>&type=<%=type%>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
			
		});
		 if(isShowEditor()){
			//显示编辑器
			highEditor("mouldtext",150);
		}
	});
	
	
		function submitdata(){
				if(checkRequired()){
					/* if(flag!="-1"){
						//修改收件人的邮件状态到 收件箱
						$("#folderid").val("0");
					} */
					if(isShowEditor()){
						var editbody=$(KE.g["mouldtext"].edit.doc.body);
						editbody.find(".EmailNew_fengeinput").remove();
						transfertImg()
				    	//K.sync("#mouldtext"); //同步内容
				    	var isIOS = editbody.find("#ke-content-div-mobil");
				    	if(isIOS.length > 0) {
					    	$("#mouldtext").val(isIOS.html());
				    	} else {
					    	$("#mouldtext").val(editbody.html());
				    	}
				    }
					 if(flag!="4"){
					 	//非草稿状态的邮件不要传递邮件id到后台
					 	$("#mailid").val("");
					 }
					jQuery("#mobileSend").attr("disabled",true);
					jQuery("#mobileSend").attr("onclick",""); 
					$("#weaver").submit();
				}
		}
		
		//图片转换
		function transfertImg(){
			var editbody=$(KE.g["mouldtext"].edit.doc.body);
			editbody.find("img[src^='/download.do?form_email=1&']").each(function(){
							
				var imgsrc=$(this).attr("src");
				imgsrc=imgsrc.replace("/download.do?form_email=1&","/weaver/weaver.email.FileDownloadLocation?");
				
				$(this).attr("src",imgsrc);
				$(this).removeAttr("data-ke-src");
				
			});
		}
		
		function Savedata(){
				if(checkRequired()){
					if(flag!="4"){
					 	//非草稿状态的邮件不要传递邮件id到后台
					 	$("#mailid").val("");
					} 
				   if(isShowEditor()){
				   		var editbody=$(KE.g["mouldtext"].edit.doc.body);
						editbody.find(".EmailNew_fengeinput").remove();
						transfertImg()
				    	//K.sync("#mouldtext"); //同步内容
				    	var isIOS = editbody.find("#ke-content-div-mobil");
				    	if(isIOS.length > 0) {
					    	$("#mouldtext").val(isIOS.html());
				    	} else {
					    	$("#mouldtext").val(editbody.html());
				    	}
				    }
					$("#folderid").attr("value","-2");//设置为草稿状态
					$("#savedraft").attr("value","1");//只保存到草稿
					$("#weaver").submit();
				}
		}	
			
		function checkRequired()
	 	{
	 	
	 		getRealMailAddress();
	 		var temp=0;
			$(" span img").each(function (){
				if($(this).attr("align")=='absMiddle')
				{
					if($(this).css("display")=='inline')
					{
						temp++;
					}
				}
			});
			
			if($("#mailAccountId").val()==null){
				alert("<%=SystemEnv.getHtmlLabelName(83099,user.getLanguage()) %>"+"!");
				return false; 
			}
			
			if($(".mailAdError").length>0){
				alert("<%=SystemEnv.getHtmlLabelName(24570,user.getLanguage()) %>"+"!");
				return false;
			}
			if(temp!=0){
				alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>"+"!");
				return false;
			}else{
				return true;
			}
	 	}
	 	
 		//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
		function doLeftButton() {
			<%if("1".equals(type)){%>
					 window.location.href="/mobile/plugin/email/EmailMenu.jsp?module=<%=module%>&scope=<%=scope%>";
			<%	}else{%>
						var temp_folderid="<%=folderid%>";
						<%
									if(menuid.equals("6")){
						%>
							temp_folderid="<%=folderid06%>";
						<%	
									}
						%>
					 window.location.href="/mobile/plugin/email/EmailMain.jsp?folderid="+temp_folderid+"&isInternal=<%=isInternal %>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
			<%}%>			
			return "1";
		}
		
		
		function getLeftButton(){
			return "1,<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>";
		}
		//开启外部邮件才可以切换
		<%if(mailType==2  && flag != 3){%>
			function getRightButton(){
					return "1,<%=SystemEnv.getHtmlLabelName(1994,user.getLanguage()) %>";
					///mobile/plugin/email/EmailNew.jsp?type=1"
			}
			function doRightButton(){
				window.location.href="/mobile/plugin/email/EmailNewIn.jsp?folderid=<%=folderid%>&isInternal=<%=isInternal%>&type=<%=type%>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
				return "1";
			}
		<%}%>
		// 取消输入框后面跟随的红色惊叹号
		function checkinput02(elementname,spanid){
				
			var tmpvalue = $("#"+elementname).value;
		
			// 处理$GetEle可能找不到对象时的情况，通过id查找对象
		    if(tmpvalue==undefined)
		        tmpvalue=document.getElementById(elementname).value;
		
			while(tmpvalue.indexOf(" ") >= 0){
				tmpvalue = tmpvalue.replace(" ", "");
			}
			if(tmpvalue != ""){
				while(tmpvalue.indexOf("\r\n") >= 0){
					tmpvalue = tmpvalue.replace("\r\n", "");
				}
			
				if(tmpvalue != ""){
					$("#"+spanid).html("");
				}else{
					$("#"+spanid).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
					//$GetEle(elementname).value = "";
				}
			}else{
				$("#"+spanid).html( "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
				//$GetEle(elementname).value = "";
			}
		}
		
		
function highEditor(remarkid,height){
    height=!height||height<150?150:height;
    
    if(jQuery("#"+remarkid).is(":visible")){

		var  items=[
						'justifyleft', 'justifycenter', 'justifyright','bold','italic','fullscreen'
				   ];
			 
		 K.createEditor({
				id : remarkid,
				height :height+'px',
				themeType:'mobile',
				resizeType:1,
				width:'100%',
				uploadJson:'/weaverEditor/jsp/upload_json.jsp',
			    allowFileManager : false,
                newlineTag:'br',
                filterMode:false,
				imageTabIndex:1,
				langType : 'en',
                items : items,
			    afterCreate : function(id) {
					//KE.util.focus(id);
					this.focus();
			    }
   		});
	}
}

function isShowEditor(){
 	if(!((clienttype=="android"||clienttype=="androidpad")&&clientVersion<14))
		return true;
	else
		return false; 
}

function callbackUpload(name,data,index) {
	if(data) $('#uploaddata').val(data);
	if(name) $('#uploadname').val(name);
	$("#dataForm")[0].submit();
}

var thisobj;
function addUpload(e,obj) {
	var index=1;
	thisobj=obj;
	location = "emobile:upload:callbackUpload:"+index+":"+e.clientY+":clearAppendix";
			   
}
function clearAppendix(){
	var ids = jQuery("#accids").val();
	jQuery("#accstr>div").remove();
	jQuery("#accids").val("");
	jQuery("#delaccids").val(ids);
}
  
function callback(docid){
	var linkStr=$("#hidden_frame").contents().find("#linkStr").html();
	$("#accstr").append(linkStr);
	var accids=$("#accids").val();
	if(accids=="")
		accids=","+docid+",";
	else
		accids=accids+docid+",";
	$("#accids").val(accids);		
}

function doDelAcc(id){
	var ids = jQuery("#accids").val();
	ids = ids.replace(","+id+",",",")
	jQuery("#accids").val(ids);
	jQuery("#"+id).remove();
	
	var delids = jQuery("#delaccids").val();
	if(delids!=""){
		delids = delids+","+id;
	}else{
		delids = id;
	}
	jQuery("#delaccids").val(delids);
}

	
</script>
		<%!
	public String getDefaultSendFrom(MailManagerService mms,String accountMail){
		//System.out.println(mms.getSendfrom());
		//System.out.println(accountMail);
		if(mms.getTagvalues().indexOf(accountMail.toLowerCase())>-1){
			return accountMail;
		}
		//System.out.println(mms.getSendcc());
		//System.out.println(accountMail);
		if(mms.getSendcc().toLowerCase().indexOf(accountMail.toLowerCase())>-1){
			return accountMail;
		}
		//System.out.println(mms.getSendbcc());
		//System.out.println(accountMail);
		if(mms.getSendbcc().toLowerCase().indexOf(accountMail.toLowerCase())>-1){
			return accountMail;
		}
		return "";

	}

%>


</body>
</html>