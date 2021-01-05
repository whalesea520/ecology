
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="weaver.docs.category.CategoryUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.AppDao"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="gms" class="weaver.blog.service.BlogGroupService" scope="page" />  
<%@page import="weaver.blog.AppItemVo"%>
<%@page import="weaver.blog.AppVo"%>
<head>
<title><%=SystemEnv.getHtmlLabelName(26468,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel=stylesheet href="/css/Weaver_wev8.css" type="text/css" />
<LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='js/timeline/easing_wev8.js'></script>
<script type='text/javascript' src='js/highlight/jquery.highlight_wev8.js'></script>
<script language="javascript" src="/js/weaverTable_wev8.js" type="text/javascript"></script>
<link href="js/timeline/lavalamp_wev8.css" rel="stylesheet" type="text/css"> 
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
<script type="text/javascript" charset="utf-8" src="/weaverEditor/kindeditor-Lang_wev8.js"></script>

<link href="js/weaverImgZoom/weaverImgZoom_wev8.css" rel="stylesheet" type="text/css">
<script src="js/weaverImgZoom/weaverImgZoom_wev8.js"></script>

<script type="text/javascript" src="js/raty/js/jquery.raty_wev8.js"></script>

<!-- 微博便签 -->
<script type="text/javascript" src="/blog/js/notepad/notepad_wev8.js"></script>

<!-- 加载javascript -->
<jsp:include page="blogUitl.jsp"></jsp:include>
</head>
<body>
<%@ include file="/blog/uploader.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
	String userid = "" + user.getUID();
	BlogDao blogDao = new BlogDao();
	Date today = new Date();
	Date startDateTmp = new Date();
	SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy年MM月dd日");
	SimpleDateFormat timeFormat=new SimpleDateFormat("HH:mm");
	
	String curDate = dateFormat1.format(today); //当前日期
	startDateTmp.setDate(startDateTmp.getDate() - 30);
	String startDate =dateFormat1.format(startDateTmp);

	AppDao appDao = new AppDao();
	List appItemVoList = appDao.getAppItemVoList("mood");
	
	String enableDate=blogDao.getSysSetting("enableDate");       //微博启用日期
	String attachmentDir=blogDao.getAttachmentDir(); //附件上传目录  
	
	if(dateFormat1.parse(enableDate).getTime()>dateFormat1.parse(startDate).getTime()){
		startDate=enableDate;
	}
	
	String menuItem=Util.null2String(request.getParameter("menuItem"));
	
	if(menuItem.equals(""))
		menuItem="myBlog";
	
	BlogReportManager reportManager=new BlogReportManager();
	
	//来访记录
	int visitTotal=blogDao.getVisitTotal(userid);
	int visitCurrentpage=1;
	int visitTotalpage=visitTotal%5>0?visitTotal/5+1:visitTotal/5;
	List visitorList=blogDao.getVisitorList(userid,visitCurrentpage,5,visitTotal);
	
	int accessTotal=blogDao.getAccessTotal(userid);
	int accessCurrentpage=1;
	int accessTotalpage=accessTotal%5>0?accessTotal/5+1:accessTotal/5;
	List visitList=blogDao.getAccessList(userid,accessCurrentpage,5,accessTotal);
	
	Map<String, String> defaultTempMap = blogDao.getDefaultTemplate(""+user.getUID());
	String tempContent="";
	int isUsedTemp = 0;
	if(defaultTempMap.size() > 0){
		isUsedTemp = 1;
		tempContent = defaultTempMap.get("tempContent");
	}
	String from=Util.null2String(request.getParameter("from"));
	
	String allowRequest=blogDao.getSysSetting("allowRequest");   //是否接收关注申请
	Map count=blogDao.getReindCount(user); 
	int remindCount=((Integer)count.get("remindCount")).intValue();           //提醒未查看数
	int commentCount=((Integer)count.get("commentCount")).intValue();         //评论未查看
	int updateCount=((Integer)count.get("updateCount")).intValue();           //更新总数
	
	//int blogCount= blogDao.getMyBlogCount(userid);               //微博总数
	//int myAttentionCount= blogDao.getMyAttentionCount(userid,"all");   //我关注的人总数
	//int attentionMeCount= blogDao.getAttentionMe(userid).size();        //关注我的人总数
	//BlogShareManager shareManager=new BlogShareManager();
	//int myShareCount=shareManager.getMyShareCount(userid); //我的分享
	
	//int shareMeCount=blogDao.getBlogMapList(userid,"canview",null).size(); //分享给我
	String isEnableExtranetHelp = KtreeHelp.getInstance().isEnableExtranetHelp;
	
	String currentdate=TimeUtil.getCurrentDateString();
	boolean isSetWorkday=blogDao.isSetWorkday(user,currentdate);
%>

<script type="text/javascript">
   var tempHeight=0;      //微博模版高度
   var isUsedTemp=<%=isUsedTemp%>;  //是启用模版
   
   function showAlert(title){
		jQuery("#warn").css("left",(jQuery(document.body).width()-220)/2);
		jQuery("#warn").css("top",215+document.body.scrollTop);
		jQuery("#warn").find("label").html(title);
		jQuery("#warn").css("display","block");
		setTimeout(function (){
			jQuery("#warn").css("display","none");
		},1500);
	}
   
</script>

<style>

</style>

<div id="warn">
	<div class="title"></div>
</div>

<div id="blogLoading" class="loading" align='center'>
	<div id="loadingdiv" style="right:260px;">
		<div id="loadingMsg">
			<div><%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%></div>
		</div>
	</div>
</div>
 
<div style="height: 100%;" id="myBlogdiv">
<div id="mainContent" class="mainContent" style="overflow:auto;height: 100%;">
<table style="width: 100%;height: 100%;" cellpadding="0" cellspacing="0">
   <tr>
       <td valign="top" width="*" style="max-width: 800px;">
            <!-- 左边 --> 
            <div style="left:6px;width:43px;height:60px;background: url('<%=from.equals("rdeploy")?"/blog/images/new/blog.png":"/js/tabs/images/nav/mnav19_wev8.png"%>') no-repeat left center;position: absolute;"></div>
			<div id="tabTitle" style="left:55px;top:10px;height:60px;position: absolute;font-size:16px;"><%=SystemEnv.getHtmlLabelName(26468,user.getLanguage())%></div> 
			<div class="">
				<!-- 主页 -->
				<div class="tabStyle2" id="homepageMenu" style="display:none;">
					<div class="tabitem select2" url="discussList.jsp?requestType=homepage&currentpage=1&groupid=all">
						<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(26467,user.getLanguage())%></A></div>
						<div class="arrow"></div>
					</div>
					<div class="tabitem" url="discussList.jsp?blogid=<%=userid%>&requestType=homepageNew">
						<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(33847,user.getLanguage())%></A></div><!-- 未读微博 -->
						<div class="tabseprator"></div>
						<div class="arrow"></div>
					</div>
					<%
						ArrayList groupList = gms.getGroupsById(user.getUID());
						for(int i=0; i<groupList.size()&&i<3; i++)
						{
							Map groupMap=(Map)groupList.get(i);
							String groupid=(String)groupMap.get("id");
							String groupname=(String)groupMap.get("groupname");
					%>
					<div class="tabitem" url="discussList.jsp?requestType=homepage&currentpage=1&groupid=<%=groupid%>">
						<div class="title"><A href="javascript:void(0)" title="<%=groupname%>"><%=groupname%></A></div>
						<div class="tabseprator"></div>
						<div class="arrow"></div>
					</div>
					<%}
						if(groupList.size()>3){
					%>
						<div id="moregroup" target="moregroupdown" style="position:relative;float:left;">
							 <A href="javascript:void(0)" title="<%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%>">
							    <img src="\blog\images\task_i_extend_wev8.png" style="position: absolute;top:4px;border: 0px;"> 
						     </A>
					     </div>
					<%}%>
					<div style="float: right; padding-right: 10px; height: 23px;margin-top: 3px;">
						<div style="float: left; height: 20px; line-height: 20px;position: relative;">
							 <INPUT id=hpStartdate name=hpStartdate type=hidden value="<%=startDate%>">
							 <BUTTON type="button" class=CalendarNew onclick="getDate('hpStartdatespan','hpStartdate')" style="vertical-align: middle;"></BUTTON>
							 <SPAN id="hpStartdatespan"><%=startDate%></SPAN> 
							 	<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>&nbsp;
							 <BUTTON type="button" class=CalendarNew onclick="getDate('hpEnddatespan','hpEnddate')" style="vertical-align: middle;"></BUTTON> 
							 <SPAN id=hpEnddatespan><%=curDate%></SPAN>&nbsp;
							 <INPUT id=hpEnddate name=hpEnddate type=hidden value="<%=curDate%>">
						</div>
						<div style="float: left; padding-right: 5px;margin-top: -5px;">
							<span id="searchblockspan"> 
								<span class="searchInputSpan" id="searchInputSpan" style="position: relative; top: 0px; left: 4px;height:26px;width: 105px;">
									<input type="text" class="searchInput middle" onkeypress="if(event.keyCode==13) $(this).next().click()" name="hpContent" id="hpContent" value="" style="vertical-align: top;height:26px;line-height:26px;width:75px;">
									<span class="middle searchImg" onclick="search('hpContent','hpStartdate','hpEnddate',this);" from="homepage">
										<img class="middle" style="vertical-align: top; margin-top: 6px;" src="/images/ecology8/request/search-input_wev8.png">
									</span>
								</span>
						</span>
						</div>
						<div class="clear"></div>
					</div>
					 
				</div>
				
				<ul id="moregroupdown" class="btnGrayDropContent" style="width: 92px;" >
				<%
				for(int i=0; i<groupList.size(); i++)
				{
					if(i<5) continue;
					Map groupMap=(Map)groupList.get(i);
					String groupid=(String)groupMap.get("id");
					String groupname=(String)groupMap.get("groupname");
				%>
					<li class="tabitem downitem" title="<%=groupname%>" style="width:84px;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;" url="discussList.jsp?requestType=homepage&currentpage=1&groupid=<%=groupid%>"><%=groupname%></li>
				<%} %>	
				</ul>
				
				<!-- 微博 -->
				<div class="tabStyle2" id="myBlogMenu">
					<div class="tabitem select2" id="blog" url="discussList.jsp?blogid=<%=userid%>&requestType=myblog">
						<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())%></A></div>
						<div class="arrow"></div>
					</div>
					<div class="tabitem" id="comment" url="commentOnMe.jsp">
						<div class="title">
							<A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%></A>
							<em id="sysremind" class="msg-count" style="position: absolute;top:2px;left:30px;display:<%=commentCount>0?"":"none"%>" title="<%=SystemEnv.getHtmlLabelName(19085,user.getLanguage())%>">
								<span class="count"><%=commentCount%></span>
							</em>
						</div>
						<div class="tabseprator"></div>
						<div class="arrow"></div>
					</div>
					<div style="float: right; padding-right: 10px; height: 23px;margin-top:3px; ">
						<div style="float: left; height: 20px; line-height: 20px;position: relative;">
							 <INPUT id=myBlogStartdate name=myBlogStartdate type=hidden value="<%=startDate%>">
							 <BUTTON type="button" class=CalendarNew onclick="getDate('myBlogStartdatespan','myBlogStartdate')" style="vertical-align: middle;"></BUTTON>
							 <SPAN id="myBlogStartdatespan"><%=startDate%></SPAN>
							 	<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>&nbsp;
							 <BUTTON type="button" class=CalendarNew onclick="getDate('myBlogEnddatespan','myBlogEnddate')" style="vertical-align: middle;"></BUTTON> 
							 <SPAN id=myBlogEnddatespan><%=curDate%></SPAN>&nbsp;
							 <INPUT id=myBlogEnddate name=myBlogEnddate type=hidden value="<%=curDate%>">
						</div>
						<div style="float: left; padding-right: 5px;margin-top: -5px;">
							<span id="searchblockspan">
								<span class="searchInputSpan" id="searchInputSpan" style="position: relative; top: 0px; left: 4px;height:26px;width:105px;">
									<input type="text" class="searchInput middle" name="myBlogContent" onkeypress="if(event.keyCode==13) $(this).next().click()" id="myBlogContent" value="" style="vertical-align: top;height:26px;line-height:26px;width:75px;">
									<span class="middle searchImg" onclick="search('myBlogContent','myBlogStartdate','myBlogEnddate',this);" from="myBlog">
										<img class="middle" style="vertical-align: top; margin-top: 6px;" src="/images/ecology8/request/search-input_wev8.png">
									</span>
								</span>
						</span>
						</div>
						<div class="clear"></div>
					</div>
					<div class="clear"></div>
				</div>
				
				<!-- 便签 -->
				<div class="tabStyle2" id="notepadMenu" style="display:none;">
					<div class="tabitem select2" id="notepaditem" url="blogNotes.jsp">
						<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(33305,user.getLanguage())%></A></div>
						<div class="arrow"></div>
					</div>
				</div>
				
				<!-- 我的关注 -->
				<div class="tabStyle2" id="myAttentionMenu" style="display:none;">
					<div class="tabitem select2" url="myAttention.jsp?from=myblog">
						<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(26469,user.getLanguage())%></A></div>
						<div class="arrow"></div>
					</div>
				</div>
				
				<!-- 关注 -->
				<div class="tabStyle2" id="attentionMenu" style="display:none;">
					<!-- 关注 -->
					<div class="tabitem select2" url="myAttentionHrm.jsp?userid=<%=userid%>" style="display:none;">
						<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(25436,user.getLanguage())%></A></div>
						<div class="arrow"></div>
					</div>
					<!-- 粉丝 -->
					<div class="tabitem" url="attentionMeHrm.jsp?userid=<%=userid%>">
						<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(131542,user.getLanguage())%></A></div>
						<div class="arrow"></div>
					</div>
					<div class="tabitem" url="canViewMeHrm.jsp?userid=<%=userid%>" style="display:none;">
						<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(33310,user.getLanguage())%></A></div>
						<div class="arrow"></div>
					</div>
					<div class="tabitem" url="canViewHrm.jsp?userid=<%=userid%>" style="display:none;">
						<div class="title"><A href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(33311,user.getLanguage())%></A></div>
						<div class="arrow"></div>
					</div>
				</div>
				
			    
				<div class="reportBody" id="reportBody" style="background-color: inherit !important; "></div>
				
				<!-- 主页数据加载提示 -->
				<div id="loadingdiv" style="position:relative;width: 100%;height: 30px;margin-bottom: 15px;display: none;">
			      <div class='loading' style="position: absolute;top: 10px;left: 50%;">
			         <img src='/images/loadingext_wev8.gif' align="absMiddle"><%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>
			      </div>
			    </div>	
			</div>
       </td>
       <td valign="top" style="width:220px;border-left:1px solid #dadada;"> 
          <!-- 右边 -->
			<div class="right" style="width:253px;">
				<div class="side-item" style="height: 167px;">
					<div style="padding-top: 12px; position: relative;" align="center">
					<!--
						<img src="<%=ResourceComInfo.getMessagerUrls(userid)%>" style="width: 50px; height: 50px; margin-top: -2px;"/>
					-->
						<%=weaver.hrm.User.getUserIcon(userid,"width: 50px; height: 50px; line-height: 50px; font-size: 14px; margin-top: -2px;border-radius:30px;") %>
						<div class="head_bg"></div>
						
							<div class="remind_msg" onclick="viewRemind(this)">
								<em id="sysremind" class="msg-count" style="position: absolute;top:-3px;left:6px;display:<%=remindCount>0?"":"none"%>" title="<%=SystemEnv.getHtmlLabelName(19085,user.getLanguage())%>">
									<span class="count"><%=remindCount%></span>
								</em>
							</div>
					</div>
				    <div class="p-l-25" style="padding-left: 35px; padding-top: 13px;">   
				             <!-- 工作指数 -->
				             <div class="h-25 lh-25" style="width:215px;">
							 <a href="javascript:void(0)" class="index color000"><%=SystemEnv.getHtmlLabelName(26929,user.getLanguage())%>：<span id="workIndexCount" style="padding-left: 6px;" title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(0)%></span><span id="workIndex" style="margin-left: 8px;padding-left: 5px; color: #8e9598">0.0</span></a><br/><!-- 未提交 应提交 -->
							 </div>
							 <%if(appDao.getAppVoByType("mood").isActive()){ 
							 %>
							 <!-- 心情指数 -->
							 <div class="h-25 lh-25" style="width:215px;">
							 <a href="javascript:void(0)" class="index color000"><%=SystemEnv.getHtmlLabelName(26930,user.getLanguage())%>：<span id="moodIndexCount" style="padding-left: 6px;" title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(0)%></span><span id="moodIndex" style="margin-left: 8px;padding-left: 5px; color: #8e9598">0.0</span></a><br/><!-- 不高兴 高兴 -->
							 </div>
							 <%}%>
							 <% String isSignInOrSignOut=Util.null2String(blogDao.getIsSignInOrSignOut(user));//是否启用前到签退功能
							    if(isSignInOrSignOut.equals("0")){
							 %>
							 <!-- 考勤指数 -->
							 <div class="h-25 lh-25" style="width:215px;">
							 <a href="javascript:void(0)" class="index color000"><%=SystemEnv.getHtmlLabelName(26931,user.getLanguage())%>：<span id="scheduleIndexCount" style="padding-left: 6px;" title="<%=SystemEnv.getHtmlLabelName(20085,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%>0<%=SystemEnv.getHtmlLabelName(20079,user.getLanguage())%>"><%=reportManager.getReportIndexStar(0)%></span><span id="scheduleIndex" style="margin-left: 8px;padding-left: 5px; color: #8e9598">0.0</span></a><!-- 旷工 迟到 -->
						     </div>
						     <%} %>
					</div>
				</div>
			
				<div class="side-item menu">
						<!-- 我的微博 -->
						<div class="menuItem myblog chbc" id="myBlog" url="discussList.jsp?blogid=<%=userid%>&requestType=myblog">
						    <div class="menuName" >
						    	<div class="title left"><%=SystemEnv.getHtmlLabelName(26468,user.getLanguage())%></div>
							 	<em id="blogCount" class="menu-count-no-bg right" style="margin-top: 15px;">
							 		<span class="menucount"></span>
								</em>
								<div class="clear"></div>
						    </div>
						</div>
				        <!-- 我的主页 --> 
					    <div class="menuItem homepage chbc"  id="homepage" url="discussList.jsp?requestType=homepage&currentpage=1">
						    <div class="menuName">
						     <div class="title left"><%=SystemEnv.getHtmlLabelName(27128,user.getLanguage())%></div>
						     <em id="unpdateCount" class="msg-count menu-count-no-bg right" onclick="viewUnreadMsg('update',event)" style="display: <%=updateCount>0?"":"none"%>;margin-top:15px;width:auto;background-color: #fff;"><span class="count" style="background-color: #fff;"><%=updateCount%></span></em>
							 <div class="clear"></div>
						    </div>
						</div>
						<!-- 我的关注 -->
						<div class="menuItem attention chbc" id="myAttention"  url="/blog/myAttention.jsp">
						    <div class="menuName">
						    	<div class="title left"><%=SystemEnv.getHtmlLabelName(26469,user.getLanguage())%></div>
						    	<em id="myAttentionCount" class="menu-count-no-bg right" style="margin-top: 15px;">
									<span class="menucount"></span>  
								</em>
								<div class="clear"></div>
						    </div>
						</div>
						<!-- 我的粉丝 -->
						<div class="myfans chbc" onclick="showItem('fans',1);">
							<div class="menuName">
								<div class="title left"><%=SystemEnv.getHtmlLabelName(131542,user.getLanguage())%></div>
								<em id="attentionMeCount" class="menu-count-no-bg right" style="margin-top: 15px;">
									<span class="menucount"></span>
								</em>
								<div class="clear"></div>
							</div>
						</div>
						<!-- 评论我的 -->
						<div class="menuItem commentonme" style="display:none;" id="comment" url="commentOnMe.jsp">
						    <span class="menuName"><span class="title"><%=SystemEnv.getHtmlLabelName(26999,user.getLanguage())%></span></span><em class="msg-count" style="display:<%=commentCount>0?"":"none"%>"><span class="count"><%=commentCount%></span></em>
						</div>
						<!-- 微博便签 -->
						<div class="menuItem notepad chbc" id="notepad"  url="blogNotes.jsp">
						    <div class="menuName">
						    	<div class="title"><%=SystemEnv.getHtmlLabelName(33304,user.getLanguage())%></div>
						    </div>
						</div>
						<!-- 消息提醒 -->
						<div class="menuItem sysremind" style="display:none;" id="sysremind"  url="blogRemind.jsp">
						    <span class="menuName"><span class="title"><%=SystemEnv.getHtmlLabelName(19085,user.getLanguage())%></span></span><em class="msg-count" style="display:<%=remindCount>0?"":"none"%>"><span class="count"><%=remindCount%></span></em>
						</div>
				</div>
				<%if(visitorList.size()>0){ %>
					<!-- 最近来访 -->
					<div class="side-item people-box">
						<div class="title">
							<!--
							<img src="images/visit_in_wev8.png" align="absmiddle" style="margin-right: 3px"/>
							 -->
							<span><%=SystemEnv.getHtmlLabelName(26934,user.getLanguage())%></span>
						    <span style="margin-left:135px"><img id="prepage" onclick="visitpage('pre')" align="absmiddle" width="12px" style="cursor: pointer;" alt="上一页" src="images/pre_page_no_wev8.png">&nbsp;&nbsp;<img onclick="visitpage('next')" id="nextpage" align="absmiddle" style="cursor: pointer;" alt="下一页" width="12px" src="<%=visitTotalpage>1?"images/next_page_wev8.png":"images/next_page_no_wev8.png" %>"></span>
						</div>
						<div id="visitList" class="peoplebox-body clear">
								<ul class="people-list" style="width: 100%">
								<%for(int i=0;i<visitorList.size();i++){
									Map map=(Map)visitorList.get(i);
									String visitor=(String)map.get("userid");
									String visitdate=(String)map.get("visitdate");
									visitdate=dateFormat2.format(dateFormat1.parse(visitdate));
									String visittime=(String)map.get("visittime");
									visittime=timeFormat.format(timeFormat.parse(visittime));
								%>
									<li style="margin-right: 0px;width: 100%;height: 45px">
									
									<div style="float: left;">
									  <a  href="viewBlog.jsp?blogid=<%=visitor%>" target="_blank">
									  <!-- <img style="border: 0px;cursor: pointer;" src="<%=ResourceComInfo.getMessagerUrls(visitor)%>" width="35px"> -->
									      
									      <%=weaver.hrm.User.getUserIcon(visitor,"width: 35px; height: 35px;line-height: 35px;border-radius:25px;") %>
									  </a>
									</div>
									<div style="float: left;margin-left: 5px">
									   <span class="name" style="text-align: left;height: 40px;">
									      <div style="margin-bottom:3px;text-align: left;">
									        <a  href="viewBlog.jsp?blogid=<%=visitor%>" target="_blank" style="color:#000 !important"><%=ResourceComInfo.getLastname(visitor) %></a>
									      </div>
									      <div style="color:#b0b0b0;text-align: left;margin-top:6px;"><%=visitdate+" "+visittime%></div>
									   </span>
									</div>
									<div style="clear:both;"></div>
								</li>
								<%}%>
							   </ul>
							
						</div>
					</div>
				<%}%>
				<%if(visitList.size()>0){%>
					<!-- 最近访问 -->
					<div class="side-item people-box">
						<div class="title">
							<!-- <img src="images/visit_to_wev8.png" align="absmiddle" style="margin-right: 3px"/>  -->
							<span><%=SystemEnv.getHtmlLabelName(26935,user.getLanguage())%></span>
						    <span style="margin-left:135px"><img id="accessprepage" onclick="accesspage('pre')" align="absmiddle" width="12px" style="cursor: pointer;" alt="上一页" src="images/pre_page_no_wev8.png">&nbsp;<img onclick="accesspage('next')" id="accessnextpage" align="absmiddle" style="cursor: pointer;" alt="下一页" width="12px" src="<%=accessTotalpage>1?"images/next_page_wev8.png":"images/next_page_no_wev8.png" %>"></span>
						</div>
						<div id="accessList" class="peoplebox-body clear" style="width: 195px;">
							<ul class="people-list" style="width: 100%">
								<%for(int i=0;i<visitList.size();i++){
								    Map map=(Map)visitList.get(i);
									String visitor=(String)map.get("userid");
									String visitdate=(String)map.get("visitdate");
									visitdate=dateFormat2.format(dateFormat1.parse(visitdate));
									String visittime=(String)map.get("visittime");
									visittime=timeFormat.format(timeFormat.parse(visittime));
								%>
									<li  style="margin-right: 0px;width: 100%;height: 45px">
									<div style="float: left;">
									   <a href="viewBlog.jsp?blogid=<%=visitor%>" target="_blank">
									   <!-- <img style="border: 0px;cursor: pointer;" src="<%=ResourceComInfo.getMessagerUrls(visitor) %>" width="35px"> -->
									       <%=weaver.hrm.User.getUserIcon(visitor,"width: 35px; height: 35px;line-height: 35px;border-radius:25px;") %>
									   </a>
									   
									</div>
									<div style="float: left;margin-left: 5px;">
									   <span class="name" style="text-align: left;height: 40px;">
									      <div style="margin-bottom:3px;text-align: left;">
									          <a href="viewBlog.jsp?blogid=<%=visitor%>" style="color:#000 !important" target="_blank"><%=ResourceComInfo.getLastname(visitor) %></a>
									      </div>
									      <div style="color: #b0b0b0;text-align: left;margin-top:6px;"><%=visitdate+" "+visittime%></div>
									   </span>
									</div>
									<div style="clear:both;"></div>
								</li>
								<%}%>
							</ul>
						</div>
					</div>
				<%} %>
				<div style="height: 20px;"></div>
			</div>
       </td>
   </tr>
