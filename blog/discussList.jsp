
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.TimeUtil"%>
<%@page import="weaver.blog.bean.BlogZanBean"%>
<%@page import="weaver.blog.bean.BlogZanPo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.blog.AppItemVo"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.BlogReplyVo"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.AppDao"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="blogDao" class="weaver.blog.BlogDao"></jsp:useBean> 
<jsp:useBean id="taskUtil" class="weaver.task.TaskUtil"></jsp:useBean>
<%
String blogid=Util.null2String(request.getParameter("blogid"));  //微博id
String userid=""+user.getUID();
String fromPage=Util.null2String(request.getParameter("page"));
String startDate=Util.null2String(request.getParameter("startDate"));
String endDate=Util.null2String(request.getParameter("endDate"));
String requestType=Util.null2String(request.getParameter("requestType")); //请求类型
String ac=Util.null2String(request.getParameter("ac"));                   //查询来自页面
String content=Util.null2String(request.getParameter("content")).replace("'","''");         //搜索内容
String submitdate=Util.null2String(request.getParameter("submitdate"));  //提交时间分割线，最后显示时间

String attentionWorkDate=Util.null2String(request.getParameter("workDate"));//我的关注，指定工作日

int currentpage=Util.getIntValue(request.getParameter("currentpage"),1);  //页数
int pagesize=Util.getIntValue(request.getParameter("pagesize"),20);       //每页显示条数
int total=Util.getIntValue(request.getParameter("total"),0);              //每页显示条数

int minUpdateid=Util.getIntValue(request.getParameter("minUpdateid"),0);  //存贮已经取出来的更新提醒最小id

String isFirstPage=Util.null2String(request.getParameter("isFirstPage")); //我的微博页面判断是否为第一页，第一页才返回编辑器

String groupid=Util.null2String(request.getParameter("groupid"));  //微博分组id
groupid=groupid.equals("")?"all":groupid;

BlogManager blogManager=new BlogManager(user);

if("".equals(blogid)){
	blogid=""+user.getUID();
}else{
	BlogShareManager shareManager=new BlogShareManager();
	int status=shareManager.viewRight(blogid,userid); //微博查看权限
	if(status<=0){
	  return ;	
	}
}

SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
SimpleDateFormat dateFormat1=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFormat2=new SimpleDateFormat("M月dd日");
SimpleDateFormat dateFormat3=new SimpleDateFormat("yyyy年M月d日 HH:mm");
SimpleDateFormat timeFormat=new SimpleDateFormat("HH:mm");

Date today=new Date();
String todaydate=dateFormat1.format(today);
String curDate=dateFormat1.format(today);
//submitdate=submitdate.equals("")?curDate:submitdate;  //提交日期

int isNeedSubmit=0;
int todayIsReplayed=0; //今天是否被评论过，如果被评论过就显示今天内容

BlogDiscessVo discessVo;
//检查当前用户 当天是否需要提交
if(!isFirstPage.equals("false")&&userid.equals(blogid)&&requestType.equals("myblog")){
   isNeedSubmit=blogDao.isNeedSubmit(user,curDate);
   if(blogDao.getReplyList(userid,curDate,userid).size()>0)
		todayIsReplayed=1;
}

String isManagerScore=blogDao.getSysSetting("isManagerScore");  //启用上级评分
int blog_makeUpTime = Util.getIntValue(blogDao.getSysSetting("makeUpTime"));   //微博可补交天数
int blog_canEditTime = Util.getIntValue(blogDao.getSysSetting("canEditTime"));  //微博可编辑天数

