
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="appDao" class="weaver.blog.AppDao"></jsp:useBean>
<%
	
  Calendar calendar=Calendar.getInstance();
  int currentMonth=calendar.get(Calendar.MONTH)+1;
  int currentYear=calendar.get(Calendar.YEAR);
  
  int isSignInOrSignOut=Util.getIntValue(request.getParameter("isSignInOrSignOut"),0);
  
  String userid=Util.null2String(request.getParameter("userid")); //需要查看的微博(用户)id
  int year=Util.getIntValue(request.getParameter("year"),currentYear);
  int month=Util.getIntValue(request.getParameter("month"),currentMonth);
  String monthStr=month<10?("0"+month):(""+month);
  
  BlogReportManager reportManager=new BlogReportManager();
  reportManager.setUser(user);
  Map blogResultMap=reportManager.getBlogReportByUser(userid,year,month); 
  Map moodResultMap=reportManager.getMoodReportByUser(userid,year,month); 

  List reportList=(List)blogResultMap.get("reportList");
  List moodReportList=(List)moodResultMap.get("reportList");
  
  List totaldateList=(List)blogResultMap.get("totaldateList");          //当月总的天数
  int totalWorkday=((Integer)blogResultMap.get("totalWorkday")).intValue();    //当月工作日总数
  int totalUnsubmit=((Integer)blogResultMap.get("totalUnsubmit")).intValue();  //微博未提交总数
  double workIndex=((Double)blogResultMap.get("workIndex")).doubleValue();        //工作指数
  double moodIndex=((Double)moodResultMap.get("moodIndex")).doubleValue();    //心情指数
