
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.email.domain.MailFolder"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="fms" class="weaver.email.service.FolderManagerService" scope="page" />
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
		color: black;
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
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
			endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),
			to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		height: 40px;
		/*
			filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;
			*/
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
		background: url("/images/loading_bg_wev8.png");
		top: 50%;
		left: 50%;
		display: block;
		text-align: center;
		margin-top: -32px;
		margin-left: -125px;
		z-index: 1002;
	}
	
	#loadingmask {
		width: 100%;
		z-index: 1001;
		display: block;
	}
	
	/* 流程搜索区域 */
	.search {
		width: 100%;
		text-align: center;
		position: relative;
		background: #7F94AF;
		background: -moz-linear-gradient(0, #A4B0C0, #7F94AF);
		background: -webkit-gradient(linear, 0 0, 0 100%, from(#A4B0C0), to(#7F94AF) );
	}
	
	/* 流程搜索text */
	.searchText {
		width: 100%;
		height: 28px;
		margin-left: auto;
		margin-right: auto;
		border: 1px solid #687D97;
		background: #fff;
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
	/* 列表项*/
	.listitem {
		width: 100%;
		height: 50px;
		background: url(/images/bg_w_25_wev8.png);
		border-bottom: 1px solid #D8DDE4;
		cursor: pointer;
	}
	
	/* 子列表项*/
	.listitem-child {
		width: 100%;
		height: 50px;
		background: url(/images/bg_w_25_wev8.png);
		border-bottom: 1px solid #D8DDE4;
		cursor: pointer;
		display: none;
	}
	
	/* 自定义标签*/
	.listitem-label {
		width: 100%;
		height: 50px;
		background: url(/images/bg_w_25_wev8.png);
		border-bottom: 1px solid #D8DDE4;
		cursor: pointer;
		display: none;
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
	/*菜单项  */
	.itempreview {
		height: 100%;
		width: 50px;
		text-align: center;
	}
	
	/*子菜单项  */
	.itempreview-child{
		height: 100%;
		width: 80px;
		text-align: center;
	}
	
	/*自定义标签*/
	.itempreview-label{
		height: 100%;
		width: 80px;
		text-align: center;
	}
	
	/* 菜单项图标  */
	.itempreview img {
		width: 40px;
		height: 40px;
		margin-top: 4px;
	}
	
	/*子菜单项图标  */
	.itempreview-child  img {
		width: 40px;
		height: 40px;
		margin-top: 4px;
	}
	
		/*自定义标签  */
	.itempreview-label  img {
		width: 40px;
		height: 40px;
		margin-top: 4px;
	}
	
	/* 列表项内容区域 */
	.itemcontent {
		width: *;
		height: 100%;
		font-size: 16px;
		cursor: pointer;

	}
	
	/* 列表项内容名称 */
	.itemcontenttitle {
		width: 100%;
		height: 23px;
		overflow-y: hidden;
		line-height: 23px;
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
	/* 更多 */
	.listitemmore {
		height: 50px;
		text-align: center;
		line-height: 50px;
		font-weight: bold;
		color: #777878;
		background:url(/images/bg_w_75_wev8.png);
		cursor: pointer;
		background-color: #ececec;
		
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
		width: 50px;
	}
	</style>
</head>
<body>
<%
		String clienttype = Util.null2String((String)request.getParameter("clienttype"));
		String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
		String module=Util.null2String((String)request.getParameter("module"));
		String scope=Util.null2String((String)request.getParameter("scope"));
		
		String userid=""+user.getUID();
		Map mailConfig=MailConfigService.getMailConfig();
		int mailType=Util.getIntValue(Util.null2String(mailConfig.get("mailType")),0);
		
		int defaultMailType=MailConfigService.getDefaultMailType(userid);
		String mailUrl="/mobile/plugin/email/EmailNew.jsp?";
		if(defaultMailType==1)
			mailUrl="/mobile/plugin/email/EmailNewIn.jsp?";
		mailUrl+="type=1&module="+module+"&scope="+scope;
 %>
<table id="page"  style="width: 100%;height: 100%;"  cellpadding="0" cellspacing="0">
	<tr>
	<td width="100%" height="100%" valign="top" align="left">
				<div id="header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
				<table style="width: 100%; height: 40px;">
					<tr>
						<td width="10%" align="left" valign="middle" style="padding-left:5px;">
										<a href="/home.do">
											<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
												<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>
											</div>
										</a>
						</td>
						<td align="center" valign="middle">
							<div id="title"><%=SystemEnv.getHtmlLabelName(20869,user.getLanguage()) %></div>
						</td>
						<td width="10%" align="right" valign="middle" style="padding-right:5px;">
							
							<a href="<%=mailUrl%>">
								<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px;">
									<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>
								</div>
							</a>
						
						</td>
					</tr>
				</table>
			</div>
		
	     <%
	     
	     		
	     		List list=new ArrayList();
	     		list.add(SystemEnv.getHtmlLabelName(19816,user.getLanguage()));
	     		list.add(SystemEnv.getHtmlLabelName(19558,user.getLanguage()));
	     		list.add(SystemEnv.getHtmlLabelName(2039,user.getLanguage()));
	     		list.add(SystemEnv.getHtmlLabelName(2040,user.getLanguage()));
				
				//0--收件箱，1--发件箱，2--草稿箱，3--已删除，4内部邮件，5标星邮件，6我的文件夹
				String menuid="";
				

	     		for(int i=0;i<list.size();i++){
	      %>
			  	<div class='listitem' >
				  					<a href='javascript:void(0)' style="width: 100%;height: 100%"  onclick="window.location.href='/mobile/plugin/email/EmailMain.jsp?folderid=<%=(i*-1)%>&menuid=<%=i%>&module=<%=module%>&scope=<%=scope%>'">
									    	<table    style="width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;">
										    	<tr>
											    	<td class='itempreview'>
											    		<%if(i==0){ %>
											    					<img src='/mobile/plugin/images/f_wev8.png'>
											    		<%   }else if(i==1){%>  
											    					<img src='/mobile/plugin/images/s_wev8.png'>
											    		<%	}else if(i==2){%>
											    					<img src='/mobile/plugin/images/c_wev8.png'>
											    		<%	}else if(i==3){%>
											    					<img src='/mobile/plugin/images/delete_wev8.png'>
											    		<%	}	 %>
											    	</td>
											    	<td class='itemcontent'   >
													    	<%=list.get(i)%>
											    	</td>
											    	<td class='itemnavpoint'>
											    			<img src='/images/icon-right.png'>
											    	</td>
										    	</tr>
								    	</table>
						   			</a>
			    </div> 
		<%
				}
		 %>
		
			<%if(mailType!=0){%>
			<div class='listitem' >
				  					<a href='javascript:void(0)' style="width: 100%;height: 100%"  onclick="window.location.href='/mobile/plugin/email/EmailMain.jsp?isInternal=1&menuid=4&module=<%=module%>&scope=<%=scope%>'">
									    	<table    style="width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;">
										    	<tr>
											    	<td class='itempreview'>
											    		<!-- 内部邮件 -->
											    		<img src='/mobile/plugin/images/inside_wev8.png'>
											    	</td>
											    	<td class='itemcontent'   >
													    	<%=SystemEnv.getHtmlLabelName(24714,user.getLanguage()) %>
											    	</td>
											    	<td class='itemnavpoint'>
											    			<img src='/images/icon-right.png'>
											    	</td>
										    	</tr>
								    	</table>
						   			</a>
			    </div> 
			    <%}%>
			    
			    	<div class='listitem' >
				  					<a href='javascript:void(0)' style="width: 100%;height: 100%"  onclick="window.location.href='/mobile/plugin/email/EmailMain.jsp?star=1&menuid=5&module=<%=module%>&scope=<%=scope%>'">
									    	<table    style="width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;">
										    	<tr>
											    	<td class='itempreview'>
											    		<!-- 表星邮件 -->
											    		<img src='/mobile/plugin/images/star_wev8.png'>
											    	</td>
											    	<td class='itemcontent'   >
													    	<%=SystemEnv.getHtmlLabelName(81337,user.getLanguage()) %>
											    	</td>
											    	<td class='itemnavpoint'>
											    			<img src='/images/icon-right.png'>
											    	</td>
										    	</tr>
								    	</table>
						   			</a>
			    </div> 
		
		
		<div class='listitem' >
	  						<a href='javascript:void(0)' style="width: 100%;height: 100%"  onclick="showFolder(this,1)" _value=0>
					    	<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
						    	<tr>
							    	<td class='itempreview'>
							    		<img src='/mobile/plugin/images/folder_wev8.png'>
							    	</td>
							    	<td class='itemcontent'   >
									    	<%=SystemEnv.getHtmlLabelName(81348,user.getLanguage()) %>
							    	</td>
							    	<td class='itemnavpoint'>
							    			<img src='/images/icon-right.png'>
							    	</td>
						    	</tr>
				    	</table>
				    </a>
	  </div> 			  			
		<%
				ArrayList<MailFolder> folderList= fms.getFolderManagerList(user.getUID());
				for(int i=0;i<folderList.size();i++){
					MailFolder mf = folderList.get(i);
		%>
					<div class='listitem-child' >		
						<a href='javascript:void(0)' style="width: 100%;height: 100%"  onclick="window.location.href='/mobile/plugin/email/EmailMain.jsp?folderid=<%=mf.getId()%>&menuid=6&module=<%=module%>&scope=<%=scope%>'">
								<table    style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>
								    	<tr>
									    	<td class='itempreview-child'>
									    		<!-- 子文件夹 -->
									    		<img src='/mobile/plugin/images/sonfolder_wev8.png'>
									    	</td>
									    	<td class='itemcontent' >
											    	<%=mf.getFolderName()%>
									    	</td>
									    	<td class='itemnavpoint'>
									    			<img src='/images/icon-right.png'>
									    	</td>
								    	</tr>
						    	</table>
						</a>
					 </div> 
		<%		
				}
		
		 %>
		
		
	
	</td>
	</tr>
</table>
<script type="text/javascript">
				var module="<%=module%>";
				var scope="<%=scope%>";
				function showFolder(obj,type){
					if(type=="1"){
						if($(obj).attr("_value")=="0"){
							$(".listitem-child").show();
							$(obj).attr("_value","1");
							$(obj).find(".itemnavpoint").html("");
						}else{
							$(".listitem-child").hide();
							$(obj).attr("_value","0");
							$(obj).find(".itemnavpoint").html("<img src='/images/icon-right.png'>");
						}
					}else{
						if($(obj).attr("_value")=="0"){
							$(".listitem-label").show();
							$(obj).attr("_value","1");
							$(obj).find(".itemnavpoint").html("");
						}else{
							$(".listitem-label").hide();
							$(obj).attr("_value","0");
							$(obj).find(".itemnavpoint").html("<img src='/images/icon-right.png'>");
						}
					
					}	
				}
				
				function getRightButton(){
						return "1,<%=SystemEnv.getHtmlLabelName(82,user.getLanguage()) %>";
						///mobile/plugin/email/EmailNew.jsp?type=1"
				}
				
				function getLeftButton(){
						return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
				}
				
				
				//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
				function doRightButton(){
					window.location.href="<%=mailUrl%>";
					return "1";
				}
				//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
				function doLeftButton() {
									return "BACK";
				}
</script>	
</body>
</html>