Date startdateTemp=new Date();
String enableDate="";
String startTmep="";
String endTemp="";
Map conditions=new HashMap();
int totalpage=0;
List updateList=new ArrayList();   //获得更新提醒id list
List discussList=new ArrayList();  //微博记录list
Map  discussMap=null;
if(requestType.equals("homepage")){      //获取微博主页数据总数
	List attentionList=blogManager.getMyAttention(userid,groupid);
	String attentionids="";                                 //所有我关注的人集合,包含自身
	for(int i=0;i<attentionList.size();i++){
		attentionids=attentionids+","+attentionList.get(i);
	}
	if(groupid.equals("all"))
		attentionids+=","+userid;
	attentionids=attentionids.length()>0?attentionids.substring(1):"-9999";
	conditions.put("attentionids",attentionids);
	if(total==0){
		total=blogDao.getBlogDiscussCount(conditions);
	}
	totalpage=total%pagesize==0?total/pagesize:total/pagesize+1;
	
	updateList=blogDao.getUpdateDiscussidList(userid);
	discussList=blogManager.getBlogDiscussVOList(userid,currentpage, pagesize,total,conditions);
}else if(requestType.equals("myblog")){  //我的微博分页
    
    BlogShareManager shareManager=new BlogShareManager();

    if(userid.equals(blogid) || shareManager.isManager(userid, blogid) || shareManager.isAttentionRelationship(userid, blogid)) {
    	enableDate=blogDao.getUserBlogStartdate(blogid); //微博启用时间
    } else {
        enableDate = shareManager.getBlogCanViewMinTime(userid, blogid);
    }
    //System.out.println("userid.equals(blogid)=" + userid.equals(blogid));
    //System.out.println("shareManager.isManager(userid, blogid)=" + shareManager.isManager(userid, blogid));
    //System.out.println("shareManager.isAttentionRelationship(userid, blogid)=" + shareManager.isAttentionRelationship(userid, blogid));
    //System.out.println("enableDate="+enableDate);
    
	if("".equals(endDate)){
		Date endDateTmp=new Date();
		if(isNeedSubmit!=0||!userid.equals(blogid)||todayIsReplayed==1)  //访问其他用户的微博不显示今天
			endDateTmp.setDate(endDateTmp.getDate());
		else
			endDateTmp.setDate(endDateTmp.getDate()-1);
		endDate=dateFormat1.format(endDateTmp);
		
		startdateTemp=endDateTmp;
		startdateTemp.setDate(endDateTmp.getDate()-pagesize);
		startDate=dateFormat1.format(startdateTemp);
	}else{
		startdateTemp=dateFormat1.parse(endDate);
		startdateTemp.setDate(startdateTemp.getDate()-pagesize);
	}
	if(dateFormat1.parse(enableDate).getTime()>startdateTemp.getTime()){
		startDate=enableDate;
	}else{
		startDate=dateFormat1.format(startdateTemp);
	}
	
	discussList=blogManager.getDiscussListAll(blogid,startDate,endDate);
}else if(requestType.equals("commentOnMe")){    //评论我的
	if(total==0){
		total=blogDao.getCommentTotal(userid);
	}
	
	totalpage=total%pagesize==0?total/pagesize:total/pagesize+1;
	discussList=blogDao.getCommentDiscussVOList(userid,currentpage,pagesize,total);
}else if(requestType.equals("homepageNew")){   //更新数字提醒
	updateList=blogDao.getUpdateDiscussidList(userid);
	if(minUpdateid==0){
		minUpdateid=blogDao.getUpdateMaxRemindid(userid)+1;
	}
	Map map=blogDao.getUpdateDiscussVOList(userid, pagesize,minUpdateid);
	discussList=(List)map.get("discussList");
	minUpdateid=((Integer)map.get("maxUpdateid")).intValue();
}else if(requestType.equals("search")){       //通过搜索
	enableDate=blogDao.getUserBlogStartdate(userid);    //微博启用时间
	endDate=endDate.equals("")?curDate:endDate;
	endDate=TimeUtil.dateInterval(curDate,endDate)>0?curDate:endDate;
	endDate=dateFormat1.parse(enableDate).getTime()>dateFormat1.parse(endDate).getTime()?enableDate:endDate;
	
	if(startDate.equals("")){
		startdateTemp=dateFormat1.parse(endDate);
		startdateTemp.setDate(dateFormat1.parse(endDate).getDate()-30);
		startDate=dateFormat1.format(startdateTemp);
	}
	startDate=dateFormat1.parse(enableDate).getTime()>dateFormat1.parse(startDate).getTime()?enableDate:startDate;
	startdateTemp=dateFormat1.parse(endDate);
	startdateTemp.setDate(startdateTemp.getDate()-(currentpage-1)*pagesize-(currentpage-1));
	  
	endTemp=dateFormat1.format(startdateTemp);
	
	startdateTemp.setDate(startdateTemp.getDate()-pagesize);
	startTmep=dateFormat1.format(startdateTemp);
	
	endTemp=dateFormat1.parse(endTemp).getTime()<dateFormat1.parse(startDate).getTime()?startDate:endTemp;
	startTmep=dateFormat1.parse(startTmep).getTime()<dateFormat1.parse(startDate).getTime()?startDate:startTmep;
	
	if("myBlog".equals(ac)||"user".equals(ac)){
		 if("".equals(content))
		    discussList=blogManager.getDiscussListAll(blogid,startTmep,endTemp);
		 else{
			conditions.put("attentionids",blogid);  //我的微博查询 只有微博所属人自身
		    conditions.put("endDate",endDate);
			conditions.put("startDate",startDate);
			conditions.put("content",content);
			if(total==0){
				total=blogDao.getBlogDiscussCount(conditions);
			}
			totalpage=total%pagesize==0?total/pagesize:total/pagesize+1;
			discussList=blogManager.getBlogDiscussVOList(userid,currentpage, pagesize,total,conditions);
		 }
	}
	
	if("homepage".equals(ac)||"gz".equals(ac)){ //微博主页  我的关注页面搜索
		List attentionList=blogManager.getMyAttention(""+user.getUID(),groupid);
		 String attentionids=userid; //包含自身
		 for(int i=0;i<attentionList.size();i++){
			 attentionids=attentionids+","+attentionList.get(i);
		 } 
		conditions.put("attentionids",attentionids); 
		conditions.put("endDate",endDate);
		conditions.put("startDate",startDate);
		conditions.put("content",content);
		if(total==0){
			total=blogDao.getBlogDiscussCount(conditions);
		}
		totalpage=total%pagesize==0?total/pagesize:total/pagesize+1;
		discussList=blogManager.getBlogDiscussVOList(userid,currentpage, pagesize,total,conditions);
	}
}else if(requestType.equals("attentionList")){
	Map map=blogManager.getAttentionDiscussMap(""+user.getUID(),attentionWorkDate);
	discussList=(List)map.get("resultList");
	discussMap=(Map)map.get("discussMap");
}

