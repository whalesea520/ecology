
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.email.MailSend"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mms" class="weaver.email.service.MailManagerService" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
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
	<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
	<link rel="stylesheet" href="/wui/common/css/w7OVFont_wev8.css" type="text/css">
	<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4_wev8.js"></script>
	<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
	<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox_wev8.css">

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
			width: 100%;
			height: 200px;
			line-height: 200px;
			position: absolute;
			top: 30%;
			left: 0%;
			display: block;
			text-align: center;
			margin-top: -32px;
			margin-left: 0px;
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
.itemcontentitdt {
	width: 40px;
	height: 38px;
	overflow-y: hidden;
	line-height: 23px;
	font-size: 14px;
	color: #777878;
	word-break: keep-all;
	text-overflow: ellipsis;
	white-space: nowrap;
	overflow: hidden;
}
	/*底部菜单 */
	.listitemmore {
		height: 40px;
		text-align: center;
		line-height: 40px;
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
		width: 80px;
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
	
	.td_bgcolor{
		 BACKGROUND-COLOR: #ececec;
	}
	.displayno{
			display: none;
	}
	
	.btnGrayDropContent{
	position:absolute;
	top:25px;
	left:0;
	width:100%;
	border:1px solid #bbb;
	list-style:none;
	z-index:1000;
	
	-moz-box-sizing:border-box;
	-webkit-box-sizing:border-box;
	box-sizing:border-box;
	
	
	-moz-border-radius:3px;
	-webkit-border-radius:3px;
	border-radius:3px;
	
}
.btnGrayDropContent  li{
	background-color:#f8f8f8;
	cursor:pointer;
	text-align:left;
	font-size: 12px;
	padding-left:5px;
	padding-top: 2px;
	color:#555555;
	height: 40px;
	padding:3px;
	
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
.btnGrayDropContent  li:hover{
	background-color:#cccccc;
}
.mailacc{display:none}
.left{	float:left!important;}   .clear {clear:both;} .right { float:right;}
.m-t-3{margin-top:3px}
.p-b-3{padding-bottom:3px}
.p-l-15{padding-left:15px}
	</style>
</head>
<body style="padding: 0px;margin: 0px;height: 100%">


<%
	
	String clienttype = Util.null2String((String)request.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));

	int flag = Util.getIntValue(request.getParameter("flag"));
	int mailid = Util.getIntValue(request.getParameter("id"));
	String to = Util.null2String(request.getParameter("to"));
	String type = Util.null2String(request.getParameter("type"));
	String folderid ="-1";
	DepartmentComInfo departmentComInfo=new DepartmentComInfo();
	MailSend  s=new MailSend();
	String isInternal = Util.null2String(request.getParameter("isInternal"));//1是内部邮件
	String star = Util.null2String(request.getParameter("star"));
	//0--收件箱，1--发件箱，2--草稿箱，3--已删除，4内部邮件，5标星邮件，6我的文件夹
	String menuid=Util.null2String(request.getParameter("menuid"));
	String folderid06 ="";
	if("6".equals(menuid)){
			 folderid06 = Util.null2String(request.getParameter("folderid"));
	}
	String internalto="";
	String copyresourceids="";
	
	String subject="";
	String sendfrom ="";
	String sendto = "";
	String sendcc = "";
	String sendbcc = "";
	String mailContent="";
	String mailaccountid="";
	String priority="";//级别 3--普通，2--重要,1-低
	String toids="";          //接收人ids
    String ccids="";          //抄送人ids
    String bccids = "";      //密送人ids
    String toall="";
	String todpids="";
	String ccall = "";
	String ccdpids="";
	String bccall="";
	String bccdpids="";

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
				
				 toids= mms.getToids();         //接收人ids
			     ccids= mms.getCcids();             //抄送人ids
			     bccids = mms.getBccids();        //密送人ids
			     toall=mms.getToall();
			      todpids=mms.getTodpids();
				  ccall = mms.getCcall();
				  ccdpids=mms.getCcdpids();
				  bccall=mms.getBccall();
				  bccdpids=mms.getBccdpids();
			   
			   	//回复
		     	if(flag ==1){
		     		toids=s.trim((","+sendto+",").replace(","+user.getUID()+",", ","));
		     		toall="";
		     		todpids="";
		     		ccids="";
		     		ccdpids="";
		     		ccall="";
		     		bccids="";
		     		bccdpids="";
		     		bccall="";
		     	}
		     	//如果是回复全部
		        if(flag==2){
		      	   toids=s.trim((","+toids+",").replace(","+user.getUID()+",", ","));
		      	   bccids="";
		     	   bccdpids="";
		     	   bccall="";
		        }
		        //转发
		     	if(flag ==3){
		     		toids="";
		     		todpids="";
		     		toall="";
		     		ccids="";
		     		ccdpids="";
		     		ccall="";
		     		bccids="";
		     		bccdpids="";
		     		bccall="";
		     	}
		     	if(flag==4){
		     			String fengeinput="<br><font style=color:red>"+SystemEnv.getHtmlLabelName(81409,user.getLanguage())+"</font><span id=EmailNew_fengeinput></span><br>";
		     			mailContent=mms.getContent().replace(fengeinput, "");
		     			//Prev=HtmlUtil.formatHtmlBlog(Prev,false);
		     			
		     	}else{
		     		mailContent = mms.getContent();
		     	}
		     		
    
				mailContent = mms.getContent();
				priority=mms.getPriority();
				//对mailContent进行分割处理
				
				accStr = mms.getAccStr();
				accids = mms.getAccids();
				
				sendfrom = mms.getSendfrom();
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

	String module=Util.null2String((String)request.getParameter("module"));
	String scope=Util.null2String((String)request.getParameter("scope"));
		
	Map mailConfig=MailConfigService.getMailConfig();
	int mailType=Util.getIntValue(Util.null2String(mailConfig.get("mailType")),0);
	int isAll = Util.getIntValue(Util.null2String(mailConfig.get("isAll")),1);
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
		<input type="hidden" name="folderid" id="folderid"  value="<%=folderid%>"/>
		<input type="hidden" name="operation" id="operation" />
		<input type="hidden" name="attachmentCount" id="attachmentCount" value="-1" />
		<input type="hidden" name="savedraft" id="savedraft" value="0" />
		<input type="hidden" name="msgid" id="msgid" value="" />
		<input type="hidden" name="location" id="location" value="1" />
		<input type="hidden" name="isInternal" id=isInternal  value="1" />
		<input type="hidden" name="type" id="type" value="<%=type%>" />
		<input type="hidden" name="menuid" id="menuid" value="<%=menuid%>" />
		<input type="hidden" name="savesend" id="savesend" value="1" />
		<input type="hidden" name="from_mobile" id="from_mobile" value="1" />
		<input type="hidden" name="mailid" id="mailid" value="<%=mailid %>" />
		<input type="hidden" name="flag" id="flag" value="<%=flag %>" />
		<input type="hidden" name="mobile_flag" id="mobile_flag" value="<%=flag %>" />
		<input type="hidden" name="mobile_mailid" id="mobile_mailid" value="<%=mailid %>" />
		
		
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
												<a href="/mobile/plugin/email/EmailMain.jsp?folderid=<%=folderid06%>&isInternal=<%=isInternal %>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>">
										<%	
											}else{
										%>
												<a href="/mobile/plugin/email/EmailMain.jsp?folderid=<%=folderid%>&isInternal=<%=isInternal %>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>">
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
								<div id="title"><%=SystemEnv.getHtmlLabelName(1994,user.getLanguage()) %></div>
							</td>
							<td width="10%" align="right" valign="middle" style="padding-right:5px;">
								<%if(mailType==2 && flag != 3){%>
											<a href="#" id="inemail"  >
												<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
													<%=SystemEnv.getHtmlLabelName(1995,user.getLanguage()) %>
												</div>
											</a>
								<%}%>	
									
							</td>
						</tr>
					</table>
			</div>
			
				<!-- 发件人--start -->
					<div class='listitem' >
				    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
						    	<tr>
								    	<td class='itempreview'>
								    	</td>
								    	<td class='itemcontent' >
												    	<table style='width:100%;border:0;cellspacing:0;cellpadding:0;'>
														    	<tr>
														    	<td class='ictwz'>
														    					<!-- 发件人 -->
														    					<%=SystemEnv.getHtmlLabelName(2034,user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														    	</td>
								    							<td  class="itemcontentitdt"    style="width:90%;white-space:normal;">
					    												<select name="hrmAccountid" id="hrmAccountid">
																				<%
																				String[] resourceids=Util.TokenizerString2(Util.null2String(mms.getAllResourceids(""+user.getUID())),","); 
																				%>
																				<%for(int i=0;i<resourceids.length;i++){%>
																					<option value="<%=resourceids[i]%>" <%=resourceids[i].equals(sendfrom)?"selected":""%>><%=ResourceComInfo.getLastname(resourceids[i])%></option>
																				<%}%>
																			</select>	
					    										</td>
											    				<td></td>
														    	</tr>
												    	</table>
										    
								    	</td>
								    	<td class='itemnavpoint'>
								    	</td>
						    	</tr>
				    	</table>
			    </div> 
			    <!-- 发件人--end -->
			
				
				
				<!-- 收件人--start -->
					<div class='listitem' >
			    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
											    	<table style='width:100%;border:0;cellspacing:0;cellpadding:0;'>
													    	<tr>
													    	<td class='ictwz'>
													    					<!-- 收件人 -->
													    					<%=SystemEnv.getHtmlLabelName(2046,user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													    	</td>
							    							<td>		
								    					 			<div  id="selfid01" style="width: 30px; height: 36px;background: url('/images/search_icon_wev8.png') no-repeat;margin-top: 2px" class="selectPop" _toid="forwardresources01"  _selfid="selfid01">
																	</div> 
										    						<input  type="hidden" name="internalto" id="internalto"  value="<%=toids%>"  _toid="forwardresources01"  >
										    						<input  type="hidden" name="internaltodpid" id="internaltodpid"   value="<%=todpids%>">
										    						<input  type="hidden" name="internaltoall" id="internaltoall"   value="<%=toall%>">
							    							</td>
							    							<td id="forwardresources01"  class="itemcontentitdt"    style="width:90%;white-space:normal;">
				    												<span id="forwardresources01_1">
																		<%
																			String szto[]=toids.split(",");
					    													for(int i=0;i<szto.length;i++){
					    														if(!"".equals(szto[i])){
					    															out.println("<span keyid='"+szto[i]+"'  emailtype='1'>"+ResourceComInfo.getLastname(szto[i])+"</span>");




					    														}
					    													}
																		%>
																	</span>
																	<span id="forwardresources01_2">
																		<%
																			String szdpidsto[]=todpids.split(",");
					    													//人员1，部门2，所有人3
					    													//String emailtype="1";
					    													for(int i=0;i<szdpidsto.length;i++){
					    														if(!"".equals(szdpidsto[i])){
					    															out.println("<span keyid='"+szdpidsto[i]+"'  emailtype='2'>"+departmentComInfo.getDepartmentname(szdpidsto[i])+"</span>");
					    														}
					    													}
																		%>
																	</span>
																	<span id="forwardresources01_3">
																		<%
																			if("1".equals(toall)){
					  															out.println("所有人");
					  													     }
																		%>
																	</span>
				    										</td>
										    				<td>
										    								<span  id=tospan >
										    									<%
										    										if("".equals(toids)&&"".equals(todpids)&&"".equals(toall)){
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
		    <!-- 收件人--end -->
		  
		  
		  
		  <!--抄送人--start -->
					<div class='listitem' >
			    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
											    	<table style='width:100%;border:0;cellspacing:0;cellpadding:0;'>
													    	<tr>
													    	<td class='ictwz'>
													    
													    					<%=SystemEnv.getHtmlLabelName(17051,user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													    	</td>
							    							<td>		
								    					 			<div id="selfid02" style="width: 30px; height: 36px; background: url('/images/search_icon_wev8.png') no-repeat;margin-top: 2px" class="selectPop" _toid="forwardresources02" _selfid="selfid02">
																	</div> 
										    						<input  type="hidden" name="internalcc" id="internalcc"  value="<%=ccids%>"  _toid="forwardresources02"  >
										    						<input  type="hidden" name="internalccdpid" id=internalccdpid   value="<%=ccdpids %>" >
										    						<input  type="hidden" name="internalccall" id=internalccall   value="<%=ccall %>" >
							    							</td>
							    							<td id="forwardresources02"  class="itemcontentitdt"  style="width:90%;white-space:normal;">
				    												<span id="forwardresources02_1">
							    										<%
							    										String szcc[]=ccids.split(",");
				    													for(int i=0;i<szcc.length;i++){
				    														
				    														if(!"".equals(szcc[i])){
				    															out.println("<span keyid='"+szcc[i]+"'  emailtype='1'>"+ResourceComInfo.getLastname(szcc[i])+"</span>");
				    														}
				    													}
							    										%>
							    									</span>
							    									<span id="forwardresources02_2">
							    										<%
							    										String szdpidscc[]=ccdpids.split(",");
				    													for(int i=0;i<szdpidscc.length;i++){
				    														if(!"".equals(szdpidscc[i])){
				    															out.println("<span keyid='"+szdpidscc[i]+"'  emailtype='2'>"+departmentComInfo.getDepartmentname(szdpidscc[i])+"</span>");
				    														}
				    													}
							    										%>
							    									</span>
							    									<span id="forwardresources02_3">
							    										<%
							    										if("1".equals(ccall)){
				  															out.println("所有人");
				  														}
							    										%>
							    									</span>
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
		    <!--抄送人--end -->
		    
		    
		     <!--密送人--start -->
					<div class='listitem' >
			    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
											    	<table style='width:100%;border:0;cellspacing:0;cellpadding:0;'>
													    	<tr>
													    	<td class='ictwz'>
													    
													    					<%=SystemEnv.getHtmlLabelName(81316,user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
													    	</td>
							    							<td>		
								    					 			<div id="selfid03" style="width: 30px; height: 36px; background: url('/images/search_icon_wev8.png') no-repeat ;margin-top: 2px" class="selectPop" _toid="forwardresources03"  _selfid="selfid03">
																	</div> 
										    						<input  type="hidden" name="internalbcc" id="internalbcc"  value="<%=bccids%>"  _toid="forwardresources03"  >
										    						<input  type="hidden" name="internalbccdpid" id=internalbccdpid  value="<%=bccdpids%>" >
										    						<input  type="hidden" name="internalbccall" id=internalbccall  value="<%=bccall%>" >
										    						
							    							</td>
							    							<td id="forwardresources03"  class="itemcontentitdt"  style="width:90%;white-space:normal;">
				    													<span id="forwardresources03_1">
							    											<%
							    											if("1".equals(bccall)){
					  															out.println("所有人");
					  														}
							    											%>
							    										</span>
							    										<span id="forwardresources03_2">
							    											<%
							    											String sz[]=bccids.split(",");
					    													for(int i=0;i<sz.length;i++){
					    														if(!"".equals(sz[i])){
					    															out.println("<span keyid='"+sz[i]+"'  emailtype='1'>"+ResourceComInfo.getLastname(sz[i])+"</span>");
					    														}
					    													}
							    											%>
							    										</span>
							    										<span id="forwardresources03_3">
							    											<%
							    											String szdpids[]=bccdpids.split(",");
					    													for(int i=0;i<szdpids.length;i++){
					    														if(!"".equals(szdpids[i])){
					    															out.println("<span keyid='"+szdpids[i]+"'  emailtype='2'>"+departmentComInfo.getDepartmentname(szdpids[i])+"</span>");
					    														}
					    													}
							    											%>
							    										</span>
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
		    <!--密送人--end -->
		    
		    <!--附件--start -->
			<div class='listitem' >
			    <table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' valign="top">
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
		    
		    
		    <div class='listitem' >
			    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
											    	<table style='width:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
													    	<tr>
													    	<td class='ictwz'>
													    						<%=SystemEnv.getHtmlLabelName(344,user.getLanguage()) %>
													    	</td>
							    							<td style="width: 100%">		
								    					 			<input type="text"     style="width: 100%"  name="subject"  id="subject"  class="emailNewText "   value="<%=subject%>" onblur="checkinput02('subject','subjectspan')">
							    							</td>
							    							<td id="forwardresources"  class="itemcontentitdt" style="text-align: right;width: 20px">
				    													<span  id=subjectspan>
										    										<%if(flag==-1){%>
											    										<img src='/images/BacoError_wev8.gif' align="absMiddle" >
											    									<%} %>
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
											<div id="mobileSendInner" class="operationBtright  " onclick="submitdata()">
									       		 <%=SystemEnv.getHtmlLabelName(2083,user.getLanguage()) %>
									       </div>
								</td>
							</tr>
						</table>
			
			
				
				
				
				
			 
			
				
		</td>
</tr>	


</table>

<ul class="btnGrayDropContent " style="width: 100px;left: 0px;top:0px;padding: 0px;display: none;" id="btnGrayDropContent">
	<li class=""  style="font-weight: normal;line-height: 40px;font-size: 14px"  _xuhao="1"  >
		&nbsp;<%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>
	</li>
	<li class=""  style="font-weight: normal;line-height: 40px;font-size: 14px"  _xuhao="2" >
		&nbsp;<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></li>
	<%if(isAll == 1) {%>	
	<li class=""  style="font-weight: normal;line-height: 40px;font-size: 14px" _xuhao="3" >
		<input type="checkbox" class="" onclick="onShowAllResouce(this,event)"  title="<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>" _xuhao="3"   id="ckbox_e">
		<label _xuhao="3" ><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></label>
	</li>
	<% }%>			
	<input type="hidden"	 id="selected_input">			
	<input type="hidden"	 id="_selfid">			
						
</ul>


<script type="text/javascript">
		var flag="<%=flag%>";
		var clientVersion=0;
		var clienttype="<%=clienttype%>";	
		jQuery(document).ready(function(){
						
						if(clienttype=="android"||clienttype=="androidpad"){
							clientVersion=mobileInterface.getClientVersion();
						}
						 if(isShowEditor()){
							//显示编辑器
							highEditor("mouldtext",150);
						}
						 $(document).click(function(event){         
						 		$("#btnGrayDropContent").hide();
						 });
								 
						$("#inemail").click(function(){
									 		<%
												if(menuid.equals("6")){
											%>
													window.location.href="/mobile/plugin/email/EmailNew.jsp?folderid=<%=folderid06%>&isInternal=<%=isInternal%>&type=<%=type%>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
											<%
												}else{
											%>	
													window.location.href="/mobile/plugin/email/EmailNew.jsp?folderid=<%=folderid%>&isInternal=<%=isInternal%>&type=<%=type%>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
											<%	
												}
											%>
							});
							$(".btnGrayDropContent").click(function(event){
											var _xuhao=$(event.target).attr("_xuhao");
											var  selected_input=$("#selected_input").val();
											var  selected_selfid=$("#_selfid").val();
											var selectobj=$("#"+selected_input);
											var _selfid=$("#"+selected_selfid);
											var allid=_selfid.next().next().next().attr("id");
											if(_xuhao=="1"){
													 //点击的是人力资源
												    var selids=_selfid.next().val();
													var _name=_selfid.next().attr("name");
													var _totdid=_selfid.attr("_toid")+"_1";
													var url="/mobile/plugin/email/browser.jsp";
													var data="&returnIdField="+_name+"&returnShowField="+_totdid+"&method=listUser&isMuti=1&selids="+selids+"&allid="+allid;
													<%if (clienttype.equals("Webclient")) {%>
													var top = ($( window ).height()-150)/2;
													var width = window.innerWidth > 480 ? 480 : window.innerWidth - 20;
													$.open({
														id : "selectionWindow",
														url : url,
														data: "r=" + (new Date()).getTime() + data,
														title : "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %>",
														width : width,
														height : 155,
														scrolling:'yes',
														top: top,
														callback : function(action, returnValue){
														}
													}); 
													$.reload('selectionWindow', url + "?r=" + (new Date()).getTime() +data);
													<%}else{%>
														showDialog(url,data);
													<%}%>
											}else if(_xuhao=="2"){
													//点击的部门浏览按钮
												    var selids=_selfid.next().next().val();
													var _name=_selfid.next().next().attr("name");
													var _totdid=_selfid.attr("_toid")+"_2";
													var url="/mobile/plugin/email/browser.jsp";
													var data="&returnIdField="+_name+"&returnShowField="+_totdid+"&method=listDepartment&isMuti=1&selids="+"&allid="+allid;
													<%if (clienttype.equals("Webclient")) {%>
													var top = ($( window ).height()-150)/2;
													var width = window.innerWidth > 480 ? 480 : window.innerWidth - 20;
													$.open({
														id : "selectionWindow",
														url : url,
														data: "r=" + (new Date()).getTime() + data,
														title : "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %>",
														width : width,
														height : 155,
														scrolling:'yes',
														top: top,
														callback : function(action, returnValue){
														}
													}); 
													$.reload('selectionWindow', url + "?r=" + (new Date()).getTime() +data); 
													<%}else{%>
														showDialog(url,data);
													<%}%>
											}else{
												//点击的所有人
												 var temp_value=_selfid.next().next().next().val();
												 var _totdid=_selfid.attr("_toid");
												 if(temp_value==""){
												 	_selfid.next().val("");
												 	_selfid.next().next().val("");
												  	_selfid.next().next().next().val("1");
												    $("#"+_totdid+"_1").html("");
												  	$("#"+_totdid+"_2").html("");
												    $("#"+_totdid+"_3").html("所有人");
												 }else{
												 	_selfid.next().val("");
												 	_selfid.next().next().val("");
												 	_selfid.next().next().next().val("");
												 	$("#"+_totdid+"_1").html("");
												  	$("#"+_totdid+"_2").html("");
												    $("#"+_totdid+"_3").html("");
												 }
												 var internalto=$("#internalto").val();
									 			var internaltodpid=$("#internaltodpid").val();
									 			var internaltoall=$("#internaltoall").val();
									 			if(internalto==""&&internaltodpid==""&&internaltoall==""){
									 				$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
									 			}else{
									 				$("#tospan").html("");
									 			}
											}
										$("#btnGrayDropContent").hide();
							});
							$(".selectPop").click(function(event){
										var x=$(this).offset().left;
										var y=$(this).offset().top;
										$("#btnGrayDropContent").css("left",x+15+"px");
										$("#btnGrayDropContent").css("top",y+15+"px");
										$("#btnGrayDropContent").show();
										var _toid=$(this).attr("_toid");
										var _selfid=$(this).attr("_selfid");
										$("#selected_input").val(_toid);
										$("#_selfid").val(_selfid);
										var checkbox=$("#"+_selfid).next().next().next().val();
										if(checkbox=="1"){
												$("#ckbox_e").attr("checked","checked");
										}else{
												$("#ckbox_e").attr("checked","");
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
		});
	
		//各种浏览按钮通用
		function showDialog(url, data) {
				
				url = "/mobile/plugin/1/browser.jsp";
	
				var returnIdField = "";
				var returnShowField = "";
				var browserMethod = "";
				var browserTypeId = "";
				var customBrowType = "";
				var joinFieldParamsStr = "";
				var isMuti = "";
				
				var paramsArray = data.split("&");
				for (var i=0; i<paramsArray.length; i++) {
					var paramstr = paramsArray[i];
					
					var paramkv = paramstr.split("=");
					if (paramkv.length > 1) {
						if ("returnIdField" == paramkv[0]) {
							returnIdField = paramkv[1];
						}
						if ("returnShowField" == paramkv[0]) {
							returnShowField = paramkv[1];
						}
						
						if ("method" == paramkv[0]) {
							browserMethod = paramkv[1];
						}
						if ("isMuti" == paramkv[0]) {
							isMuti = paramkv[1];
						}
						if("joinFieldParams" == paramkv[0]){
							 joinFieldParamsStr = paramkv[1];
						}
					}
				}
				
				var oldVal = $("#" + returnIdField).val();
				var oldName = $("#" + returnShowField).text().replace(/( )+/g, ",");
				url = (url + "?r=" + (new Date()).getTime() + data);
				
				var splitChar = "@@TYLLKFGF@@";
				//人力资源
				if (browserMethod == "listUser") {
					url = "HRMRESOURCE";
					splitChar = ":";
				}
				
				
				var nativeUrl = "emobile" + splitChar + "Browser" + splitChar + url + splitChar + isMuti + splitChar + oldVal + splitChar + "setBrowserData" + splitChar + returnIdField + splitChar + returnShowField + splitChar + oldName;
				location = nativeUrl; 
		}

		function setBrowserData(returnIdField,returnShowField,ids,names,index){
			$("#"+returnIdField).val(ids);
			$("#"+returnShowField).html(names);
			closeDialog();
		}
	
		//发送邮件
		function submitdata(){
				if(checkRequired()){
									
 					if(isShowEditor()){
						var editbody = $(KE.g["mouldtext"].edit.doc.body);
                        editbody.find(".EmailNew_fengeinput").remove();
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
					jQuery("#mobileSendInner").attr("disabled",true);
					jQuery("#mobileSendInner").attr("onclick",""); 
					$("#weaver").submit();
				}
		}
		
		
		function Savedata(){
				if(checkRequired()){
					//$("#mouldtext").attr("value",$("#mouldtext").val());
					$("#folderid").attr("value","-2");//设置为草稿状态
					$("#savedraft").attr("value","1");//只保存到草稿
					if(flag!="4"){
					 	//非草稿状态的邮件不要传递邮件id到后台
					 	$("#mailid").val("");
					}
					if(isShowEditor()){
						var editbody = $(KE.g["mouldtext"].edit.doc.body);
                        editbody.find(".EmailNew_fengeinput").remove();
				    	//K.sync("#mouldtext"); //同步内容
				    	var isIOS = editbody.find("#ke-content-div-mobil");
				    	if(isIOS.length > 0) {
					    	$("#mouldtext").val(isIOS.html());
				    	} else {
					    	$("#mouldtext").val(editbody.html());
				    	}
				    }
					$("#weaver").submit();
				}
		}	
			
		function checkRequired()
	 	{
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
			if(temp!=0){
				alert("<%=SystemEnv.getHtmlLabelName(30702,user.getLanguage()) %>"+"!");
				return false;
			}else{
				return true;
			}
	 	}
	 	function closeDialog(){
	 			$.close("selectionWindow");
	 			var internalto=$("#internalto").val();
	 			var internaltodpid=$("#internaltodpid").val();
	 			var internaltoall=$("#internaltoall").val();
	 			if(internalto==""&&internaltodpid==""&&internaltoall==""){
	 				$("#tospan").html("<img src='/images/BacoError_wev8.gif' align='absMiddle' >");
	 			}else{
	 				$("#tospan").html("");
	 			}
	 	}
	 	function getDialogId(){
	 	
				return "selectionWindow";


	 	}

		//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
		function doLeftButton() {
					if("<%=menuid%>"=="6"){
							
							window.location.href="/mobile/plugin/email/EmailMain.jsp?folderid=<%=folderid06%>&isInternal=<%=isInternal %>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
					}else{
						window.location.href="/mobile/plugin/email/EmailMain.jsp?folderid=<%=folderid%>&isInternal=<%=isInternal %>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
					}
					return "1";
		}
		
		//开启内部邮件
		<%if(mailType==2 && flag != 3){%>
		function doRightButton(){										 
			<%
				if(menuid.equals("6")){
			%>
					window.location.href="/mobile/plugin/email/EmailNew.jsp?folderid=<%=folderid06%>&isInternal=<%=isInternal%>&type=<%=type%>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
			<%
				}else{
			%>	
					window.location.href="/mobile/plugin/email/EmailNew.jsp?folderid=<%=folderid%>&isInternal=<%=isInternal%>&type=<%=type%>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
			<%	
				}
			%>
			return "1";
		}
		
		function getRightButton(){
				return "1,<%=SystemEnv.getHtmlLabelName(1995,user.getLanguage()) %>";
				///mobile/plugin/email/EmailNew.jsp?type=1"
		}
		<%}%>
		function getLeftButton(){
				return "1,<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>";
		}
		
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
	


</body>
</html>