</table>

<div class="clear"></div>
</div>

<iframe id="downloadFrame" style="display: none"></iframe>
<!-- 微博模版内容 -->
<div id="templatediv" style="display: none;">
  <%=tempContent%>
</div>
<div class="editorTmp" style="display:none">
<table style="width: 100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		 <textarea name="submitText" scroll="none" style="border: solid 1px;width:100%"></textarea>
		</td>
	</tr>
	<tr>
		<td>
			<div class="appItem_bg">
	   	    <%
		   	    List appVoList=appDao.getAppVoList();
		   	 	for(int i=0;i<appVoList.size();i++){
		   	 		AppVo appVo=(AppVo)appVoList.get(i);
		   	 		if("mood".equals(appVo.getAppType())){
		   	 		if(appItemVoList!=null&&appItemVoList.size()>0){ 
				   		AppItemVo appItemVo1=(AppItemVo)appItemVoList.get(0);
				   		
				   		String itemType1=appItemVo1.getType();
		  				String itemName1=appItemVo1.getItemName();
		  				if(itemType1.equals("mood"));
		  				   itemName1=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName1),user.getLanguage());
			 %>
			   <!-- 心情 -->
			   <div class="optItem" style="width:auto;position: relative;margin-left:5px;margin-right:5px;">
				  <div id="mood_title" class="opt_mood_title" style="background: url('<%=appItemVo1.getFaceImg()%>') no-repeat left center;"  onclick="show_select('mood_title','mood_items','qty_<%=appItemVo1.getType() %>','mood',event,this)">
				    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(26920,user.getLanguage())%></a><!-- 心情 -->
				  </div>
				  <div id="mood_items" style="display:none" class="opt_items">
				  		<%
				  			for(int j=0;j<appItemVoList.size();j++) {
				  				AppItemVo appItemVo= (AppItemVo)appItemVoList.get(j);
				  				String itemType=appItemVo.getType();
				  				String itemName=appItemVo.getItemName();
				  				if(itemType.equals("mood"));
				  				   itemName=SystemEnv.getHtmlLabelName(Util.getIntValue(itemName),user.getLanguage());
				  		%>
					   		<div class='qty_items_out'  val='<%=appItemVo.getId() %>'><img src="<%=appItemVo.getFaceImg() %>" alt="<%=itemName%>" width="16px" align="absmiddle" style="margin-right:3px;margin-left:2px"><%=itemName%></div>
					   <%} %>
				  </div> 
				  <input name="qty_<%=appItemVo1.getType() %>" class="qty" type="hidden" id="qty_<%=appItemVo1.getType() %>" value="<%=appItemVo1.getId() %>" />
			   </div>
				
		   	 <%} 
	   	   }else if("attachment".equals(appVo.getAppType())){
	   	 %>
	   	    <!-- 附件 -->
	   	    <div class="optItem" style="width: 120px;position: relative;">
			  <div id="temp_title" style="width: 120px" class="opt_title" onclick="openApp(this,'')">
			   <%
			   if(attachmentDir!=null&&!attachmentDir.trim().equals("")){ 
				   RecordSet recordSet=new RecordSet();
				   recordSet.executeSql("select maxUploadFileSize from DocSecCategory where id="+attachmentDir);
				   recordSet.next();
				   String maxsize = Util.null2String(recordSet.getString(1));
			   %>
			    <a href="javascript:void(0)"><div class="uploadDiv" mainId="" subId="" secId="<%=attachmentDir%>" maxsize="<%=maxsize%>"></div></a>
			   <%}else{ %>
			    <span style="color: red"><%=SystemEnv.getHtmlLabelName(24429,user.getLanguage())%></span>
			   <%} %>
			  </div>
		  </div>
	   	 <%}else{ %>
			  <div class="optItem" style="width: auto;position: relative;margin-right:10px;">
				  <div class="title" style="background: url('<%=appVo.getIconPath() %>') no-repeat left center;" class="opt_title" onclick="openApp(this,'<%=appVo.getAppType() %>')">
				    <a href="javascript:void(0)"><%=SystemEnv.getHtmlLabelName(Integer.parseInt(appVo.getName()),user.getLanguage()) %></a>
				  </div>
	
			  </div>
		  <%}} %>
		  
		  	 <div style="float:right;vertical-align: middle;margin-right:5px;" >
				    <!-- 保存 -->
					<button type="button" class="submitButton" onclick="saveContent(this)"><%=SystemEnv.getHtmlLabelName(33848,user.getLanguage())%></button>
					<!-- 取消 -->
					<button type="button" class="editCancel" onclick="editCancel(this);"><%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></button>
			 </div>
		  
			 <div class="clear"></div>
		</div>
	</td>
	</tr>
	</table>