AppDao appDao=new AppDao();
boolean moodIsActive=appDao.getAppVoByType("mood").isActive();
//周日 周一 周二 周三 周四 周五 周六 
String []week={SystemEnv.getHtmlLabelName(16106,user.getLanguage()),SystemEnv.getHtmlLabelName(16100,user.getLanguage()),SystemEnv.getHtmlLabelName(16101,user.getLanguage()),SystemEnv.getHtmlLabelName(16102,user.getLanguage()),SystemEnv.getHtmlLabelName(16103,user.getLanguage()),SystemEnv.getHtmlLabelName(16104,user.getLanguage()),SystemEnv.getHtmlLabelName(16105,user.getLanguage())};

//今天显示条件： 今天是否填写  是否为当前用户查看 第一次取列表显示  来自于微博查看菜单或者主页查看菜单
if(isNeedSubmit!=3&&userid.equals(blogid)&&requestType.equals("myblog")&&!isFirstPage.equals("false")){
%>
 <div class="reportItem" style="padding-top:8px;position:relative;" tid="0" forDate="<%=curDate%>" isToday="true" isNeedSubmit="<%=isNeedSubmit%>"> 
				<table width="100%" cellpadding="0" cellspacing="0">
					<colgroup>
						<col width="60px;">
					</colgroup>
					<tr>
						<td valign="top" style="height:100%">
							<div style="height:100%;">
								<div class="todayArea">
									<div class="day"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></div><!-- 今天 -->
								</div>
								<div class="state today" title="<%=SystemEnv.getHtmlLabelName(26924,user.getLanguage())%>"></div> <!-- 提交于 -->
								<div class="discussline"></div>
							</div>
						</td>
						<td valign="top" style="height:100%">
								<div class="discussView" style="display: none;"></div>
								<div class="editor" style="display:block;"></div>
						</td>
					</tr>
				</table>
	</div>
<%} %>

<%
//获取今天以前的记录
if(discussList.size()>0){
for(int i=0;i<discussList.size();i++){
	if(requestType.equals("attentionList")){
		String attentionid=(String)discussList.get(i);
		discessVo=(BlogDiscessVo)discussMap.get(attentionid);
	}else
		discessVo=(BlogDiscessVo)discussList.get(i);
	if(discessVo==null)
		continue;
	String discussid=discessVo.getId();
	String workdate=discessVo.getWorkdate();
	String showdate=workdate;
	long   todaytime=today.getTime(); 
	long   worktime=dateFormat1.parse(workdate).getTime(); 
	//获取某个工作日到今天已经几天了
	long daysFromWorkDate=(todaytime-worktime)/(24*60*60*1000);
	
	String managerstr=ResourceComInfo.getManagersIDs(discessVo.getUserid());
	String createdate="";
	if(discussid!=null)
		createdate=discessVo.getCreatedate();
	else
		createdate=attentionWorkDate;
%>

<%
//提交时间分割线
boolean isShowDate=false;
if(((requestType.equals("homepage")||requestType.equals("homepageNew")||requestType.equals("attentionList"))&&!createdate.equals(submitdate))){
	if(requestType.equals("attentionList")) //关注列表按照工作日显示，而不是按照提交日期显示
		submitdate=workdate;
	else
		submitdate=createdate;
	Date dateTemp=new Date();
	dateTemp.setDate(dateTemp.getDate()-1);
	String yesterday=dateFormat1.format(dateTemp);      //昨天
	dateTemp.setDate(dateTemp.getDate()-1);
	String beforeyesterday=dateFormat1.format(dateTemp);//前天
	String weekday=week[dateFormat1.parse(submitdate).getDay()];
	
	if(submitdate.equals(yesterday))
		weekday=SystemEnv.getHtmlLabelName(82640,user.getLanguage());
	else if(submitdate.equals(beforeyesterday))
		weekday=SystemEnv.getHtmlLabelName(83169,user.getLanguage());
	isShowDate=true;
	showdate=submitdate;
	
	if(!requestType.equals("attentionList")){
%>
	<div class="seprator" id="seprator_<%=submitdate%>" _top="0" onmouseover="$(this).attr('_top',$(this).offset().top);">
	    <div class="bg_1" align="center">
	        <div class="bg_2"><%=SystemEnv.getHtmlLabelName(83170,user.getLanguage())%><%=dateFormat2.format(dateFormat1.parse(submitdate))%> <%=weekday%> <%=SystemEnv.getHtmlLabelName(83171,user.getLanguage())%></div>
	    </div>
	</div>
<%	
	}
}

if(!requestType.equals("homepage")&&!requestType.equals("homepageNew")&&!requestType.equals("attentionList")){
	isShowDate=true;
}
%>


<%	
	if(discussid!=null){
		createdate=discessVo.getCreatedate();
		String createTime=discessVo.getCreatetime();
		long createDateTime=dateFormat.parse(createdate+" "+createTime).getTime();
		long daysFromCreateDate=(todaytime-createDateTime)/(24*60*60*1000); //计算提交时间与当前时间间隔 
		discussid=discessVo.getId();
		boolean isCanEdit=userid.equals(discessVo.getUserid())&&(requestType.equals("myblog")) && (blog_canEditTime == -1 || daysFromCreateDate < blog_canEditTime);
		String comefrom=discessVo.getComefrom();
		String comefromTemp="";
		if(comefrom.equals("1"))  
			comefromTemp="("+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Iphone)";
		else if(comefrom.equals("2"))  
			comefromTemp="("+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Ipad)";
		else if(comefrom.equals("3"))  
			comefromTemp="("+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Android)";          
		else if(comefrom.equals("4"))  
			comefromTemp="("+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+SystemEnv.getHtmlLabelName(31506,user.getLanguage())+")";
	    else
	    	comefromTemp="";       	
		AppItemVo  appItemVo=null;
		if(moodIsActive)
		  appItemVo=appDao.getappItemByDiscussId(discussid); 
		
		boolean unRead=updateList.contains(discussid);
			
