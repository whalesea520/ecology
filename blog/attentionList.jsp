
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.AppItemVo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.blog.BlogDiscessVo"%>
<%@page import="weaver.blog.BlogReplyVo"%>
<%@page import="weaver.blog.AppDao"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>

<%
    String userid=""+user.getUID();
	String workDate=Util.null2String(request.getParameter("workDate"));
    String blogType = Util.null2String(request.getParameter("blogType"));
    String name = Util.null2String(request.getParameter("name"));
    BlogManager blogManager=new BlogManager(user);
    SimpleDateFormat datefrm=new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat monthDayFormater=new SimpleDateFormat("M月dd日");
    SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    Map map=blogManager.getAttentionDiscussMap(""+user.getUID(),workDate); 
    
    Date today=new Date();
	long   todaytime=datefrm.parse(datefrm.format(today)).getTime(); 
	long   worktime=datefrm.parse(workDate).getTime(); 

	long sepratorday=(todaytime-worktime)/(24*60*60*1000);
	
    
    List resultList=(List)map.get("resultList");
    Map  discussMap=(Map)map.get("discussMap");
    
   	BlogDao blogDao=new BlogDao();
    AppDao appDao=new AppDao();
    boolean moodIsActive=appDao.getAppVoByType("mood").isActive();
    
    //周一 周二 周三 周四 周五 周六 周日
    String []week={SystemEnv.getHtmlLabelName(16106,user.getLanguage()),SystemEnv.getHtmlLabelName(16100,user.getLanguage()),SystemEnv.getHtmlLabelName(16101,user.getLanguage()),SystemEnv.getHtmlLabelName(16102,user.getLanguage()),SystemEnv.getHtmlLabelName(16103,user.getLanguage()),SystemEnv.getHtmlLabelName(16104,user.getLanguage()),SystemEnv.getHtmlLabelName(16105,user.getLanguage())};
%>
<table width="100%" style="TABLE-LAYOUT: fixed;">
  <tr>
  <td valign="top" width="75px" nowrap="nowrap">
     <div class="dateArea">
				<%if(workDate.equals(datefrm.format(new Date()))){ %>
					<div class="day"><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></div><!-- 今天 -->
				<%} else{%>
					<div class="day"><%=week[datefrm.parse(workDate).getDay()] %></div>
				<%
					
				} %>			
				<div class="yearAndMonth"><%=monthDayFormater.format(datefrm.parse(workDate)) %></div>
     </div>
     <%if(sepratorday<7){ %>
	     <div style="width: 100%;text-align: center;cursor: pointer;" onclick="unSumitRemindAll(this,<%=user.getUID()%>,'<%=workDate%>')">
	        <a><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())+SystemEnv.getHtmlLabelName(26928,user.getLanguage())%></a><!-- 全部提醒 -->
	     </div>				
     <%} %>
  </td>
  <td valign="top" style="padding-top: 4px">
  <div class="listArea">