%>
<table id="reportList" style="width:100%;;border-collapse:collapse;margin-top: 3px;table-layout: fixed"  border="1" cellspacing="0" bordercolor="#dfdfdf" cellpadding="2" >
	  <!-- 日期行  -->
	  <tr style="" height="20px">
	    <td style="width:75px;" nowrap="nowrap"></td>
	    <%
	      for(int i=0;i<totaldateList.size();i++){
	    	  int day=((Integer)totaldateList.get(i)).intValue();
	    	  if(i<reportList.size()){
	    		  Map map=(Map)reportList.get(i);
		    	  boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
		    	  if(isWorkday){
		%>
		      <td class="tdWidth" width="*" nowrap="nowrap"><%=day%></td>
		<%    		  
		    	  }
	    	  }else{
	    %>
	          <td class="tdWidth" width="*" nowrap="nowrap"><%=day%></td>
	    <%}}%>
        <td style="width:75px;max-width:85px;" align="center">
            <%=SystemEnv.getHtmlLabelName(129959,user.getLanguage())%>
            <span style="cursor:pointer;" title="<%=SystemEnv.getHtmlLabelNames("523,15191", user.getLanguage()) + " " + SystemEnv.getHtmlLabelNames("15178,355", user.getLanguage()) + "/" + SystemEnv.getHtmlLabelNames("26932,355", user.getLanguage())%>">
                <img src="/images/remind_wev8.png" align="absMiddle">
            </span>
        </td><!-- 总计 -->
	    <td style="width:150px;max-width:150px;" align="center"><%=SystemEnv.getHtmlLabelName(26960,user.getLanguage())%></td><!-- 指数 -->
	</tr>
	<!-- 日期行  -->
	
	<!-- 微博报表  -->
	<tr class="item1">
	    <td align="center"><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></td> <!-- 微博报表 -->
	    <%
	      for(int i=0;i<totaldateList.size();i++){
	    	if(i<reportList.size()){
	    	   Map map=(Map)reportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isSubmited=((Boolean)map.get("isSubmited")).booleanValue();
	    %>
	     <%if(isWorkday){%>
		    <td align="center" >
		       <%if(isSubmited){%>
		        <div><img src="images/submit-ok_wev8.png" /></div>
		       <%}else{ %>
		        <div><img src="images/submit-no_wev8.png" /></div> 
		       <%} %> 
		    </td>
		  <%}else{%>
		    
	    <%}}else{%>
	       <td >&nbsp;</td>
	    <%}
	    }%>
        <td align="center"><span style="color:red"><%=totalUnsubmit %></span>/<%=totalWorkday %></td>
	    <td><span title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%><%=totalUnsubmit%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%><%=totalWorkday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(workIndex)%></span><span style="font-weight: bold;margin-left: 3px;color: #666666"><%=workIndex%></span><a href="javascript:openChart('blog','<%=userid %>',<%=year%>,1,'<%=ResourceComInfo.getLastname(userid)%><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
		</tr>
		<!-- 微博报表  -->
		<%if(appDao.getAppVoByType("mood").isActive()) {%>
	<tr class="item1">
	    <td align="center"><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></td><!-- 心情报表 -->
	    
	    <%
	    int happyDays=((Integer)moodResultMap.get("happyDays")).intValue();
	    int unHappyDays=((Integer)moodResultMap.get("unHappyDays")).intValue();
	    for(int i=0;i<totaldateList.size();i++){ 
	    	if(i<reportList.size()){
	    	   Map map=(Map)moodReportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isSubmited=((Boolean)map.get("isSubmited")).booleanValue();
	    	   String faceImg=(String)map.get("faceImg");
	    	   if(isWorkday){
	    	   %>
	    		<td align="center"">
	    			 <%if(isSubmited&&!"".equals(faceImg)){%>
			        	<div><img src="<%=faceImg %>" /></div>
			       	<%}else{ %>
			        	
			       	<%} %> 
	    		</td>
	    		<%}else{ %>
	    		
	    		<%}}else{ %>
	    		<td>&nbsp;</td>
	    		<%} %>
	    	
	    <%} %>
        <td align="center"><span style="color:red"><%=unHappyDays %></span>/<%=totalWorkday %></td>
	    <td><span title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%><%=unHappyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%><%=happyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(moodIndex)%></span><span style="font-weight: bold;margin-left: 3px;color: #666666"><%=moodIndex%></span><a href="javascript:openChart('mood','<%=userid%>',<%=year%>,1,'<%=ResourceComInfo.getLastname(userid)%><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	 </tr>
	 <%} 
	  if(isSignInOrSignOut==1){
		  Map schedulrResultMap=reportManager.getScheduleReportByUser(userid,year,month); 
		  List scheduleReportList=(List)schedulrResultMap.get("reportList"); 
		  double scheduleIndex=((Double)schedulrResultMap.get("scheduleIndex")).doubleValue();    //考勤指数
		  int totalAbsent=((Integer)schedulrResultMap.get("totalAbsent")).intValue();        //旷工总天数
		  int totalLate=((Integer)schedulrResultMap.get("totalLate")).intValue();            //迟到总天数
	 %>
	<tr class="item1">
	    <td align="center"><%=SystemEnv.getHtmlLabelName(15880 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></td><!-- 考勤报表 -->
	    <%for(int i=0;i<totaldateList.size();i++){ 
	    	if(i<reportList.size()){
	    	   Map map=(Map)scheduleReportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isLate=((Boolean)map.get("isLate")).booleanValue();
	    	   boolean isAbsent=((Boolean)map.get("isAbsent")).booleanValue();
	    	   if(isWorkday){
	    	   %>
	    		<td align="center">
	    			 <%if(isLate){%>
			        	<div><img width="18px" src="images/sign-no_wev8.png"/></div>
			       	<%}else if(isAbsent){ %>
			        	<div><img width="18px"  src="images/sign-absent_wev8.png"/></div>
			       	<%}else { %> 
			       	    <div><img width="18px"  src="images/sign-ok_wev8.png" /></div>
			       	<%} %>
	    		</td>
	    		<%}else{ %>
	    		
	    		<%}}else{ %>
	    		<td>&nbsp;</td>
	    		<%} %>
	    	
	    <%} %>
        <td align="center"><span style="color:red"><%=(totalAbsent + totalLate) %></span>/<%=totalWorkday %></td>
	    <td><span title="<%=SystemEnv.getHtmlLabelName(20085,user.getLanguage())%><%=totalAbsent%><%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(20081,user.getLanguage())%><%=totalLate %><%=SystemEnv.getHtmlLabelName(18083,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18609,user.getLanguage())%><%=totalWorkday%><%=SystemEnv.getHtmlLabelName(20079,user.getLanguage())%>"><%=reportManager.getReportIndexStar(scheduleIndex)%></span><span style="font-weight: bold;margin-left: 3px;color: #666666"><%=scheduleIndex%></span><a href="javascript:openChart('schedule','<%=userid%>',<%=year%>,1,'<%=ResourceComInfo.getLastname(userid)%><%=SystemEnv.getHtmlLabelName(15880 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
	<%} %>
 </table> 

<script>
jQuery(function(){
	jQuery("img[src='images/chart_wev8.png']").mouseover(function(){
		jQuery(this).attr("src","images/chart-on_wev8.png");
	}).mouseout(function(){
		jQuery(this).attr("src","images/chart_wev8.png");
	});
});


</script>