%>


<div class="reportItem" userid="<%=discessVo.getUserid()%>" id="<%=discussid%>" tid="<%=discussid%>" forDate="<%=workdate%>"  <%=moodIsActive&&appItemVo!=null?"appItemId="+appItemVo.getId():""%>  isTodayItem="<%=i==0&&todaydate.equals(workdate)?"true":"false"%>" isToday="false" <%if(requestType.equals("homepage")||requestType.equals("homepageNew")){%><%if(unRead){%> isRead="false"<%}%> onmouseover="readDiscuss(this,<%=discussid%>,<%=discessVo.getUserid()%>)" onmouseout="moveout(this)"<%}%>> 
<table width="100%" style="TABLE-LAYOUT: fixed;" cellpadding="0" cellspacing="0">
	<tr>
		<td valign="top" width="70px" nowrap="nowrap">
			  <%if(requestType.equals("homepage")||requestType.equals("homepageNew")||(requestType.equals("search")&&!ac.equals("myBlog")&&!"user".equals(ac))){%>
			        <div class="dateArea" style="margin-top:0px;position: relative;">
			        	<!--<img width="50px" height="50px" src="<%=ResourceComInfo.getMessagerUrls(discessVo.getUserid())%>">-->
						<%=weaver.hrm.User.getUserIcon(discessVo.getUserid(),"width: 50px; height: 50px;cursor: pointer;line-height: 50px;border-radius:40px;margin-left: 10px;") %>
			        	<!--<div style="background:url('/blog/images/head_bg2_wev8.png');position: absolute;top:0px;left:10px;height:50px;width:50px;"></div>-->
			        </div>
			  <%}else{ %>
			  
			 	 <%if(isShowDate){%>
				  <div class="dateArea">
					  <%if(daysFromWorkDate<=7){%> <!-- 大于7天显示日期 -->
						  <%if(workdate.equals(todaydate)){ %>
								<div class="day"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></div><!-- 今天 -->
						  <%}else{%>
								<div class="day"><%=week[dateFormat1.parse(showdate).getDay()] %></div>
						  <%} %>
					  <%}else{ %>
						    <div class="yearAndMonth"><%=dateFormat2.format(dateFormat1.parse(showdate)) %></div>
					  <%}%>
					 </div>  	
				 <%} %>
				 	  
				 <div class="state <%="0".equals(discessVo.getIsReplenish())?"ok":"after"%>" title="<%=SystemEnv.getHtmlLabelName(("0".equals(discessVo.getIsReplenish())?26924:26925),user.getLanguage())%><%=dateFormat3.format(dateFormat.parse(discessVo.getCreatedate()+" "+discessVo.getCreatetime())) %>"></div> <!-- 补交于 -->
				 <div class="discussline" style="<%=isShowDate?"":"top:0px;"%>"></div>    
			
			<%}%>
		</td>
		<td valign="top" class="item_td">
			<div class="discussitem">
			<div class="discussView">
			<div class="sortInfo">
			   <div style="float: left;">
					<div class="name">&nbsp;<a href="viewBlog.jsp?blogid=<%=discessVo.getUserid() %>" target="_blank"><%=ResourceComInfo.getLastname(discessVo.getUserid())  %></a>&nbsp;</div>
					<%if(moodIsActive&&appItemVo!=null&&appItemVo.getFaceImg()!=null&&!"".equals(appItemVo.getFaceImg())){ %>
						<div class="left">
							<img id="moodIcon" style="margin-left: 2px;margin-right: 2px;" width="16px" src="<%=appItemVo.getFaceImg()%>" alt="<%=SystemEnv.getHtmlLabelName(Util.getIntValue(appItemVo.getItemName()),user.getLanguage())%>"/>
						</div>
					<%} %>
					<!-- 未读标记 -->
					<%if(unRead){%>    
						<div class="left">
					    	<img src="/images/BDNew_wev8.gif" id="new_<%=discussid%>">
					    </div>
					<%}%>
					<div class="clear"></div>
				</div>
				<div class="sortInfoRightBar" >
					<!-- 上级评分 -->
					<%if(isManagerScore.equals("1")){%>
					   <span  style='width: 100px' score='<%=discessVo.getScore()%>' readOnly='<%=!(""+user.getUID()).equals(ResourceComInfo.getManagerID(discessVo.getUserid()))%>' discussid='<%=discussid%>' target='blog_raty_keep_<%=discussid%>' class='blog_raty' id='blog_raty_<%=discussid%>'></span>
				    <%} %>
				</div>
				<div class="clear"></div>
			</div>
			<div class="clear reportContent" tid="<%=discussid%>"> 
				<%=discessVo.getContent() %>
			</div>
			<%if("1".equals(discessVo.getIsHasLocation())){%>
			<div class='locationdiv'>
				<span class='location' onclick='showLocation(<%=discussid%>)'><%=SystemEnv.getHtmlLabelName(83161,user.getLanguage())%></span>&nbsp;&nbsp;<span class="comefrom"><%=comefromTemp%></span>
			</div>  
			<%}%>
			<%
			List replayList=blogDao.getReplyList(discessVo.getUserid(),workdate,userid); 
			if(replayList.size()>0){   
			%>
			<div class="reply" > 
				<%
				BlogReplyVo replyVo=new BlogReplyVo();
				int index=0;
				for(int j=0;j<replayList.size();j++){
					replyVo=(BlogReplyVo)replayList.get(j);
					
					String replyComefrom=replyVo.getComefrom();
					String commentType=replyVo.getCommentType();
					String replyComefromTemp="";
					if(!replyComefrom.equals("0")||commentType.equals("1"))
						   replyComefromTemp="(";
				    if(commentType.equals("1"))	
				    	   replyComefromTemp+="私评";
				    	
					if(replyComefrom.equals("1"))  
						replyComefromTemp+="&nbsp;"+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Iphone";
					else if(replyComefrom.equals("2"))  
						replyComefromTemp+="&nbsp;"+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Ipad)";
					else if(replyComefrom.equals("3"))  
						replyComefromTemp+="&nbsp;"+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Android";          
					else if(replyComefrom.equals("4"))  
						replyComefromTemp+="&nbsp;"+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Web"+SystemEnv.getHtmlLabelName(31506,user.getLanguage());
				         
					if(!replyComefrom.equals("0")||commentType.equals("1"))
						   replyComefromTemp+=")";
				%>
			  <div id="re_<%=replyVo.getId()%>">
				<div class="sortInfo replyTitle">
						<span class="name">&nbsp;<a href="viewBlog.jsp?blogid=<%=replyVo.getUserid() %>" target="_blank"><%=ResourceComInfo.getLastname(replyVo.getUserid())%></a>&nbsp;</span>
						<span class="datetime">
						    <%=dateFormat3.format(dateFormat.parse(replyVo.getCreatedate()+" "+replyVo.getCreatetime())) %>&nbsp;
						    <span class="comefrom"><%=replyComefromTemp%></span>
						</span>
						
						<div class="operations">
							<%if((""+user.getUID()).equals(replyVo.getUserid())&&j==replayList.size()-1){
								long sepratorTime=(today.getTime()-dateFormat.parse(replyVo.getCreatedate()+" "+replyVo.getCreatetime()).getTime())/(1000*60);
								if(sepratorTime<=10){
							%>
								<div class='deleteOperation left del' onclick="deleteDiscuss(this,<%=discussid%>,'<%=replyVo.getId()%>')" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></div><!-- 删除 -->
							<%}} %>
							<div class="left comment_s" title="<%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%>" onclick="showReplySubmitBox(this,'<%=discussid%>',{'uid':'<%=replyVo.getUserid()%>','name':'<%=ResourceComInfo.getLastname(replyVo.getUserid())%>','level':'1','replyid':'<%=replyVo.getId() %>'},0)"></div><!-- 评论 -->
							<div class="clear"></div>
							<!-- 评论 -->
							<!-- 
							<a href="javascript:void(0)"  onclick="showReplySubmitBox(this,'<%=discussid%>',{'uid':'<%=replyVo.getUserid()%>','name':'<%=ResourceComInfo.getLastname(replyVo.getUserid())%>','level':'1','replyid':'<%=replyVo.getId() %>'},1)">私评</a>
							 -->
						</div>
					</div>
					<div class="clear reportContent">
						<%=replyVo.getContent()%>
					</div>
				</div>
				<%if(j<replayList.size()-1){ %>
					<div class="dotedLine"></div>
				<%} %>
				<%} %>
				</div>
				<%} %>
				<div class="operationdiv" style="padding:5px 0px 8px 8px;">
					<%if((requestType.equals("homepage")||requestType.equals("homepageNew"))){%>
						<%if("0".equals(discessVo.getIsReplenish())){ %>
						   <div class="state ok left" style="position:inherit;margin-right:8px;" title="<%=SystemEnv.getHtmlLabelName(26924,user.getLanguage())%>"></div> <!-- 提交于 -->
						<%}else { %>
						    <div class="state after left " style="position:inherit;margin-right:8px;" title="<%=SystemEnv.getHtmlLabelName(26927,user.getLanguage())%> <%=dateFormat2.format(dateFormat1.parse(workdate))%> <%=week[dateFormat1.parse(discessVo.getWorkdate()).getDay()] %> <%=SystemEnv.getHtmlLabelName(26759,user.getLanguage())%>"></div> <!-- 补交于 -->
						<%} %>
					<%} %>
					<div class="left">
						<span class="datetime">
								<%=dateFormat3.format(dateFormat.parse(discessVo.getCreatedate()+" "+discessVo.getCreatetime())) %>&nbsp;
						</span>
					</div>
					<div class="operations right">
						<%if(isCanEdit){ %>
						<!-- 编辑 -->
					    <div class="edit left" title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>" onclick="editContent(this)"></div>
						<%} %>
						<%
							BlogZanBean blogZanBean = discessVo.getBlogZanBean();
							int isZan = blogZanBean.isZan(discussid,userid);
							if(isZan==1){
						%>
						<div id="zanFir_<%=discussid %>" class="zanSed left" title="取消赞"  tid="zan1" onclick="zanBlogMethod(this)"></div>
						<%		
							}else{	
						%>
						<div id="zanFir_<%=discussid %>" class="zan left" title="点赞" tid="zan0" onclick="zanBlogMethod(this)"></div>
						<%
							}
						%>
						<div class="comment left" title="<%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%>" onclick="showReplySubmitBox(this,<%=discussid%>,{'uid':'<%=user.getUID() %>','level':'0'},0)"></div>
						<%if(managerstr.indexOf(","+userid+",")!=-1||userid.equals(discessVo.getUserid())){%>
						 <div class="log left" title="<%=SystemEnv.getHtmlLabelName(83172,user.getLanguage())%>" _isload="0" _extend="0" onclick="showLog(this,<%=discessVo.getUserid()%>,'<%=workdate%>')"></div>
						<%}%>
					</div>
					<div class="clear"></div>
				</div>
				<div id="blogzan_<%=discussid%>">
				<%
					List zanPoList = blogZanBean.getBlogZanPoList();
					String zanHtml="";
					if(isZan==1 && "1".equals(blogZanBean.getZanCount())){
						zanHtml = "<div id='zanSed_"+discussid+"' class='blogZanThr'>"
						+"<span id='izan_"+discussid+"'>我</span><span><span id='zanThr_"+discussid+"'>1</span>人觉得很赞</span></div>";
						out.println(zanHtml);
					}else{
						if(zanPoList != null && zanPoList.size()>0){
							
							zanHtml="<div id='zanSed_"+discussid+"' class='blogZanThr'>";
							if(isZan==1){
								zanHtml += "<span id='izan_"+discussid+"'>我和</span>";
							}
							int intFlag=0;
							for(int k=0;k<zanPoList.size();k++){
								BlogZanPo blogZanPo=(BlogZanPo)zanPoList.get(k);
								if(userid.equals(blogZanPo.getZanHrmid())){
									if(k==zanPoList.size()-1 || k==14){
										zanHtml=zanHtml.substring(0,zanHtml.lastIndexOf("、"))+zanHtml.substring(zanHtml.lastIndexOf("、")+1);
									}
									continue;
								}
								if(k<15){
									zanHtml +="<span style='color:#007FCB;margin-right:2px;' id='hrm_"+blogZanPo.getZanHrmid()+"'>"+blogZanPo.getZanHrmname();
									if(k==zanPoList.size()-1 || k==14){
										zanHtml += "</span>";
									}else{
										zanHtml += "、</span>";
									}
								}else{
									intFlag=1;
									break;
								}
								
							}
							if(intFlag==1){
								zanHtml +="<span>等<span id='zanThr_"+discussid+"'>"+blogZanBean.getZanCount()+"</span>人觉得很赞</span><span onclick='getBlogZan("+discussid+",1)' class='blogZanFour_out'></span></div>";
							}else{
								zanHtml +="<span><span id='zanThr_"+discussid+"'>"+blogZanBean.getZanCount()+"</span>人觉得很赞</span></div>";
							}
							out.println(zanHtml);
						}
					}
					
				%>
				</div>
				<div class="logs" id="logs_<%=discessVo.getUserid()%>_<%=workdate%>"></div>
				</div>
				<div class="editor" tid="<%=discussid%>" style="display: none;"></div>
				<div class="commitBox"></div>
			   </div>
			</td>
		</tr>
	</table>