<% for(int i=0;i<resultList.size();i++){ 
	String attentionid=(String)resultList.get(i);
	BlogDiscessVo discessVo=(BlogDiscessVo)discussMap.get(attentionid);
	String discussid=discessVo.getId();
	//attentionid=discessVo.getUserid();
%>
	<%if(discussid!=null) {
	%>
	<div class="reportItem" userid="<%=discessVo.getUserid()%>" forDate="<%=discessVo.getWorkdate() %>" id="<%=discessVo.getId()%>" tid="<%=discessVo.getId() %>" style="margin-bottom: 10px;float: left;width: 100%">
           <div class="discussView">
			<div class="sortInfo">
			  <span style="float: left;">
				<span class="name">&nbsp;<a href="viewBlog.jsp?blogid=<%=discessVo.getUserid() %>" target="_blank"><%=ResourceComInfo.getLastname(discessVo.getUserid())  %></a>&nbsp;</span>
				<%if("0".equals(discessVo.getIsReplenish())){ %>
						<div class="state ok"></div>
						<span class="datetime">
							<%=SystemEnv.getHtmlLabelName(26924,user.getLanguage())%>:<%=discessVo.getCreatedate()+" "+discessVo.getCreatetime() %>&nbsp;<!-- 提交于 -->
						</span>
					<%}else { %>
						<div class="state after"></div>
						<span class="datetime">
							<%=SystemEnv.getHtmlLabelName(26925,user.getLanguage())%>:<%=discessVo.getCreatedate()+" "+discessVo.getCreatetime() %>&nbsp;<!-- 补交于 -->
						</span>
					<%} %>
					<!-- 上级评分 -->
						<span style='width: 100px' score='<%=discessVo.getScore()%>' readOnly='<%=!(""+user.getUID()).equals(ResourceComInfo.getManagerID(attentionid))%>' discussid='<%=discussid%>' target='blog_raty_keep_<%=discussid%>' class='blog_raty' id='blog_raty_<%=discussid%>'></span>
				<!-- 心情 -->	
				<%if(moodIsActive){ 
					AppItemVo  appItemVo=appDao.getappItemByDiscussId(discussid);
					if(appItemVo!=null){
				%>
					<img style="margin-left: 2px;margin-right: 2px" width="16px" src="<%=appItemVo.getFaceImg()%>" alt="<%=SystemEnv.getHtmlLabelName(Util.getIntValue(appItemVo.getItemName()),user.getLanguage())%>"/>
				<%}} %>
				</span>
				<span class="sortInfoRightBar" >
				  <a href="javascript:void(0)" onclick="showReplySubmitBox(this,'<%=discessVo.getId() %>',{'uid':'<%=user.getUID() %>','level':'0'},0)"><%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%></a><!-- 评论 -->
				  <a href="javascript:void(0)" onclick="showReplySubmitBox(this,'<%=discessVo.getId() %>',{'uid':'<%=user.getUID() %>','level':'0'},1)"><%=SystemEnv.getHtmlLabelName(83151,user.getLanguage())%></a><!-- 私评 -->
				</span>
			</div>
			<div class="clear reportContent">
				<%=discessVo.getContent() %>
			</div>
			<%
			List replayList2=blogDao.getReplyList(discessVo.getUserid(),discessVo.getWorkdate(),userid); 
			if(replayList2.size()>0){
			%>
			<!-- 回复 -->
			<div class="reply" > 
				<%
				BlogReplyVo replyVo=new BlogReplyVo();
				for(int j=0;j<replayList2.size();j++){
					replyVo=(BlogReplyVo)replayList2.get(j);
					
					String replyComefrom=replyVo.getComefrom();
					String commentType=replyVo.getCommentType();
					String replyComefromTemp="";
					if(!replyComefrom.equals("0")||commentType.equals("1"))
						   replyComefromTemp="(";
				    if(commentType.equals("1"))	
				    	   replyComefromTemp+=SystemEnv.getHtmlLabelName(83151,user.getLanguage());
				    	
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
						<div class="state re"></div>
						<span class="datetime">
							<%=replyVo.getCreatedate()+" " + replyVo.getCreatetime()%>&nbsp;<!-- 评论于 -->
							<span class="comefrom"><%=replyComefromTemp%></span>
						</span>
						<span class="sortInfoRightBar">
							<%if((""+user.getUID()).equals(replyVo.getUserid())&&j==replayList2.size()-1){
								long sepratorTime=(today.getTime()-dateFormat.parse(replyVo.getCreatedate()+" "+replyVo.getCreatetime()).getTime())/(1000*60);
								if(sepratorTime<=10){
							%>
								<a href='javascript:void(0)' class='deleteOperation' onclick="deleteDiscuss(this,<%=discussid%>,'<%=replyVo.getId()%>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!-- 删除 -->
							<%}} %>
							<a href="javascript:void(0)"  onclick="showReplySubmitBox(this,'<%=discussid%>',{'uid':'<%=replyVo.getUserid()%>','name':'<%=ResourceComInfo.getLastname(replyVo.getUserid())%>','level':'1','replyid':'<%=replyVo.getId() %>'},0)"><%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%></a><!-- 评论 -->
						    <a href="javascript:void(0)"  onclick="showReplySubmitBox(this,'<%=discussid%>',{'uid':'<%=replyVo.getUserid()%>','name':'<%=ResourceComInfo.getLastname(replyVo.getUserid())%>','level':'1','replyid':'<%=replyVo.getId() %>'},1)">私评</a><!-- 私评 -->
						</span>
					</div>
					<div class="clear reportContent">
						<%=replyVo.getContent()%>
					</div>
				</div>
				<%if(j<replayList2.size()-1){%>
				  <div class="dotedline"></div>
				<%} %>
			<%} %>
			</div>
	<%} %>
	</div>
	<div class="commitBox"></div>
</div>
<%}else{ %>
<div class="reportItem" tid="0" userid="<%=discessVo.getUserid()%>" forDate="<%=discessVo.getWorkdate() %>" style="margin-bottom:6px;">
    <div class="discussView">
		<div class="sortInfo" style="height: 20px;float: none;">
		 <span>
			<span class="name">&nbsp;<a href="viewBlog.jsp?blogid=<%=attentionid %>" target="_blank"><%=ResourceComInfo.getLastname(attentionid) %></a>&nbsp;</span>
			<div class="state no"></div>
			<span class="unSumit">
				&nbsp;<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%>&nbsp;<!-- 未提交 -->
			</span>
		</span>
		<span class="sortInfoRightBar">
			<%if(sepratorday<7){ %>
				<span class="unSumitRemind" attentionid="<%=attentionid%>" style="cursor: pointer" onclick="unSumitRemind(this,<%=attentionid%>,<%=user.getUID()%>,'<%=workDate%>');">
					<a class="remindOperation"><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%></a><!-- 提醒 -->
				</span>
			<%} %>
			<a href="javascript:void(0)" onclick="showReplySubmitBox(this,0,{'uid':'<%=discessVo.getUserid()%>','level':'0'},0)"><%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%></a><!-- 评论 -->
			<a href="javascript:void(0)" onclick="showReplySubmitBox(this,0,{'uid':'<%=discessVo.getUserid()%>','level':'0'},1)"><%=SystemEnv.getHtmlLabelName(83151,user.getLanguage())%></a><!-- 私评 -->
		</span>
	</div>
	<div class="clear reportContent"></div>
		<%
			List replayList2=blogDao.getReplyList(discessVo.getUserid(),discessVo.getWorkdate(),userid); 
			if(replayList2.size()>0){
			%>
			<!-- 回复 -->
			<div class="reply" > 
				<%
				BlogReplyVo replyVo=new BlogReplyVo();
				for(int j=0;j<replayList2.size();j++){
					replyVo=(BlogReplyVo)replayList2.get(j);
					
					String replyComefrom=replyVo.getComefrom();
					String commentType=replyVo.getCommentType();
					String replyComefromTemp="";
					if(!replyComefrom.equals("0")||commentType.equals("1"))
						   replyComefromTemp="(";
						   
				    if(commentType.equals("1"))	
				    	   replyComefromTemp+=SystemEnv.getHtmlLabelName(83151,user.getLanguage());
				    	
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
						<span class="name">&nbsp;<a href="viewBlog.jsp?blogid=<%=replyVo.getUserid() %>"><%=ResourceComInfo.getLastname(replyVo.getUserid())%></a>&nbsp;</span>
						<div class="state re"></div>
						<span class="datetime">
							<%=replyVo.getCreatedate()+" " + replyVo.getCreatetime()%>&nbsp;<!-- 评论于 -->
							<span class="comefrom"><%=replyComefromTemp%></span>
						</span>
						<span class="sortInfoRightBar">
							<%if((""+user.getUID()).equals(replyVo.getUserid())&&j==replayList2.size()-1){
								long sepratorTime=(today.getTime()-dateFormat.parse(replyVo.getCreatedate()+" "+replyVo.getCreatetime()).getTime())/(1000*60);
								if(sepratorTime<=10){
							%>
								<a href='javascript:void(0)' class='deleteOperation' onclick="deleteDiscuss(this,0,'<%=replyVo.getId()%>')"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><!-- 删除 -->
							<%}} %>
							<a href="javascript:void(0)"  onclick="showReplySubmitBox(this,0,{'uid':'<%=replyVo.getUserid()%>','name':'<%=ResourceComInfo.getLastname(replyVo.getUserid())%>','level':'1','replyid':'<%=replyVo.getId() %>'},0)"><%=SystemEnv.getHtmlLabelName(675,user.getLanguage())%></a><!-- 评论 -->
						    <a href="javascript:void(0)"  onclick="showReplySubmitBox(this,0,{'uid':'<%=replyVo.getUserid()%>','name':'<%=ResourceComInfo.getLastname(replyVo.getUserid())%>','level':'1','replyid':'<%=replyVo.getId() %>'},1)"><%=SystemEnv.getHtmlLabelName(83151,user.getLanguage())%></a><!-- 私评 -->
						</span>
					</div>
					<div class="clear reportContent">
						<%=replyVo.getContent()%>
					</div>
				</div>
				<%if(j<replayList2.size()-1){%>
				  <div class="dotedline"></div>
				<%} %>
			<%} %>
			</div>
	<%} %>
	<div class="commitBox"></div>
</div>
</div>
<%} %>
<div class="clear"></div>
<%}%>
</div>
</td>
</tr>
</table>
