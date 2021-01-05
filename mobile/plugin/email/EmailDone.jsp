
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.email.domain.*" %>
<%@ page import="weaver.docs.category.security.AclManager" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" scope="page" />
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" scope="page" />
<jsp:useBean id="mas" class="weaver.email.service.MailAccountService" scope="page" />
<jsp:useBean id="mfs" class="weaver.email.service.MailFolderService" scope="page" />
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
<jsp:useBean id="mms" class="weaver.email.service.MailManagerService" scope="page" />
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
	<script type='text/javascript' src='/js/jquery/jquery-ui_wev8.js'></script>
	<script  language="javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/css/cupertino/jquery-ui_wev8.css" type="text/css">

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
	box-shadow: inset 0px 1px 0px 0px #BCBFC3;
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
		height: 80px;
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
	
		.topmenu{
				padding-top:30px;
				padding-bottom:30px;
				height:30px;
				background-image:url("/email/images/envelope_wev8.png")
		}
		.centermenu{
				padding-top:10px;
				height:30px;
		}
		.inclass{
			height:16px;
			width:18px;
			background:url("/email/images/sent_wev8.png")  no-repeat 0px 3px;
			margin-right:5px;
		}
		.inclass2{
			height:16px;
			width:18px;
			background:url("/email/images/sent_wev8.png")  no-repeat -32px 3px;
			margin-right:5px;
		}
		.inclass3{
			height:16px;
			width:18px;
			background:url("/email/images/sent_wev8.png")  no-repeat -64px 3px;
			margin-right:5px;
		}
		.inclass4{
			height:50px;
			width:180px;
			padding:0px;
			background:url("/email/images/sent_wev8.png")  no-repeat -416px 3px;
			margin-right:5px;
			text-align: center;
		}
		.inclass5{
			height:100%;
			width:180px;
			padding-left:0px;
			background:url("/email/images/sent_wev8.png")  no-repeat -416px  -50px;
			margin-right:5px;
	
		}
		.tdclickcss{
				cursor: pointer;
				text-align:center;
		}
	</style>
</head>
<body>


<%

String isSent=Util.null2String(request.getParameter("isSent"));
String folderid=Util.null2String(request.getParameter("folderid"));
String isInternal=Util.null2String(request.getParameter("isInternal"));
String type=Util.null2String(request.getParameter("type"));
//0--收件箱，1--发件箱，2--草稿箱，3--已删除，4内部邮件，5标星邮件，6我的文件夹
String menuid=Util.null2String(request.getParameter("menuid"));
String module=Util.null2String((String)request.getParameter("module"));
String scope=Util.null2String((String)request.getParameter("scope"));
%>


<table id="page"  style="width: 100%;height: 100%;"  cellpadding="0" cellspacing="0">
	<tr>
	<td width="100%" height="100%" valign="top" align="left">
	
			
			
			<div class='listitem'  >
			    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
					    	<tr>
							    	<td class='itempreview'>
							    	</td>
							    	<td class='itemcontent' >
									    	<div class='itemcontenttitle'>
											    	<table style='width:100%;height:40px;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
													    	<colgroup>
												   				<col width="80px">
												   				<col width="*">
												   				<col width="20">
												   			</colgroup>
													    	<tr>
													    	<td>
													    	</td>
							    							<td  class="tdclickcss" _id=1>
																			<span class=inclass>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
																			 <%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(19816,user.getLanguage()) %>&nbsp;&nbsp;&nbsp;
															</td>
									    					<td>
									    						
									    					</td>
													    	</tr>
											    	</table>
									    	</div>
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
									    	<div class='itemcontenttitle'>
											    	<table style='width:100%;height:40px;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
													    	<colgroup>
												   				<col width="80px">
												   				<col width="*">
												   				<col width="20">
												   			</colgroup>
													    	<tr>
													    	<td>
													    	</td>
							    							<td class="tdclickcss" _id=2>
																			 <span class=inclass2>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
																			  <%=SystemEnv.getHtmlLabelName(81405,user.getLanguage()) %>
															</td>
									    					<td>
									    						
									    					</td>
													    	</tr>
											    	</table>
									    	</div>
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
									    	<div class='itemcontenttitle'>
											    	<table style='width:100%;height:40px;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
													    	<colgroup>
												   				<col width="80px">
												   				<col width="*">
												   				<col width="20">
												   			</colgroup>
													    	<tr>
													    	<td>
													    	</td>
							    							<td class="tdclickcss" _id=3>
																			  <span class=inclass3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
																			  <%=SystemEnv.getHtmlLabelName(81406,user.getLanguage()) %>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
															</td>
									    					<td>
									    						
									    					</td>
													    	</tr>
											    	</table>
									    	</div>
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
									    	
											    	<table style='width:100%;height:60px;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
													    	<colgroup>
												   				<col width="*">
												   				<col width="100px">
												   				<col width="*">
												   			</colgroup>
													    	<tr>
													    	<td>
													    				
													    	</td>
							    							<td class="tdclickcss"  style="text-align: center;">
							    												<span></span>
																				<%
																		
																						if("true".equals(isSent)){
																					%>
																							<div class=inclass4  >
																								<font style='font-size:18px;color:green;'>
																					<%
																							out.println(SystemEnv.getHtmlLabelName(27564,user.getLanguage()));
																						}else if("draftSaved".equals(isSent)){
																					%>
																								<div class=inclass4>
																									<font style='font-size:18px;color:green;'>
																					<%
																							out.println(SystemEnv.getHtmlLabelName(81407,user.getLanguage())+"<br>"+SystemEnv.getHtmlLabelName(25008,user.getLanguage()));
																						}else{
																					%>
																								<div class=inclass5 >
																									<font style='font-size:18px;color:green;'>
																					<%
																							out.println(SystemEnv.getHtmlLabelName(22397,user.getLanguage()));
																						}
																					 %>
																									</font>
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
			
				
		</td>
</tr>	
</table>

<script type="text/javascript">
			jQuery(document).ready(function(){
						$(".tdclickcss").click(function(){
								var tempid=$(this).attr("_id");		
								var url="";
								if(tempid==1){
									url="/mobile/plugin/email/EmailMain.jsp?menuid=0&module=<%=module%>&scope=<%=scope%>";
								}else if(tempid==2){
									//已发送
									url="/mobile/plugin/email/EmailMain.jsp?menuid=1&folderid=-1&module=<%=module%>&scope=<%=scope%>";
								}else if(tempid==3){
									//继续写信
									if("<%=isInternal%>"=="1"){
											if("<%=menuid%>"=="4"){
												url="/mobile/plugin/email/EmailNewIn.jsp?folderid=<%=folderid%>&isInternal=<%=isInternal%>&type=<%=type%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
											}else{
												url="/mobile/plugin/email/EmailNewIn.jsp?folderid=<%=folderid%>&isInternal=&type=<%=type%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";	
											}
									}else{
											url="/mobile/plugin/email/EmailNew.jsp?folderid=<%=folderid%>&isInternal=<%=isInternal%>&type=<%=type%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
									}
								}
								else{
									return;
								}
								window.location.href=url;
						});
			});
</script>
	


</body>
</html>