</div>
<%
	}else {
		%>
			<div class="reportItem" style="position:relative;" tid="0" unsubmit="true" userid="<%=discessVo.getUserid()%>" forDate="<%=workdate%>" isTodayItem="<%=i==0&&todaydate.equals(workdate)?"true":"false"%>" isToday="false" >
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top" width="70px" nowrap="nowrap">
							<%if(isShowDate){%>
							<div class="dateArea">
								<%if(daysFromWorkDate<=7){%> <!-- 大于7天显示日期 -->
									<%if(workdate.equals(todaydate)){ %>
										<div class="day"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></div><!-- 今天 -->
									<%}else{%>
										<div class="day"><%=week[dateFormat1.parse(showdate).getDay()] %></div>
									<%} %>
								<%}else{%>
									<div class="yearAndMonth"><%=dateFormat2.format(dateFormat1.parse(showdate)) %></div>
								<%}%>
							</div>
							<%}%>
							<div class="state no" style="<%=requestType.equals("attentionList")&&!isShowDate?"top:15px;":""%>" title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%>"></div>
							<div class="discussline" style="<%=isShowDate?"":"top:0px;"%>"></div>
						</td>
						<td valign="top">
							<div class="discussitem">
								<div class="discussView">
								<div class="sortInfo">
								    <span style="float: left;">
										<span class="name">&nbsp;<a href="viewBlog.jsp?blogid=<%=discessVo.getUserid()%>" target="_blank"><%=ResourceComInfo.getLastname(discessVo.getUserid()) %></a>&nbsp;</span>
									</span>
									<span class="sortInfoRightBar"  style="cursor: pointer;">
									   
									</span>
									<div class="clear"></div>
								</div>
								<div class="reportContent">
									<div style="margin-left:40%;margin-bottom:10px;padding-left:28px;height:24px;line-height:24px;background:url('/blog/images/blog_unsubmit_wev8.png') no-repeat left center;">
									<%=SystemEnv.getHtmlLabelNames("32555,26467",user.getLanguage())%>
									</div>
								</div>
								<%
								List replayList=blogDao.getReplyList(discessVo.getUserid(),workdate,userid);
								if(replayList.size()>0){
								%>
								<div class="reply" > 
									<%
									BlogReplyVo replyVo=new BlogReplyVo();
									int index=0;
									for(int j=0;j<replayList.size();j++){
										replyVo=(BlogReplyVo)replayList.get(j);
										
										String replyComefrom=replyVo.getComefrom();
										String commentType=replyVo.getCommentType();
										String replyComefromTemp="";
										if(!replyComefrom.equals("0")||commentType.equals("1"))
											   replyComefromTemp="(";
									    if(commentType.equals("1"))	
									    	   replyComefromTemp+="私评";
									    	
										if(replyComefrom.equals("1"))  
											replyComefromTemp+="&nbsp;"+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Iphone";
										else if(replyComefrom.equals("2"))  
											replyComefromTemp+="&nbsp;"+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Ipad)";
										else if(replyComefrom.equals("3"))  
											replyComefromTemp+="&nbsp;"+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Android";          
										else if(replyComefrom.equals("4"))  
											replyComefromTemp+="&nbsp;"+SystemEnv.getHtmlLabelName(31505,user.getLanguage())+"Web"+SystemEnv.getHtmlLabelName(31506,user.getLanguage())+"";
									         
										if(!replyComefrom.equals("0")||commentType.equals("1"))
											   replyComefromTemp+=")";
										
									%>
								  <div id="re_<%=replyVo.getId()%>">
									<div class="sortInfo replyTitle">
											<div class="name">&nbsp;<a href="viewBlog.jsp?blogid=<%=replyVo.getUserid() %>" target="_blank"><%=ResourceComInfo.getLastname(replyVo.getUserid())%></a>&nbsp;</div>
											<div class="datetime">
											    <%=dateFormat3.format(dateFormat.parse(replyVo.getCreatedate()+" "+replyVo.getCreatetime())) %>&nbsp;
											    <span class="comefrom"><%=replyComefromTemp%></span>
											</div> 
											
											<div class="operations left">
												<%if((""+user.getUID()).equals(replyVo.getUserid())&&j==replayList.size()-1){
													long sepratorTime=(today.getTime()-dateFormat.parse(replyVo.getCreatedate()+" "+replyVo.getCreatetime()).getTime())/(1000*60);
													if(sepratorTime<=10){
												%>
													<div class='deleteOperation left del' onclick="deleteDiscuss(this,0,'<%=replyVo.getId()%>')" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></div><!-- 删除 -->
												<%}} %>
												<div class="comment_s left"  title="<%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%>" onclick="showReplySubmitBox(this,0,{'uid':'<%=replyVo.getUserid()%>','name':'<%=ResourceComInfo.getLastname(replyVo.getUserid())%>','level':'1','replyid':'<%=replyVo.getId() %>'},0)"></div><!-- 评论 -->
												<div class="clear"></div>
											</div>
											<div class="clear"></div>
										</div>
										<div class="clear reportContent">
											<%=replyVo.getContent()%>
										</div>
									</div>
									<%if(j<replayList.size()-1){ %>
										<div class="dotedLine"></div>
									<%} 
									}%>
									</div>
									<%} %>
									
									<div class="operationdiv" style="padding:3px 0px 8px 8px;">
										<div class="left">
											<span class="datetime">
													
											</span>
										</div>
										<div class="operations right">
										   <%
											if(userid.equals(discessVo.getUserid()) && (blog_makeUpTime == -1 || daysFromWorkDate<=blog_makeUpTime)){
										   %>
										    <div class="edit left" onclick="showAfterSubmit(this);" title="<%=dateFormat1.format(today).equals(discessVo.getWorkdate())?SystemEnv.getHtmlLabelName(615,user.getLanguage()):SystemEnv.getHtmlLabelName(26927,user.getLanguage())%>"></div><!--提交 补交 -->
										  <%} else if(!userid.equals(discessVo.getUserid()) &&  (blog_makeUpTime == -1 || daysFromWorkDate<=blog_makeUpTime)){ %>
										    <div class="remind left" onclick="unSumitRemind(this,<%=discessVo.getUserid()%>,<%=user.getUID()%>,'<%=discessVo.getWorkdate()%>');" title="<%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>"></div><!-- 提醒 -->
										  <%}%>
										  	<div class="zan left" title="点赞" tid="zan0" onclick="zanBlogMethod(this)"></div>
										    <div class="comment left" onclick="showReplySubmitBox(this,0,{'uid':'<%=discessVo.getUserid()%>','level':'0'},0)" title="<%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%>"></div><!-- 评论 -->
										    <%if(managerstr.indexOf(","+userid+",")!=-1||userid.equals(discessVo.getUserid())){%>
								 			<div class="log left" title="<%=SystemEnv.getHtmlLabelName(83172,user.getLanguage())%>" _isload="0" _extend="0" onclick="showLog(this,<%=discessVo.getUserid()%>,'<%=workdate%>')"></div>
											<%}%>
										</div>
										<div class="clear"></div>
								  </div>
								  <div class="logs" id="logs_<%=discessVo.getUserid()%>_<%=workdate%>"></div>	
							</div>
							<div class="editor" style="display:none;" tid="0"></div>
							<div class="commitBox"></div>
						  </div>
						</td>
					</tr>
				</table>
			</div>
		<%
	}
  }
}%>

