
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogShareManager"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>

<%@page import="net.sf.json.JSONObject"%><jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.blog.BlogManager"%>

<%
  String userid=""+user.getUID();
  Calendar calendar=Calendar.getInstance();
  int currentMonth=calendar.get(Calendar.MONTH)+1;
  int currentYear=calendar.get(Calendar.YEAR);
  
  int year=Util.getIntValue(request.getParameter("year"),currentYear);
  int month=Util.getIntValue(request.getParameter("month"),currentMonth);
  String monthStr=month<10?("0"+month):(""+month);
  
  String isAppend=Util.null2String(request.getParameter("isAppend"));
  String isExtend=Util.null2String(request.getParameter("isExtend"));
  String value=Util.null2String(request.getParameter("value"));
  //String index=Util.null2String(request.getParameter("index"));
  String tempid=Util.null2String(request.getParameter("tempid"));
  String conditionid=Util.null2String(request.getParameter("conditionid"));
  String reportType=Util.null2String(request.getParameter("reportType"));
  String type=Util.null2String(request.getParameter("type"));

  BlogReportManager reportManager=new BlogReportManager();
  reportManager.setUser(user);
%>
<%
 if(type.equals("1")){
	 Map resultMap=new HashMap();
	 if("blog".equals(reportType)){
		 resultMap= reportManager.getBlogReportByUser(value,year,month); 
	 }
	 else if("mood".equals(reportType)){
		 resultMap=reportManager.getMoodReportByUser(value,year,month);
	 }
	 conditionid=reportManager.addTempCondition(tempid,type,value);
	 List reportList=(List)resultMap.get("reportList");
	 List totaldateList=(List)resultMap.get("totaldateList");    //当月总的天数
	 int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
	 int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();  //微博未提交总数
	 
 if(isAppend.equals("false")){
%>
   <table id="reportList" style="width:100%;;border-collapse:collapse;margin-top: 3px;margin-bottom: 40px"  border="1" cellspacing="0" bordercolor="#9db1ba" cellpadding="2" >
	  <!-- 日期行  -->
	  <tr style="" height="20px">
	    <td style="width:120px" class="tdWidth" nowrap="nowrap">
	        <div style="float: left;">
              <input type="checkbox"  onclick="selectBox(this)" conType="<%=type%>" conValue="<%=value%>" title="<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>"/>  <!-- 全选 -->
             </div>
	        <div style="float: left;">
			   <a class="btnEcology" id="compareBtn"  href="javascript:void(0)" onclick="compareChart('reportList','<%=reportType%>')"> <!-- 自定义报表 -->
				 <div class="left" style="width:45px;color: #666"><span ><span style="font-size: 16px;font-weight: bolder;margin-right: 3px">+</span><%=SystemEnv.getHtmlLabelName(26962,user.getLanguage())%></span></div><!-- 对比 -->
				 <div class="right"> &nbsp;</div>
			   </a>
		     </div>
	    </td>
	    <%
	      for(int i=0;i<totaldateList.size();i++){
	    	  int day=((Integer)totaldateList.get(i)).intValue();
	    	  if(i<reportList.size()){
	    		  Map map=(Map)reportList.get(i);
		    	  boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
		    	  if(isWorkday){
		%>
		      <td class="tdWidth" nowrap="nowrap"><%=day%></td>
		<%    		  
		    	  }
	    	  }else{
	    %>
	          <td class="tdWidth" nowrap="nowrap"><%=day%></td>
	    <%}}%>
	    <td style="width: 5%;min-width:135px;" align="center">
	    <%if("blog".equals(reportType))
		    out.println(SystemEnv.getHtmlLabelName(26929 ,user.getLanguage()));
	     else
	    	out.println(SystemEnv.getHtmlLabelName(26930,user.getLanguage()));
	    %>
	    </td><!-- 工作指数 心情指数 -->
	</tr>
<%} %>	
	<!-- 日期行  -->
	<%if("blog".equals(reportType)){ 
		 double workIndex=((Double)resultMap.get("workIndex")).doubleValue();  
	%>
	<!-- 微博报表  -->
	<tr class="item<%=conditionid%>">
	    <td><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=value%>"/><a href="viewBlog.jsp?blogid=<%=value%>" class="index" target="_blank"><%=ResourceComInfo.getLastname(value)%></a><img src="images/delete_wev8.png" onclick="delCon(this,<%=conditionid%>)" style="margin-left: 3px;width:12px;cursor: pointer;" align="absmiddle"/></td>
	    <%
	      for(int i=0;i<totaldateList.size();i++){
	    	if(i<reportList.size()){
	    	   Map map=(Map)reportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isSubmited=((Boolean)map.get("isSubmited")).booleanValue();
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
	    <%}
	    }%>
	    <td><a href="viewBlog.jsp?blogid=<%=value%>" class="index" target="_blank"><span title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%><%=totalUnsubmit%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%><%=totalWorkday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(workIndex)%></span></a><%=workIndex%><a href="javascript:openChart('blog','<%=value%>',<%=year%>,<%=type%>,'<%=ResourceComInfo.getLastname(value)%><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
		</tr>
		<%
			}else{ 
				int happyDays=((Integer)resultMap.get("happyDays")).intValue();
    		    int unHappyDays=((Integer)resultMap.get("unHappyDays")).intValue();
				double	moodIndex=((Double)resultMap.get("moodIndex")).doubleValue();
		%>
			<tr class="item<%=conditionid%>">
	    		<td><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=value%>"/><a href="viewBlog.jsp?blogid=<%=value%>" class="index" target="_blank"><%=ResourceComInfo.getLastname(value)%></a><img src="images/delete_wev8.png" onclick="delCon(this,<%=conditionid%>)" style="margin-left: 3px;width:12px;cursor: pointer;" align="absmiddle"/></td>
			<% 
				 for(int i=0;i<totaldateList.size();i++){ 
	    	if(i<reportList.size()){
	    	   Map map=(Map)reportList.get(i);
	    	   boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
	    	   boolean isSubmited=((Boolean)map.get("isSubmited")).booleanValue();
	    	   String faceImg=(String)map.get("faceImg");
	    	   if(isWorkday){
	    	   %>
	    		<td align="center"> 
	    			       <%if("".equals(faceImg)){%>
	    			        &nbsp;
	    			       <%}else{ %>
	    			        <div><img src="<%=faceImg %>" /></div> 
	    			       <%} %> 
	    	     </td>
	    		<%}else{ %>
	    		<%}}else{ %>
	    		<td>&nbsp;</td>
	    		<%} %>
	    	
	    <%} %>
	    <td>
	       <a href="viewBlog.jsp?blogid=<%=value%>" class="index" target="_blank"><span title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%><%=unHappyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%><%=happyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(moodIndex)%></span></a><%=moodIndex%><a href="javascript:openChart('mood','<%=userid %>',<%=year%>,1,'<%=ResourceComInfo.getLastname(value)%><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
		</tr>
		<%} %>
		<!-- 微博报表  -->
  <%
  if(isAppend.equals("false")){
  %>
	</table>
 <%} %>	
 
 <%}else if(type.equals("2")||type.equals("3")){
 if(!isExtend.equals("true")){	 
  Map resultMap= reportManager.getOrgReportCount(userid,value,type,year,month); 
  
  if(resultMap==null){
	out.print("null");
	return ;
  }
  conditionid=reportManager.addTempCondition(tempid,type,value);
  List resultCountList=(List)resultMap.get("resultCountList");
  List isWorkdayList=(List)resultMap.get("isWorkdayList");
  List totaldateList=(List)resultMap.get("totaldateList");
  int totalAttention=((Integer)resultMap.get("totalAttention")).intValue();
  int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();
  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();
  double workIndex=((Double)resultMap.get("workIndex")).doubleValue();
  SubCompanyComInfo subCompanyComInfo=new SubCompanyComInfo();
  DepartmentComInfo departmentComInfo=new DepartmentComInfo();
  String orgName=type.equals("2")?subCompanyComInfo.getSubCompanyname(value):departmentComInfo.getDepartmentname(value);
  if(isAppend.equals("false")){
 %>
  	<table id="reportList" style="width:100%;;border-collapse:collapse;margin-top: 3px;table-layout:fixed;"  border="1" cellspacing="0" bordercolor="#9db1ba" cellpadding="2" >
	    <tr style="" height="20px">
		    <td style="width:100px;" class="tdWidth" nowrap="nowrap">
	         <div style="float: left;">
               <input type="checkbox"  onclick="selectBox(this)" conType="<%=type%>" conValue="<%=value%>" title="<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>"/>  <!-- 全选 -->
             </div>
	         <div style="float: left;">
			   <button class="submitButton" style="width:45px;" id="compareBtn" onclick="compareChart('reportList','<%=reportType %>')" type="button"><%=SystemEnv.getHtmlLabelName(26962,user.getLanguage())%></button>
		     </div>
		   </td>
		    <%
	        for(int i=0;i<totaldateList.size();i++){
	          int day=((Integer)totaldateList.get(i)).intValue();	
	    	  if(i<resultCountList.size()){
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
		    <td style="width:150px;max-width:150px;" align="center"><%=SystemEnv.getHtmlLabelName(26929 ,user.getLanguage())%></td><!-- 工作指数 -->
	    </tr>
  <%} %>	    
	    <tr class="item">
	    <td align="left"><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=value%>"/><span style="cursor: pointer;" onclick="extendRecord(this,<%=value%>,<%=type%>,<%=year%>,<%=month %>,<%=conditionid%>,'<%=reportType %>')" extend="false" isLoad='false'><img src="images/extend_wev8.png"/><%=orgName%></span><img src="images/delete_wev8.png" onclick="delCon(this,<%=conditionid%>)" style="margin-left: 3px;width:12px" align="absmiddle"/></td>
	    <%for(int i=0;i<totaldateList.size();i++){
	        if(i<resultCountList.size()){
	        	boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
	        	int unsubmit=((Integer)resultCountList.get(i)).intValue();
	        	if(isWorkday){
	    %>
	            <td align="center" style="width: 18px;"><span style="color:red"><%=unsubmit%></span>/<%=totalAttention%></td>
	    <%   		
	        	}
	    %>
	    <%    		
	        }else{
	    %>
	            <td>&nbsp;</td>
	    <%    	
	        }
	    } %>
	    <td><span title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%><%=totalUnsubmit%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%><%=totalWorkday*totalAttention%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(workIndex)%></span><%=workIndex%><a href="javascript:openChart('blog','<%=value%>',<%=year%>,<%=type%>,'<%=orgName%><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
  <%if(isAppend.equals("false")){ %>	
	</table>  
  <%}}else{ 
	  if("blog".equals(reportType)){
	  Map resultMap=reportManager.getOrgReportRecord(userid,value,type,year,month);
	  
	  if(resultMap==null){
			out.print("null");
			return ;
	  }	  
	  List resultList=(List)resultMap.get("resultList");          //统计结果
	  List totaldateList=(List)resultMap.get("totaldateList");          //当月总的天数
	  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
	  List isWorkdayList=(List)resultMap.get("isWorkdayList");    //有效日期统计list
	  for(int i=0;i<resultList.size();i++){
	    	  Map reportMap=(Map)resultList.get(i);
	    	  String attentionid=(String)reportMap.get("attentionid");
	    	  List reportList=(List)reportMap.get("reportList");
	    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
	    	  double workIndex=((Double)reportMap.get("workIndex")).doubleValue();
	  %>
	  <tr class="item<%=conditionid%>">
	     <td class="name"><a href="viewBlog.jsp?blogid=<%=attentionid%>" class="index" target="_blank"><%=ResourceComInfo.getLastname(attentionid)%></a></td>
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
	    <td>
	     <a href="viewBlog.jsp?blogid=<%=attentionid%>" class="index" target="_blank"><span title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%><%=totalUnsubmit%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%><%=totalWorkday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(workIndex)%></span></a><%=workIndex%><a href="javascript:openChart('blog','<%=attentionid%>',<%=year%>,1,'<%=ResourceComInfo.getLastname(attentionid)%><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	 </tr>
	<%} 
     	}else if("mood".equals(reportType)){
     		Map resultMap=reportManager.getOrgMoodReportRecord(userid,value,type,year,month);
     		  
     		  if(resultMap==null){
     				out.print("null");
     				return ;
     		  }	  
     		  List resultList=(List)resultMap.get("resultList");          //统计结果
     		  List totaldateList=(List)resultMap.get("totaldateList");          //当月总的天数
     		  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
     		  List isWorkdayList=(List)resultMap.get("isWorkdayList");    //有效日期统计list

       		
       		 for(int i=0;i<resultList.size();i++){
  	   	    	  Map reportMap=(Map)resultList.get(i);
  	   	    	  String attentionid=(String)reportMap.get("attentionid");
  	   	    	  List reportList=(List)reportMap.get("reportList");
  	   	    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
  	   	    	  double workIndex=((Double)reportMap.get("moodIndex")).doubleValue();
  	   	    	  double moodIndex=((Double)reportMap.get("moodIndex")).doubleValue();
  	   	    	
	 	   	   int happyDays=((Integer)reportMap.get("happyDays")).intValue();
	 		    int unHappyDays=((Integer)reportMap.get("unHappyDays")).intValue();
  	   	    	 %>
  	   	    	 <tr class="item<%=conditionid%>">
  	    			 <td class="name"><a href="viewBlog.jsp?blogid=<%=attentionid%>" class="index" target="_blank"><%=ResourceComInfo.getLastname(attentionid)%></a></td>
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
	    			       <%}else{ %>
	    			        <div><img src="<%=faceImg %>" /></div> 
	    			       <%} %> 
	    			    </td>
	    			  <%}else{%>
	    		  <%}}else{%>
	    		        <td >&nbsp;</td>
	    		 <%}}%>
	    		    <td>
	    		     <a href="viewBlog.jsp?blogid=<%=attentionid%>" class="index" target="_blank"><span title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%><%=unHappyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%><%=happyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(moodIndex)%></span></a><%=moodIndex%><a href="javascript:openChart('mood','<%=attentionid%>',<%=year%>,'1','<%=ResourceComInfo.getLastname(attentionid)%><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
  	    		</tr>
  	   	    	 <%
     	    	}
     	}
	  %>
	  
	  <%
	  }
 }%>
 
