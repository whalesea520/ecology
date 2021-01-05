
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.blog.BlogManager"%>

<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%><jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>

<%
  String userid=""+user.getUID();
  Calendar calendar=Calendar.getInstance();
  int currentMonth=calendar.get(Calendar.MONTH)+1;
  int currentYear=calendar.get(Calendar.YEAR);
  String type=Util.null2String(request.getParameter("type"));
  int year=Util.getIntValue(request.getParameter("year"),currentYear);
  int month=Util.getIntValue(request.getParameter("month"),currentMonth);
  String monthStr=month<10?("0"+month):(""+month);
  BlogReportManager reportManager=new BlogReportManager();
  reportManager.setUser(user);
  Map resultMap=new HashMap();
  int allUnsubmit=0;
  int allWorkday=0;
  double allWorkIndex=0;
  if("blog".equals(type)){
	  resultMap=reportManager.getBlogAttentionReport(userid,year,month);
	  allUnsubmit=((Integer)resultMap.get("allUnsubmit")).intValue();      //被关注人未提交总数
	  allWorkday=((Integer)resultMap.get("allWorkday")).intValue();      //被关注人未提交总数
	  allWorkIndex=((Double)resultMap.get("allWorkIndex")).doubleValue();      //被关注人未提交总数
  }else if("mood".equals(type)){
	  resultMap=reportManager.getMoodAttentionReport(userid,year,month);
  }else{
	  out.println(SystemEnv.getHtmlLabelName(83153,user.getLanguage()));
	  return;
  }
  List resultList=(List)resultMap.get("resultList");          //统计结果
  List totaldateList=(List)resultMap.get("totaldateList");          //当月总的天数
  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
  
  List isWorkdayList=(List)resultMap.get("isWorkdayList");    //有效日期统计list
  List resultCountList=(List)resultMap.get("resultCountList"); //有效日期统计list
  
  int total=resultList.size();