<%
String url="";
String haveNextPage="0";
if(requestType.equals("homepage")||requestType.equals("commentOnMe")){
	if(totalpage>1&&currentpage<totalpage){
		currentpage=currentpage+1;
		url="discussList.jsp?requestType="+requestType+"&currentpage="+currentpage+"&pagesize="+pagesize+"&total="+total+"&submitdate="+submitdate+"&groupid="+groupid;
		haveNextPage="1";
	}
}else if(requestType.equals("homepageNew")){
	if(minUpdateid>blogDao.getUpdateMinRemindid(userid)){
		url="/blog/discussList.jsp?requestType="+requestType+"&currentpage="+currentpage+"&pagesize="+pagesize+"&minUpdateid="+minUpdateid+"&submitdate="+submitdate;
		haveNextPage="1";
	}
}else if(requestType.equals("myblog")){
	startdateTemp.setDate(startdateTemp.getDate()-1);
	startDate=dateFormat1.format(startdateTemp); 
	if(startdateTemp.getTime()>=dateFormat1.parse(enableDate).getTime()){
		url="discussList.jsp?blogid="+blogid+"&requestType="+requestType+"&endDate="+startDate+"&isFirstPage=false";
		haveNextPage="1";
	}
}else if(requestType.equals("search")){
	if(("myBlog".equals(ac)||"user".equals(ac))){
		if(content.equals("")&&dateFormat1.parse(startDate).getTime()<startdateTemp.getTime()){
			currentpage=currentpage+1;
			url="discussList.jsp?blogid="+blogid+"&requestType="+requestType+"&startDate="+startDate+"&endDate="+endDate+"&content="+content+"&ac="+ac+"&currentpage="+currentpage;
			haveNextPage="1";
		}else if(totalpage>1&&currentpage<totalpage){
			currentpage=currentpage+1;
			url="discussList.jsp?blogid="+blogid+"&requestType="+requestType+"&startDate="+startDate+"&endDate="+endDate+"&content="+content+"&ac="+ac+"&currentpage="+currentpage+"&total="+total;
			haveNextPage="1";
		}
	}
	if(("homepage".equals(ac)||"gz".equals(ac))&&totalpage>1&&currentpage<totalpage){
		currentpage=currentpage+1;
		url="discussList.jsp?requestType="+requestType+"&startDate="+startDate+"&endDate="+endDate+"&content="+content+"&ac="+ac+"&currentpage="+currentpage+"&total="+total;
		haveNextPage="1";
	}
}
if(haveNextPage.equals("1")){
%>
<DIV id=moreList class=moreFoot onclick="getMore(this,'<%=url%>','<%=requestType%>','<%=content%>')" style="margin-bottom: 20px">
  <A hideFocus href="javascript:void(0)">
     <EM class=ico_load></EM><%=SystemEnv.getHtmlLabelName(17499,user.getLanguage())%><EM class="more_down"></EM>
  </A>
</DIV>
<%}else if(discussList.size()==0)
	out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
%>		