</div>
</div>
</body>
</html>
<script>
    var tempHeight=0;      //微博模版高度
    var isUsedTemp=<%=isUsedTemp%>;  //是启用模版
    
	jQuery(function(){
		
		//检查是否设置一般工作时间
		if("<%=isSetWorkday%>"=="false"){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84409,user.getLanguage())%>");
		}
	
		jQuery(".menuItem").click(function(obj){
		    jQuery(document.body).focus();
			jQuery(".menuItem").each(function(){
				jQuery(this).removeClass("selected");
			});
            jQuery('.myfans').removeClass("selected");
			
			jQuery(this).addClass("selected");
			var url=jQuery(this).attr("url");
			
		    var menuItem=jQuery(this).attr("id");
		    
		    //未读数字提醒不用隐藏
		    if(menuItem!="homepage")
		       jQuery(this).find(".msg-count").hide();
		       
			if(menuItem=="myAttention"){
				$(".tabStyle2").hide();
				jQuery("#myAttentionMenu .tabitem:first").addClass("select2");
			    jQuery("#myAttentionMenu").show();
		    	jQuery("#reportBody").html('<iframe src="/blog/myAttention.jsp?from=myblog" id="attentionframe" style="position: relative;" name="attentionframe" frameborder="0" width="100%"></iframe>');
		    	
		    	//$("#blogLeftdiv",parent.document).show();
				//$("#blogRightdiv",parent.document).css({"left":"281px"});
		    	
		    	return;
			}else{
				$("#blogLeftdiv",parent.document).hide();
				$("#blogRightdiv",parent.document).css({"left":"0px"});
			}  
		    displayLoading(1,"page");
			jQuery.post(url,{},function(a){
			    
				jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
				
				$(".todayArea").each(function(){
					//$(this).parent().height($(this).parent().next().height());
				});
				
				if(menuItem=="notepad")
				      //初始化微博便签编辑器
				      showBlogNotes();
				else{       
					  //显示今天编辑器
					  jQuery(".editor").each(function(){
					    if(jQuery(this).css("display")=="block"){
						   showAfterSubmit(this);
						}
				      });
			    }
			    
			    $(".tabStyle2").hide();
			    
			    jQuery(".tabStyle2 li").each(function(){
						jQuery(this).removeClass("select2");
				});
			    
				if(menuItem=="myBlog"){
			        jQuery("#myBlogMenu").show();
			        jQuery("#searchBtn").attr("from","myBlog");    //修改搜索来源页
			        
					jQuery("#myBlogMenu .tabitem:first").addClass("select2");
					
					//显示第一条工作微博系统操作记录
					var blogItem=jQuery(".reportItem[istoday='false']:first");
					var workdate=blogItem.attr("fordate");
					if(workdate)
					    showLog(blogItem.find(".showlog")[0],<%=userid%>,workdate);
			    }else{ 
			        jQuery("#searchBtn").attr("from","homepage");  //修改搜索来源页
			        jQuery("#myBlogMenu").hide();     
			     }
			    if(menuItem=="homepage"){
			    	$("#homepageMenu .tabitem").removeClass("select2");
					jQuery("#homepageMenu .tabitem:first").addClass("select2");
			    	jQuery("#homepageMenu").show();
			    }
			    
			    if(menuItem=="notepad"){
					jQuery("#notepadMenu .tabitem:first").addClass("select2");
			    	jQuery("#notepadMenu").show();
			    }
				
		        //初始化处理图片
		        jQuery('.reportContent img').each(function(){
					initImg(this);
			    });
				//上级评分初始化
				jQuery(".blog_raty").each(function(){
				   managerScore(this);
				   jQuery(this).attr("isRaty","true"); 
				});
					
				displayLoading(0);
			});
		});
		
		jQuery(".menuName").hover(
		  function(){
		     jQuery(this).css("text-decoration","underline");
		  },function(){
		     jQuery(this).css("text-decoration","none");
		  }
		);
		jQuery("#unpdateCount").hover(
		  function(){
		     jQuery(this).css("font-weight","bold");
		  },function(){
		     jQuery(this).css("font-weight","normal");
		  }
		);
		
		$("#moregroup").hover(function(event){
			 var target="#"+$(this).attr("target");
			 var x=$(this).offset().left
			 var y=$(this).offset().top
			 //alert($(this).offset().left);
			 $(target).css("top",y+30);
			 $(target).css("left",x+10);
			 
			 $(target).show();
			 $(this).find("img").attr("src","/blog/images/task_i_shrink_wev8.png");
			//stopEvent();
		},function(){
			var target="#"+$(this).attr("target");
			$(this).find("img").attr("src","/blog/images/task_i_extend_wev8.png");
			$(target).hide();
		});
	
		jQuery(".btnGrayDropContent").hover(function(){
			jQuery("#moregroupdown").show();
		},function(){
			jQuery("#moregroupdown").hide();
		})
		jQuery(".btnGrayDropContent  li").hover(function(){
			jQuery(this).css("background-color","#cccccc");
		},function(){
			jQuery(this).css("background-color","#f8f8f8");
		});
		
		jQuery(".btnGrayDropContent .tabitem").click(function(){
			jQuery("#moregroup span").html(jQuery(this).html());
			jQuery("#moregroup").addClass("select2");
			jQuery("#moregroupdown").hide();
		});
		
		setTimeout(function(){
			if("<%=menuItem%>"=="sysremind")
			 	 viewUnreadMsg();    
			else if("<%=menuItem%>"!="")
			     jQuery("#<%=menuItem%>").click();
			else
			     jQuery("#homepage").click();
			if("<%=Util.null2String(blogDao.getSysSetting("isSendBlogNote"))%>"=="1"){    
				notepad('.reportContent'); //微博便签选取数据 
			}
		},500);
		       
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
	
	function showItem(type,index){
		if(type=="blog"){
			$("#myBlog").click();
		}else{
			$(".tabStyle2").hide();
			$("#attentionMenu").show();
			$("#attentionMenu .tabitem:eq("+index+")").click();
            
            if(type == 'fans') {
                jQuery(".menuItem").removeClass("selected");
                jQuery('.myfans').addClass('selected');
            }
		}
	}
	
	
	
	//查看更新微博
	function viewUnreadMsg(msgtype,event){
		$(".tabStyle2").hide();
		$("#homepageMenu").show();
		$("#homepageMenu .tabitem:eq(1)").click();
		window.event.cancelBubble = true;
	  /*
	   displayLoading(1,"page");
	   jQuery.post("discussList.jsp?blogid=<%=userid%>&requestType=homepageNew",function(a){
	      jQuery(".menuItem").each(function(){
				jQuery(this).removeClass("selected");
		  }); 
		  jQuery("#homepage").addClass("selected");
		  jQuery("#searchBtn").attr("from","homepage");  //修改搜索来源页
	      //jQuery("#myBlogMenu").hide();      
	      //jQuery("#homepageMenu").hide();
	      $(".tabStyle2").hide();
	      jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
	      
		  
		  //初始化处理图片
		  jQuery('.reportContent img').each(function(){
			  initImg(this);
		  });
		  
		  jQuery(".blog_raty").each(function(){ //上级评分初始化
		     managerScore(this);
		     jQuery(this).attr("isRaty","true"); 
		  });
	      displayLoading(0);
	   });
	   */
	}

jQuery(document).ready(function(){

	//$("#mainContent").height(document.body.clientHeight); 

    //获取工作指数
    getIndex(<%=userid%>); 
	//隐藏所有下拉菜单
	jQuery(document.body).bind("click",function(){
		jQuery(".dropDown").hide();
		jQuery(".opt_items").hide();
	});
	
	//缓存微博内容
	/*
	setInterval(function(){
		var item=$(".reportItem:first");
		if(item.attr("isToday")=="true"){
			var editorId=item.find("textarea[name=submitText]").attr("id");
			var content=KE.html(editorId);
			if(content!=undefined)
				addCookie("blog_content_<%=userid%>_<%=curDate%>",content,24*60*60*1000);
		}
	},1000*60);
	*/
	$("#moreItem").bind("mouseenter",function(){
		showMoreMenu(1);
	}).bind("mouseleave",function(){
		//showMoreMenu(0);
	});
	
	$("#moreItemdiv").bind("mouseenter",function(){
		showMoreMenu(1);
	}).bind("mouseleave",function(){
		showMoreMenu(0);
	});
	
	$(document.body).bind("click",function(){
		showMoreMenu(0);
	});
	
	getCountdata();
});

//获取统计数据
function getCountdata(){
  jQuery.post("/blog/blogOperation.jsp?operation=getCountdata",function(data){
        data=eval('('+data+')');
        var blogCount=data.blogCount;
		var myAttentionCount=data.myAttentionCount;
		var attentionMeCount=data.attentionMeCount;
		if(blogCount>0){
			$("#blogCount .menucount").html(blogCount);
		}
		if(myAttentionCount>0){
			$("#myAttentionCount .menucount").html(myAttentionCount);
		}
		if(attentionMeCount>0){
			$("#attentionMeCount .menucount").html(attentionMeCount);
		}
        
    });
}

	function showMoreMenu(status){
		if(status==1){
			$("#moreItemdiv").show();
			$("#moreItem").addClass("moreItemover");
			$("#moreItem").find(".addicon").html("-");
		}else{
			$("#moreItemdiv").hide();
			$("#moreItem").removeClass("moreItemover");
			$("#moreItem").find(".addicon").html("+");
		}
	}

    //初始化我的微博菜单
	jQuery(function(){
		jQuery(".tabitem").click(function(obj){
		        jQuery(document.body).focus();
				jQuery(".tabitem").each(function(){
					jQuery(this).removeClass("select2");
				});
				
				if(!jQuery(this).hasClass("downitem"))
					jQuery("#moregroup").removeClass("select2");
				
				jQuery(this).addClass("select2");
				var url=jQuery(this).attr("url");
				var tabid=jQuery(this).attr("id");
				
		       jQuery(this).find(".msg-count").hide();
				
				if(!$(this).hasClass("downitem")){
					var tabTtileWidth=jQuery(this).find(".title").width()-8;
					var tabTtileLeft=jQuery(this).find(".title").position().left;
					jQuery(this).find(".arrow").css("left",tabTtileLeft+tabTtileWidth/2);
				}
				
				displayLoading(1,"page"); 
				jQuery.post(url,{},function(a){
					jQuery("#reportBody").html(a.replace(/<link.*?>.*?/, ''));
					//显示今天编辑器
					jQuery(".editor").each(function(){
					 if(jQuery(this).css("display")=="block"){
						 showAfterSubmit(this);
						}
				    });
				    
				    if(tabid=="notepaditem"){
				    	showBlogNotes();
				    }
					//if(tabid=="blog"){
					
					    //图片初始化 
						jQuery('.reportContent img').each(function(){
						   initImg(this);
				        });
						
						//上级评分初始化
						jQuery(".blog_raty").each(function(){
						   managerScore(this);
						})
						
						//显示第一条工作微博系统操作记录
						var workdate=jQuery(".reportItem[istoday='false']:first").attr("fordate");
						if(workdate){
						    showLog(jQuery("#showlog_"+workdate)[0],<%=userid%>,workdate);
						}    
					//}else if(tabid=="report"){  
					    jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
					//}
					if(tabid!="report")
					   displayLoading(0);
				});
			});
	});
	
	//添加到收藏夹
    function openFavouriteBrowser(){
	   var url=window.location.href;
	   fav_uri=url.substring(url.indexOf("/blog/"),url.length)+"&";
	   fav_uri = escape(fav_uri); 
	   var fav_pagename=jQuery("title").html();
	   fav_pagename = encodeURI(fav_pagename);

	   window.showModalDialog("/favourite/FavouriteBrowser.jsp?fav_pagename="+fav_pagename+"&fav_uri="+fav_uri+"&fav_querystring=");
    }
    //显示帮助
    function showHelp(){
        var pathKey = this.location.pathname;
	    if(pathKey!=""){
	        pathKey = pathKey.substr(1);
	    }
       var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
       var screenWidth = window.screen.width*1;
       var screenHeight = window.screen.height*1;
       var isEnableExtranetHelp = <%=isEnableExtranetHelp%>;
	   if(isEnableExtranetHelp==1){
	    	//operationPage = "/formmode/apps/ktree/ktreeHelp.jsp";
	    	operationPage = '<%=KtreeHelp.getInstance().extranetUrl%>';
	   }
       window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=900,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
    }
    
/*最近来访纪录*/
var visitTotal=<%=visitTotal%>;
var visitCurrentpage=<%=visitCurrentpage%>;
var visitTotalpage=<%=visitTotalpage%>;
function visitpage(pageType){
  if(pageType=="next"){
     if(visitCurrentpage==visitTotalpage)
        return ;
     visitCurrentpage=visitCurrentpage+1;
     if(visitCurrentpage==visitTotalpage){
        jQuery("#nextpage").attr("src","images/next_page_no_wev8.png"); 
     }   
     jQuery("#prepage").attr("src","images/pre_page_wev8.png");   
     jQuery.post("visitRecord.jsp?recordType=visit&total="+visitTotal+"&currentpage="+visitCurrentpage,function(data){
        data=jQuery.trim(data);
        jQuery("#visitList").html(data);
     });
  }else{
     if(visitCurrentpage==1)
        return ;
     visitCurrentpage=visitCurrentpage-1;
     if(visitCurrentpage==1){
        jQuery("#prepage").attr("src","images/pre_page_no_wev8.png"); 
     } 
     jQuery("#nextpage").attr("src","images/next_page_wev8.png");     
     jQuery.post("visitRecord.jsp?recordType=visit&total="+visitTotal+"&currentpage="+visitCurrentpage,function(data){
        data=jQuery.trim(data);
        jQuery("#visitList").html(data);
     });
  }
}  
  
/*最近来访纪录*/    

/*最近访问纪录*/
var accessTotal=<%=accessTotal%>;
var accessCurrentpage=<%=accessCurrentpage%>;
var accessTotalpage=<%=accessTotalpage%>;



function accesspage(pageType){
  if(pageType=="next"){
     if(accessCurrentpage==accessTotalpage)
        return ;
     accessCurrentpage=accessCurrentpage+1;
     if(accessCurrentpage==accessTotalpage){
        jQuery("#accessnextpage").attr("src","images/next_page_no_wev8.png"); 
     }
     jQuery("#accessprepage").attr("src","images/pre_page_wev8.png"); 
          
     jQuery.post("visitRecord.jsp?recordType=access&total="+accessTotal+"&currentpage="+accessCurrentpage,function(data){
        data=jQuery.trim(data);
        jQuery("#accessList").html(data);
     });
  }else{
     if(accessCurrentpage==1)
        return ;
     accessCurrentpage=accessCurrentpage-1;
     if(accessCurrentpage==1){
        jQuery("#accessprepage").attr("src","images/pre_page_no_wev8.png"); 
     }  
     jQuery("#accessnextpage").attr("src","images/next_page_wev8.png");    
     jQuery.post("visitRecord.jsp?recordType=access&total="+accessTotal+"&currentpage="+accessCurrentpage,function(data){
        data=jQuery.trim(data);
        jQuery("#accessList").html(data);
     });
  }
}  
  
/*最近来访纪录*/  

$(window).scroll(function(){     
        var bodyTop = document.documentElement.scrollTop + document.body.scrollTop;
        
        $(".seprator").each(function(){
        	if(bodyTop>=$(this).offset().top){
        	   $(".fixeddiv").removeClass("fixeddiv");
        	   //$(this).addClass("fixeddiv");
        	}
        });
        /*             
        //当滚动条滚到一定距离时，执行代码  
        if(72<=bodyTop){
        	$("#fixeddiv").addClass("fixeddiv");
        }else{
        	//alert(2);
        	$("#fixeddiv").removeClass("fixeddiv");
        }
        //alert($("#operationdiv").offset().top);	
        if(bodyTop>600){
           $(".nav").show(500);
     	}else{
		   $(".nav").hide(500);     		
     	}
     	*/
});

</script>
<style>
.fixeddiv{
	position:fixed;
	z-index:2000;
	left:0px;
	top:0px;
	right:230px;
}
</style>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>