%>
	<div id="blogReportDiv" class="reportDiv" style="overflow-x: auto;width: 100%;">
	 <table id="reportList" style="width:100%;border-collapse:collapse;margin-top: 3px;margin-bottom: 40px;table-layout:fixed;"  border="1" cellspacing="0" bordercolor="#dfdfdf" cellpadding="2" >

 	<tr style="" height="20px">
 	
	    <td  class="tdWidth" style="width:75px;"   nowrap="nowrap"> 

	      <div style="float: left;">
	           <input type="checkbox"  onclick="selectBox(this)" title="<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>"/>  <!-- 全选 -->
	       </div>
	       <div style="float: left;">
			   <button class="submitButton" style="width:45px;" id="compareBtn" onclick="compareChart('blogReportDiv','<%=SystemEnv.getHtmlLabelName(26943,user.getLanguage())%>','<%=type %>')" type="button"><%=SystemEnv.getHtmlLabelName(26962,user.getLanguage())%></button>
		  </div>
	    </td>
	    <%
	   
	      for(int i=0;i<totaldateList.size();i++){
	    	  int day=((Integer)totaldateList.get(i)).intValue();
	    	  
	    	  if(i<isWorkdayList.size()){
	    		  boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    	  if(isWorkday){
		%>
		      <td class="tdWidth" width="*" nowrap="nowrap"><%=day%></td>
		<%    		  
		    	  }
	    	  }else{
	    %>
	          <td class="tdWidth" width="*" nowrap="nowrap"><%=day%></td>
	    <%}}%>
	    <td style="width:75px;max-width:85px;" align="center"><%=SystemEnv.getHtmlLabelName(129959,user.getLanguage())%></td> <!-- 总计 -->
	    <td style="width:150px;max-width:150px;" align="center">

	    	<%if("blog".equals(type)) {%>
	    	<%=SystemEnv.getHtmlLabelName(26929,user.getLanguage())%><!-- 工作指数 -->
	    	<%} else if("mood".equals(type)){%>
	    		<%=SystemEnv.getHtmlLabelName(26930,user.getLanguage())%><!-- 心情指数 -->
	    	<%} else{%>
	    		<%=SystemEnv.getHtmlLabelName(26931,user.getLanguage())%><!-- 考勤指数 -->
	    	<%} %>
	    </td>
	</tr>
	<%
	  
	  if("blog".equals(type)){
		  for(int i=0;i<resultList.size();i++){
	    	  Map reportMap=(Map)resultList.get(i);
	    	  String attentionid=(String)reportMap.get("attentionid");
	    	  List reportList=(List)reportMap.get("reportList");
	    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
	    	  double workIndex=((Double)reportMap.get("workIndex")).doubleValue();
	    	  
	  %>
	  <tr class="item1">
	     <td><input type="checkbox" conType="1" conValue="<%=attentionid%>" attentionid="<%=attentionid%>" class="condition" /><a href="viewBlog.jsp?blogid=<%=attentionid%>" target="_blank"><%=ResourceComInfo.getLastname(attentionid)%></a></td>
	  <%
	     for(int j=0;j<totaldateList.size();j++){
	       if(j<isWorkdayList.size()){	 
	         boolean isWorkday=((Boolean)isWorkdayList.get(j)).booleanValue();
	         boolean isSubmited=((Boolean)reportList.get(j)).booleanValue();
	  %> 
	       <%if(isWorkday){%>
		    <td align="center">
		       <%if(isSubmited){%>
		        <div><img src="images/submit-ok_wev8.png" /></div>
		       <%}else{ %>
		        <div><img src="images/submit-no_wev8.png" /></div> 
		       <%} %> 
		    </td>
		  <%}else{%>
	  <%}}else{%>
	        <td >&nbsp;</td>
	 <%}}%>
        <td align="center"><span style="color:red"><%=totalUnsubmit %></span>/<%=totalWorkday %></td>
	    <td>
	     <a href="viewBlog.jsp?blogid=<%=attentionid%>" class="index" target="_blank">
	     	<span title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%><%=totalUnsubmit%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%><%=totalWorkday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(workIndex)%></span></a><%=workIndex%><a href="javascript:openChart('blog','<%=attentionid%>',<%=year%>,'1','<%=ResourceComInfo.getLastname(attentionid)%><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a>
	    </td>
	 </tr>
	 <% }%>
	 <tr>
	    <td align="center"><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></td><!-- 总计 -->
	<%
	  for(int i=0;i<totaldateList.size();i++){
		  if(i<isWorkdayList.size()){	 
		    boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    int unsubmit=((Integer)resultCountList.get(i)).intValue();
		    if(isWorkday){
	%>
	      <td align="center"><span style="color:red"><%=unsubmit%></span>/<%=total%></td>
	<% 	    	
		    }else{
    %>
    <%		    	
		    }
	      }else{
	%>
	      <td>&nbsp;</td>
	<%	
	      }
	  }
	%>  
         <td>&nbsp;</td>
	     <td><span title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%><%=allUnsubmit%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%><%=allWorkday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(allWorkIndex)%></span><%=allWorkIndex%></td>
	</tr>
	<%}else if("mood".equals(type)){
	    	
			for(int i=0;i<resultList.size();i++){
			      int totalSubmitedDays = 0;
		    	  Map reportMap=(Map)resultList.get(i);
		    	  String attentionid=(String)reportMap.get("attentionid");
		    	  List reportList=(List)reportMap.get("reportList");
		    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
	    		  double moodIndex=((Double)reportMap.get("moodIndex")).doubleValue();
	    		  int happyDays=((Integer)reportMap.get("happyDays")).intValue();
	    		    int unHappyDays=((Integer)reportMap.get("unHappyDays")).intValue();
	    		  %>
	    		  <tr class="item1">
	    		     <td><input type="checkbox" conType="1" conValue="<%=attentionid%>" class="condition" /><a href="viewBlog.jsp?blogid=<%=attentionid%>" class="index" target="_blank"><%=ResourceComInfo.getLastname(attentionid)%></a></td>
	    		  <%
	    		     for(int j=0;j<totaldateList.size();j++){
	    		       if(j<isWorkdayList.size()){	 
	    		         boolean isWorkday=((Boolean)isWorkdayList.get(j)).booleanValue();
	    		         String faceImg=(String)reportList.get(j);
	    		  			%> 
	    		       <%if(isWorkday){%>
	    			    <td align="center">
	    			       <%if("".equals(faceImg)){%>
	    			        &nbsp;
	    			       <%}else{ 
	    			           totalSubmitedDays++;
	    			       %>
	    			        <div><img src="<%=faceImg %>" /></div> 
	    			       <%} %> 
	    			    </td>
	    			  <%}else{%>
	    		  <%}}else{%>
	    		        <td >&nbsp;</td>
	    		 <%}}%>
                    <td align="center"><span style="color:red"><%=happyDays %></span>/<%=totalSubmitedDays %></td>
	    		    <td>
	    		     <a href="viewBlog.jsp?blogid=<%=attentionid%>" class="index" target="_blank"><span title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%><%=unHappyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%><%=happyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(moodIndex)%></span></a><%=moodIndex%><a href="javascript:openChart('mood','<%=attentionid%>',<%=year%>,'1','<%=ResourceComInfo.getLastname(attentionid)%><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	    		 </tr>
	    		  
	    <%
	    	  }
		%>
		<tr>
	    <td align="center"><%=SystemEnv.getHtmlLabelName(523,user.getLanguage())%></td><!-- 总计 -->
	<%
	 for(int i=0;i<totaldateList.size();i++){
		  if(i<isWorkdayList.size()){	 
		    boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    int unHappy=((Integer)((HashMap)resultCountList.get(i)).get("unhappy")).intValue();
		    int happy=((Integer)((HashMap)resultCountList.get(i)).get("happy")).intValue();
		    if(isWorkday){
	%>
	      <td align="center" style="width: 18px;"><span style="color:red"><%=unHappy%></span>/<%=unHappy+happy%></td>
	<% 	    	
		    }else{
    %>
    <%		    	
		    }
	}else{
	%>
	      <td>&nbsp;</td>
	<%	
	}
	  }
	%>  
        <td>&nbsp;</td>
	    <td><span title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%><%=resultMap.get("totalUnHappyDays") %><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%><%=resultMap.get("totalHappyDays") %><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(((Double)resultMap.get("totalMoodIndex")).doubleValue())%></span><%=resultMap.get("totalMoodIndex") %></td>
	</tr>
		<%} %>  
	  
	
	</table>
  </div>	

