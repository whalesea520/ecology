
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="java.io.File"%>
<%@page import="weaver.email.WeavermailComInfo"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="weaver.email.service.MailManagerService"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="mrs" class="weaver.email.service.MailResourceService" />
<jsp:useBean id="mrs02" class="weaver.email.service.MailResourceService" />
<jsp:useBean id="mss" class="weaver.email.service.MailSettingService" />
<jsp:useBean id="mrfs" class="weaver.email.service.MailResourceFileService" />
<jsp:useBean id="SptmForMail" class="weaver.splitepage.transform.SptmForMail" />
<jsp:useBean id="rs0" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MailConfigService" class="weaver.email.service.MailConfigService" scope="page" />
<%@page import="weaver.email.domain.MailSearchDomain"%>
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
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
			endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),
			to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		height: 40px  ！import;
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
		height: 80px;
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
		font-size: 12px;
		color: #777878;
		word-break: break-all;
	}
	
	/* 列表项内容简介 */
	.itemcontentitdtHH {
		width: 100%;
		height: 100%;
		line-height: 23px;
		font-size: 12px;
		color: #777878;
		text-overflow: ellipsis;
		white-space: normal;
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

.operationCenter{
		height: 26px;
		margin-left:auto;
		margin-right:auto;
		width:60px;
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
.isDeleted {
    padding-top: 15%;
    text-align: center;
    font-size: 20px;
    color: #FF0033;
}
	</style>
</head>

 
<%
	String userid=""+user.getUID();
    ResourceComInfo resourceComInfo=new ResourceComInfo();
	int mailid = Util.getIntValue(request.getParameter("mailid"));
	String  folderid = Util.null2String(request.getParameter("folderid"));
	//star = '1'表示标星邮件
	String star = Util.null2String(request.getParameter("star"));
	String status = Util.null2String(request.getParameter("status"));
	//0--收件箱，1--发件箱，2--草稿箱，3--已删除，4内部邮件，5标星邮件，6我的文件夹
	String menuid=Util.null2String(request.getParameter("menuid"),"0");
	//布局信息
	mss.selectMailSetting(user.getUID());
	int layout = Util.getIntValue(mss.getLayout(),3);
	// 获取文件夹下最新邮件ID
	if(mailid<0){
		mailid = mrs.getFolderLastMailId(folderid+"",user.getUID(),new MailSearchDomain());
	}
	// 读取邮件，并加载到缓存中
	mrs.setId(mailid+"");
	mrs.selectMailResource();
	if(mrs.next()){
		int resourceid = Util.getIntValue(mrs.getResourceid());
		String resourceids=","+MailManagerService.getAllResourceids(userid)+",";
		if(!resourceids.contains(","+resourceid+",")){ //判断是否有权限查看邮件
			response.sendRedirect("/notice/noright.jsp");
			return;
		}else{
		}
	}
    
	// 标记邮件为已读
	mrs.updateMailResourceStatus("1",mailid+"",user.getUID());
	//更新内部邮件: 邮件读取时间
	mrs.updateMailResourceReaddate(String.valueOf(mailid));
	
	//删除邮件提醒信息
	mrs.removeMailRemindInfo(mailid,user.getUID());
	
	//EML
	String _emlPath = Util.null2String(mrs.getEmlpath());
	String emlName = Util.null2String(mrs.getEmlname());
	String subject=Util.null2String(mrs.getSubject());
	String from = Util.null2String(mrs.getSendfrom());
	String IsInterna =Util.null2String(mrs.getIsInternal()+"");
	if("1".equals(IsInterna)){
		 
			from=resourceComInfo.getResourcename(from);
	}
	String toids=mrs.getToids()+"";          //接收人ids
    String ccids=mrs.getCcids()+"";          //抄送人ids
    String bccids =mrs.getBccids()+"";      //密送人ids
    
    
	String sendDate=Util.null2String(mrs.getSenddate());
	String emlPath = GCONST.getRootPath() + "email" + File.separatorChar + "eml" + File.separatorChar;
	File eml = new File(emlPath + emlName + ".eml");
	if(!_emlPath.equals("")) eml = new File(_emlPath);
	String module=Util.null2String((String)request.getParameter("module"));
	String scope=Util.null2String((String)request.getParameter("scope"));
	String mailContent= mrs.getContent();
	if(mrs.getHashtmlimage().equals("1")){
		mrfs.selectMailResourceFileInfos(mailid+"","0");
		while(mrfs.next()){
			int imgId = mrfs.getId();
			String thecontentid = mrfs.getFilecontentid();
			//80/weaver/weaver.email.FileDownloadLocation?fileid=768&amp;download=1
			////module=2&scope=282
			String oldsrc = "cid:" + thecontentid ;
			String newsrc = "/download.do?fileid="+imgId+"&module="+module+"&scope="+scope+"&form_email=1";
			mailContent = Util.StringReplaceOnce(mailContent , oldsrc , newsrc ) ;
		}
	}
	mailContent = Util.replace(mailContent, "==br==", "\n", 0);
	mailContent=mailContent.replaceAll("/weaver/weaver.email.FileDownloadLocation[?]","/download.do?form_email=1&");  
	
	int xuhao=0;
	int mobile_email_count=0;
	int mailid_Prev=-1;
	int mailid_Next=-1;
	
	List listWhereSession= new ArrayList();
	Object obj=session.getAttribute("listWhereSession");
	if(null!=obj){
			listWhereSession=(List)obj;
			//设置参数过滤数据
			mrs02.setResourceid(listWhereSession.get(0)+"");
			mrs02.setFolderid(listWhereSession.get(1)+"");
			mrs02.setLabelid(listWhereSession.get(2)+"");
			mrs02.setStarred(listWhereSession.get(3)+"");
			mrs02.setSubject(listWhereSession.get(4)+"");
			mrs02.setSendfrom(listWhereSession.get(5)+"");
			mrs02.setSendto(listWhereSession.get(6)+"");
			mrs02.setStatus(listWhereSession.get(7)+"");
			mrs02.setAttachmentnumber(listWhereSession.get(8)+"");
			mrs02.setMailaccountid(listWhereSession.get(9)+"");
			mrs02.setIsInternal(Util.getIntValue(listWhereSession.get(10)+""));

			//查询邮件列表所有的数据的id集合-zzl
			List listids=mrs02.selectMailIDList();
			mobile_email_count=mrs02.getRecordCount();
			if(null!=listids){
					for(int i=0;i<listids.size();i++){
							xuhao++;
							if((listids.get(i)+"").equals(mailid+"")){
									if(i>=1){
										mailid_Prev=Util.getIntValue(listids.get(i-1)+"",-1);//上一封邮件
									}
									if(i<(listids.size()-1)){
										mailid_Next=Util.getIntValue(listids.get(i+1)+"",-1);//下一封邮件
									}
									break;
							}
					}
			}
	}
	String clienttype = Util.null2String((String)request.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));

	//标记是从微搜模块进入start
	String fromES=Util.null2String((String)request.getParameter("fromES"));
	//标记是从微搜模块进入end
	
	WeavermailComInfo wmc = new WeavermailComInfo();
		
	wmc.setPriority(mrs.getPrioority()) ;
	wmc.setRealeSendfrom(mrs.getSendfrom()) ;
	wmc.setRealeCC(mrs.getSendcc()) ;
	wmc.setRealeTO(mrs.getSendto()) ;
	wmc.setRealeBCC(mrs.getSendbcc()) ;
	wmc.setSendDate(mrs.getSenddate()) ;
	wmc.setSubject(mrs.getSubject()) ;
	wmc.setContent(mrs.getContent());
	wmc.setBccids(mrs.getBccids());
	wmc.setBccall(mrs.getBccall());
	wmc.setBccdpids(mrs.getBccdpids());
	wmc.setCcids(mrs.getCcids());
	wmc.setCcall(mrs.getCcall());
	wmc.setCcdpids(mrs.getCcdpids());
	wmc.setTodpids(mrs.getTodpids());
	wmc.setToids(mrs.getToids());
	wmc.setToall(mrs.getToall());
	
	//System.out.println("mrs.getToids()============="+mrs.getToids());
	
	wmc.setContenttype(mrs.getMailtype());
	if(("1").equals(mrs.getHashtmlimage())){
	    wmc.setHtmlimage(true);
	}else{
	    wmc.setHtmlimage(false);
	}
	
	session.setAttribute("mobilewmc", wmc);
    
	RecordSet countRs = new RecordSet();
    countRs.executeQuery("select id from mailresource where id = " + mailid);
    int mailExist = countRs.getCounts();
    
	//mrs.selectMailResourceOnlyCount(); //查询总数  此语句运行后会影响其他mrs内容
	
	Map mailConfig=MailConfigService.getMailConfig();
	int mailType=Util.getIntValue(Util.null2String(mailConfig.get("mailType")),0);
%>
<body style="margin: 0px;padding: 0px"> 

<%
    if(mailExist == 0) {
%>
    <div class="isDeleted"><%=SystemEnv.getHtmlLabelName(127870, user.getLanguage()) %></div>
<%
    } else {
%>
<table id="page"  style="width: 100%;height: 100%;margin: 0px;padding: 0px"  cellpadding="0" cellspacing="0">
	<tr>
	<td width="100%" height="100%" valign="top" align="left">
	
						  <div id="view_page"> 
						<div id="header"  style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
											    <table style="width: 100%; height: 40px;"> 
											     <tbody>
											      <tr> 
											       <td width="25%" align="left" valign="middle" style="padding-left:5px;"> 
														<a href="javascript:void(0)" onclick="doLeftButton()"> 
													         <div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;font-size: 14px">
													            <%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %> 
													         </div> 
												         </a>
											        </td> 
											       <td width="*"  align="center" valign="middle"> 
													        
											       </td> 
											       <td  width="25%"  align="right" valign="middle" style="padding-right:5px"> 
											       			
											       	</td>			 
											      </tr> 
											     </tbody>
											    </table> 
						   </div> 
						   </div> 
						    <div id="title"></div> 
						    
						    <!--发件人start -->
						    <div>
						    	<table style="width: 100%; table-layout: fixed;" >
						    			<tr>
						    					<td width="70px" style="padding-left: 5px;font-size: 14px">
						    							<%=SystemEnv.getHtmlLabelName(2034,user.getLanguage()) %> ：
						    					</td>
						    						
						    					<td class="itemcontent"  align="left">
						    						  <div class="itemcontentitdt">
						    								<%=from%>
						    						   </div> 
						    					</td>
						    					
						    					<td width="60px">
						    							 <a> 
															     <div class="itemcontentitdt" style="color: blue;">
															     
															     </div> 
						 								   </a> 
						    					</td>
						    			</tr>
						    	</table>
						      
						    </div> 
						    <!-- 发件人--end -->
						    
						    
						     <!--收件人start -->
						    <div>
						    	<table style="width: 100%;">
						    			<tr>
						    					<td width="70px" style="padding-left: 5px;font-size: 14px" valign="top">
						    							<%=SystemEnv.getHtmlLabelName(2046,user.getLanguage()) %> ：
						    					</td>
						    						
						    					<td class="itemcontent"  align="left">
						    						  <div class="itemcontentitdt">
						    								<%
							    								if(mrs.getIsInternal()==1){
							    								    out.println(SptmForMail.getHrmShowNameHrefTOP(mrs,5,1,true));
																}else{
																	out.print(SptmForMail.getNameByEmailTOP(mrs.getSendto(),userid,""));
																}
				    										%>
						    						   </div>
						    						   <div class="itemcontentitdt" style="display: none;">
						    						   		
						    						   </div> 
						    					</td>
						    					
						    					<td width="60px">
						    							 <a> 
															     <div class="itemcontentitdt" style="color: blue;">
															     
															     </div> 
						 								   </a> 
						    					</td>
						    			</tr>
						    	</table>
						      
						    </div> 
						    <!--收件人end -->

    								
						<%
									 boolean ccflag=false;
									 if(mrs.getIsInternal()==1){
										if("1".equals(mrs.getCcall())){
											ccflag=true;
										}else if(!"".equals(mrs.getCcdpids())){
											ccflag=true;
										}else if(!"".equals(mrs.getCcids())){
											ccflag=true;
										}		
									 }
									if(!mrs.getSendcc().trim().equals("")||ccflag){
								%>
						    <!-- 抄送人start -->
						     <div>
						    	<table style="width: 100%;" >
						    			<tr>
						    					<td width="70px" style="padding-left: 5px;font-size: 14px" valign="top">
						    							<%=SystemEnv.getHtmlLabelName(17051,user.getLanguage()) %> ：
						    					</td>
						    						
						    					<td class="itemcontent"  align="left">
						    						  <div class="itemcontentitdt">
						    							<%
																	if(mrs.getIsInternal()==1){
																			out.print(SptmForMail.getHrmShowNameHrefTOP(mrs,3,2,true));
																	}else{
																		out.print(SptmForMail.getNameByEmailTOP(mrs.getSendcc(),userid,""));
																	}
														%>
						    						   </div> 
						    						   <div class="itemcontentitdt" style="display: none;">
						    						   		
						    						   </div>
						    					</td>
						    					
						    					<td width="60px">
						    							 <a> 
															     <div class="itemcontentitdt" style="color: blue;">
															     
															     </div> 
						 								   </a> 
						    					</td>
						    			</tr>
						    	</table>
						      
						    </div> 
						     <!-- 抄送人end -->
						     <%
						     	}
						      %>
						     
						     
						  <%
								 boolean bccflag=false;
								 if(mrs.getIsInternal()==1){
									if("1".equals(mrs.getBccall())){
										bccflag=true;
									}else if(!"".equals(mrs.getBccdpids())){
										bccflag=true;
									}else if(!"".equals(mrs.getBccids())){
										bccflag=true;
									}		
								 }
								//密送人的判断
								//如果当前用户=改邮件的发送用户，就显示"密送人"
								boolean readBcc=false;
								//当前登陆者是否是邮件发送者
								boolean isSender = false;
								if((!mrs.getSendbcc().trim().equals("")&&mrs.getIsInternal()==1)||bccflag){
									//内部邮件------------------------------密送人处理-----------------------------------
									if(mrs.getSendfrom().equals(""+user.getUID())){
											isSender=true;
											readBcc=true;
									}
									String send_bcc=","+mrs.getSendbcc()+",";
									if(send_bcc.indexOf(","+user.getUID()+",")!=-1){
										readBcc=true;
									}else if("1".equals(mrs.getBccall())){
										//密送给所有人
										readBcc=true;
									}else if(!"".equals(mrs.getBccids())&&(","+mrs.getBccids()+",").indexOf(","+user.getUID()+",")!=-1){
										//密送给某些人,并且包含当前用户
										readBcc=true;
									}else if(!"".equals(mrs.getBccdpids())){
										//密送给某个部门,并且包含当前用户
										rs0.execute("select id from HrmResource where departmentid in("+mrs.getBccdpids()+") and id='"+user.getUID()+"'");
										if(rs0.next()){
											readBcc=true;
										}
									}	
									if(readBcc){
					%>
						       <!-- 密送人start -->
						     <div>
						    	<table style="width: 100%;" >
						    			<tr>
						    					<td width="70px" style="padding-left: 5px;font-size: 14px;<%=!isSender?"color: red":""%>" valign="top">
						    							<%=SystemEnv.getHtmlLabelName(81316,user.getLanguage()) %> ：
						    					</td>
						    						
						    					<td class="itemcontent"  align="left">
						    						  <div class="itemcontentitdt">
						    									<%
						    									if(isSender) {
						    										if(mrs.getIsInternal()==1){
																		out.print(SptmForMail.getHrmShowNameHrefTOP(mrs,3,3,true));
																	}else{
																		out.print(SptmForMail.getNameByEmailTOP(mrs.getSendbcc(),userid,""));
																	}
						    									}else {
						    										out.print("<div style='color: red'>"+SystemEnv.getHtmlLabelName(81749, user.getLanguage())+"</div>");
						    									}	
				    										%>
						    						   </div> 
						    						   <div class="itemcontentitdt" style="display: none;">
						    						   		
						    						   </div>
						    					</td>
						    					
						    					<td width="60px">
						    							 <a> 
															     <div class="itemcontentitdt" style="color: blue;">
															     
															     </div> 
						 								   </a> 
						    					</td>
						    			</tr>
						    	</table>
						      
						    </div> 
						     <!-- 密送人end -->
						    <%
						    	}
						    	}
						     %>
						   <div class='blankLines'></div>
						   <div>
						    	<table style="width: 100%; table-layout: fixed;" >
						    			<tr>
						    					<td width="100%" style="padding-left: 5px;height: 40px;font-size: 14px">
						    									<h5><%=Util.getMoreStr(subject,25,"...")%></h5>
						    					</td>
						    				
						    			</tr>
						    				<tr>
						    					<td width="100%" style="padding-left: 5px">
						    										 <div class="itemcontentitdt">
						    										<%=sendDate %>
						    										</div>
						    					</td>
						    			</tr>
						    	</table>
						    </div> 
						   <div class='blankLines'></div>
						   
						   
						   
						   <div>
						    	<table style="width: 100%; table-layout: fixed;" >
						    			<tr>
						    					<td style="padding-left: 5px">
						    					 <div >
						    									<%=mailContent%>
						    					</div>
						    					</td>
						    			</tr>
						    	</table>
						    </div> 
						   <div>
						    	<table style="width: 100%; table-layout: fixed;" >
						    			<tr>
						    					<td style="padding-left: 5px">
						    								<div >
						    									<%
						    									
						    											  	mrfs.selectMailResourceFileInfos(mailid+"","1");
																			ArrayList filenames = new ArrayList() ;
																			ArrayList filenums  = new ArrayList() ;
																			ArrayList filenameencodes  = new ArrayList() ;
																			int fileNum=0;																			
						    												if(mrfs.getCount()>0){ %>
																		
																			<div><%=SystemEnv.getHtmlLabelName(156, user.getLanguage())%>:</div>
																				<%
																					while(mrfs.next()){ 
																						int fileId = mrfs.getId();
																						filenames.add(mrfs.getFilename()) ;
																						filenums.add(fileId+"") ;
																						filenameencodes.add("1") ;
																						fileNum++ ; 
																						//module=-2&scope=330&detailid=
																						String fileUrl ="/download.do?fileid="+fileId+"&module="+module+"&scope="+scope+"&form_email=1&filename="+URLEncoder.encode(mrfs.getFilename(),"UTF-8");
																						%>
																					<a href="<%=fileUrl%>&download=1" style="text-decoration:underline"><%=Util.toScreen(mrfs.getFilename(), user.getLanguage())%></a>&nbsp;
																					<%}%>
																			<%} %>
						    									 		
						    							</div>
						    					</td>
						    			</tr>
						    	</table>
						    </div> 
						 
   
 	</td>
 </tr>
 <tr>
 <td  style="background-color: #ececec;">
 				
					<table style="width: 100%; height: 60px;">
						<tr>
							<%
								if("0".equals(menuid)){//收件箱
							%>
									<td class='itempreview'   style="text-align: center;">	
											<div class="operationBt " onclick="replayBtn(<%=mailid%>)" >
									       		 <%=SystemEnv.getHtmlLabelName(117,user.getLanguage()) %>
									       </div>
									</td>
									<td class='itempreview' style="text-align: center;">
											<div class="operationCenter "  onclick="replayAllBtn(<%=mailid%>)" >
									       		 <%=SystemEnv.getHtmlLabelName(2053,user.getLanguage()) %>
									       </div>
									</td>
									<td class='itempreview' style="text-align: center;">
											<div class="operationBtright "  onclick="forwardBtn(<%=mailid%>)" >
									       		 <%=SystemEnv.getHtmlLabelName(6011,user.getLanguage()) %>
									       </div>
									       
									</td>
									<td  class='itempreview'>
													
									</td>	
									<td  class='itempreview'>
											
									</td>				
							<%	
								}else if("1".equals(menuid)){//已发邮件
							%>
									<td class='itempreview'   style="text-align: center;">
											
									</td>
									<td class='itempreview'   style="text-align: center;">
													
									</td>
									<td class='itempreview' style="text-align: center;">
										    <div class="operationCenter " onclick="forwardBtn(<%=mailid%>)" >
									       		 <%=SystemEnv.getHtmlLabelName(6011,user.getLanguage()) %>
									       </div>
									</td>
									<td class='itempreview'   style="text-align: center;">
											
									</td>
									<td class='itempreview' style="text-align: center;">
												
									</td>
							<% 
								}else if( "2".equals(menuid)){//草稿箱
							%>
									<td class='itempreview'   style="text-align: center;">
										
									</td>
									<td class='itempreview'   style="text-align: center;">
											
									</td>
									<td class='itempreview' style="text-align: center;">
													
									</td>
									<td class='itempreview'   style="text-align: center;">
									
									</td>
									<td  class='itempreview'>
										
									</td>
							<%
								}else{//已删除或文件夹里面的邮件
							 %>
									<td class='itempreview'   style="text-align: center;">
												
									</td>
									<td class='itempreview'   style="text-align: center;">
											
									</td>
									<td class='itempreview' style="text-align: center;">
													 <div class="operationCenter " onclick="forwardBtn(<%=mailid%>)" >
											       		 <%=SystemEnv.getHtmlLabelName(6011,user.getLanguage()) %>
											       </div>
									</td>
									<td class='itempreview' style="text-align: center;">
									</td>
									<td  class='itempreview'>
											
									</td>						
							<%
								}
							 %>
						</tr>
					</table>
				
 	</td>
 </tr>
 </table>
 <input id="forwordinnerurl" type="hidden"/>
<script type="text/javascript">
		var IsInterna="<%=IsInterna%>";
		var mailid="<%=mailid%>"
		//移动邮件到指定文件夹
		function moveMailToFolder(mailIds){
			if(mailIds!=""){
				var param = {"mailId": mailIds,movetoFolder:"-3", "operation": "move"};
				$.post("/mobile/plugin/email/EmailViewOperation.jsp", param, function(){
					window.location.href="/mobile/plugin/email/EmailView.jsp?mailid=<%=mailid_Next%>&folderid=<%=folderid%>&status=<%=status%>&star=<%=star%>&module=<%=module%>&scope=<%=scope%>";
				});
			}
		}
		
		//彻底删除选中邮件
		function deleteCheckedMail(mailIds){
			if(mailIds!=""){
				var param = {"mailId": mailIds, "operation": "delete"};
				$.post("/mobile/plugin/email/EmailViewOperation.jsp", param, function(){
					window.location.href="/mobile/plugin/email/EmailView.jsp?mailid=<%=mailid_Next%>&folderid=<%=folderid%>&status=<%=status%>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
				});
			}
		}
		//回复
		function replayBtn(mailIds){
				var page="EmailNew.jsp";
				if(IsInterna=="1"){
						page="EmailNewIn.jsp";
				}	
				var url="/mobile/plugin/email/"+page+"?flag=1&id=<%=mailid%>&folderid=<%=folderid%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
				window.location.href=url;
		}
		//转发
		function forwardBtn(mailIds){
					
					<%if(mailType==2){%>	
					var innerurl="?flag=3&id=<%=mailid%>&folderid=<%=folderid%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
					document.getElementById("forwordinnerurl").value=innerurl;
					
					var url="/mobile/plugin/email/forwardBtnDialog.jsp";
					var top = ($( window ).height()-150)/2;
					var width = window.innerWidth > 480 ? 480 : window.innerWidth - 20;
					$.open({
						id : "forwardBtnWindow",
						url : url,
						title : "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage()) %>",
						width : width,
						height : 130,
						top: top,
						callback : function(action, returnValue){
						}
					});
					$.reload('forwardBtnWindow', url + "?r=" + (new Date()).getTime());
					 
				   <%}else if(mailType==1){%>
				   	 var url="/mobile/plugin/email/EmailNewIn.jsp?flag=3&id=<%=mailid%>&folderid=<%=folderid%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
				     window.location.href=url;
				   	  
				   <%}else if(mailType==0){%>
				   	var url="/mobile/plugin/email/EmailNew.jsp?flag=3&id=<%=mailid%>&folderid=<%=folderid%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
				     window.location.href=url;
				   <%}else{%>
				   	var page="EmailNew.jsp";
					if(IsInterna=="1"){
							page="EmailNewIn.jsp";
					}
				   	 var url="/mobile/plugin/email/"+page+"?flag=3&id=<%=mailid%>&folderid=<%=folderid%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
				     window.location.href=url;
				   
				   <%}%>
		}
		//回复全部
		function replayAllBtn(mailIds){
					var page="EmailNew.jsp";
					if(IsInterna=="1"){
							page="EmailNewIn.jsp";
					}	
					var url="/mobile/plugin/email/"+page+"?flag=2&id=<%=mailid%>&folderid=<%=folderid%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
				    window.location.href=url;
		}
		
		//打开草稿
		function openBtn(mailIds){
					var url="/mobile/plugin/email/EmailNew.jsp?flag=4&id=<%=mailid%>&folderid=<%=folderid%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
				    window.location.href=url;
		}

		
		function nextpage(mailIds){
			var url="/mobile/plugin/email/EmailView.jsp?mailid="+mailIds+"&folderid=<%=folderid%>&status=<%=status%>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
			  window.location.href=url;
		}
		//当用户点击标题上左边或右边按钮时，客户端会调用页面上的javascript方法:
		function doLeftButton() {
			var fromES="<%=fromES%>";
			if(fromES=="true"){
				 location = "/mobile/plugin/fullsearch/list.jsp?module=<%=module%>&scope=<%=scope%>&fromES=true";
			}else{
				window.location.href="/mobile/plugin/email/EmailMain.jsp?folderid=<%=folderid%>&status=<%=status%>&star=<%=star%>&menuid=<%=menuid%>&module=<%=module%>&scope=<%=scope%>";
			}
					return "1";
		}
		function getLeftButton(){
				return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
		}
		function openShowNameHref(){
			return false;
		}
		
		function showALLTO(obj,mailaddress){
			var alldiv=$(obj).parent().next();
			if($.trim(alldiv.html())!=""){ 
			   alldiv.show();
			   $(obj).parent().hide();
			   return ;
			}
			//延迟加载数据，达到一种好的加载效果
			 setTimeout(
			 	function(){
			 				$.post("/mobile/plugin/email/EmailLoadHrm.jsp?isInternal=<%=IsInterna%>&operation=getAllTO",{mailaddress:mailaddress}, function(data){
			 						$(obj).parent().hide();
									alldiv.html(data).show();
									if(alldiv.height()>=100){
										alldiv.height("100px");
										alldiv.css("overflow-x","none").css("overflow-y","auto");
									}
							});
			 	}
			 ,500);
		}
		
		function showALL(obj,type){
			var alldiv=$(obj).parent().next();
			if($.trim(alldiv.html())!=""){
			   alldiv.show();
			   $(obj).parent().hide();
			   return ;
			}
			//延迟加载数据，达到一种好的加载效果
			 setTimeout(
			 	function(){
	 				$.post("/mobile/plugin/email/EmailLoadHrm.jsp?isInternal=<%=IsInterna%>&type="+type+"&mailid=<%=mailid%>", "", function(data){
							$(obj).parent().hide();
							alldiv.html(data).show();
							if(alldiv.height()>=100){
								alldiv.height("100px");
								alldiv.css("overflow-x","none").css("overflow-y","auto");
							}
					});
			 	}
			 ,500);
		}
		
		function hideALL(obj){
			var partdiv=$(obj).parent().prev().show();
			$(obj).parent().hide();
		}
		
</script>
<%
    }
%>	
   
 </body>
</html>
