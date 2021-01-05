
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.blog.BlogManager"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="appDao" class="weaver.blog.AppDao"></jsp:useBean>

<head>
<script type='text/javascript' src='js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='js/timeline/easing_wev8.js'></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp_wev8.css" rel="stylesheet" type="text/css"> 
<script type='text/javascript' src='js/blogUtil_wev8.js'></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<style>
 .name{padding-left: 33px}
 .conDiv{margin-top: 8px;height:30px;}
 .conDiv .conType{float: left;text-align: left}
 .conDiv .operationdiv{float: right;}
 .conDiv .operationdiv .operationItem{margin-right: 8px;float: right}
 .conDiv .conLine{width:100%;;border-top:1px solid  #dadada;line-height:1px;margin-top: 5px;float: left;}
</style>
</head>
<%
String userid=""+user.getUID();
String tempid=Util.null2String(request.getParameter("tempid"));
String isnew=Util.null2String(request.getParameter("isnew"));
double index=0.0;
Calendar calendar=Calendar.getInstance();
int currentMonth=calendar.get(Calendar.MONTH)+1;
int currentYear=calendar.get(Calendar.YEAR);

int year=Util.getIntValue(request.getParameter("year"),currentYear);

BlogDao blogDao=new BlogDao();
Map monthMap=blogDao.getCompaerMonth(year);
int startMonth=((Integer)monthMap.get("startMonth")).intValue();   //开始月份
int endMonth=((Integer)monthMap.get("endMonth")).intValue();       //结束月份

Map enbaleDate=blogDao.getEnableDate();
int enableYear=((Integer)enbaleDate.get("year")).intValue();      //微博开始使用年

int month=Util.getIntValue(request.getParameter("month"),endMonth);
String reportType=Util.null2String(request.getParameter("reportType"));
if("".equals(reportType)){
	reportType="blog";
}
String monthStr=month<10?("0"+month):(""+month);

WorkDayDao dayDao=new WorkDayDao(user);
Map dayMap=dayDao.getStartAndEndOfMonth(year,month);
List totaldateList=(List)dayMap.get("totaldateList");
String startdate=(String)dayMap.get("startdate");
String enddate=(String)dayMap.get("enddate");

TreeMap workdayMap=dayDao.getWorkDaysMap(startdate, enddate);

SubCompanyComInfo subCompanyComInfo=new SubCompanyComInfo();
DepartmentComInfo departmentComInfo=new DepartmentComInfo();
BlogReportManager reportManager=new BlogReportManager();
reportManager.setUser(user);

String tempName=SystemEnv.getHtmlLabelName(20412,user.getLanguage()); //自定义报表
String sql="select * from blog_reportTemp where id="+tempid;
RecordSet recordSet=new RecordSet();
recordSet.execute(sql);
if(recordSet.next())
	tempName=recordSet.getString("tempName");
String titlename = "";
%>
<body style="height:auto;">
 <div id="divTopMenu"></div>
 <%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
 <%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
 <% 
   if(isnew.equals("true")){
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(16213,user.getLanguage())+",javascript:doLock(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
	 tempName=SystemEnv.getHtmlLabelName(20412,user.getLanguage()); //自定义报表
   }else{	 
	 RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",javascript:doEdit(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
   }
  RCMenu += "{"+SystemEnv.getHtmlLabelName(26962,user.getLanguage())+",javascript:doCompare(),_self} ";
  RCMenuHeight += RCMenuHeightStep ;
 %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div style="width:100%;">
  <div align="center" id="reportTitle" class="reportTitle" style="margin-top: 8px;" >
    <span><%=year+"-"+monthStr+" "%></span><span id="titleSpan"><%=tempName%></span>  
    <input type="text" id="titleText" value="<%=tempName%>" style="display: none">
    <a href="javascript:void(0)" id="editTitle" onclick="editTitle()" style="margin-left: 8px;display: <%=isnew.equals("true")?"":"none"%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a><!-- 编辑 -->
    <a href="javascript:void(0)" id="savaTitle" onclick="saveTitle()" style="margin-left: 8px;display: none"><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></a><!-- 保存 -->
  </div>
  <div style="margin-top: 3px;margin-bottom: 15px">
         <div class="lavaLampHead">
         	<div style="border-bottom:#b6b6b6 1px solid">
             <div style="width: 80%;float: left;">
					<ul class="lavaLamp" id="timeContent">
					  <%for(int i=startMonth;i<=endMonth;i++){ 
					      monthStr=i<10?("0"+i):("")+i;
					  %>
					     <li <%=i==month?"class='current'":""%>><a href="javascript:changeMonth(<%=year%>,<%=i%>)"><%=i%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></a></li><!-- 月 -->
					  <%}%>
					</ul>
			  </div>	
			  <div class="report_yearselect" align="right">
			     <select class="yearSelect" id="yearSelect" onchange="changeYear()">
			         <%
					   for(int i=currentYear;i>=enableYear;i--){ 
					 %>
					   <option value="<%=i%>" <%=i==year?"selected='selected'":""%>><%=i%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></option><!-- 年 -->
				    <%} %>
			     </select>
			  </div>
			  <div class="clear"></div>	
         </div>
         </div>
    </div>
    
	<div align="left" style="margin-top: 8px">
	  <div style="float: left;" class="reportTab">
	      <!-- 报表类型 -->
		  <%=SystemEnv.getHtmlLabelName(22375,user.getLanguage())%>：
		  <a href="javascript:void())" onclick="changeReport(this,'blog')" style="margin-right: 8px;<%="blog".endsWith(reportType)?"text-decoration:underline !important":"" %>"><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></a><!-- 微博报表 -->
		  <%if(appDao.getAppVoByType("mood").isActive()){ %>
		  <a href="javascript:void())" onclick="changeReport(this,'mood')" style="margin-right: 8px;<%="mood".endsWith(reportType)?"text-decoration:underline !important":"" %>"><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></a><!-- 心情报表 -->
		  <%} %>
	  </div>
	  <div style="float: right;">
	  	<%if("blog".equals(reportType)) {%>
	     <div class="remarkDiv" style="text-align: left;" id="blogRemarks">
	         <span style="margin-right: 8px"><img src="images/submit-no_wev8.png" align="absmiddle" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%></span>
	         <span  style="margin-right: 8px"><img src="images/submit-ok_wev8.png" align="absmiddle" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%></span>
	         <span  style="margin-right: 8px">"<%=SystemEnv.getHtmlLabelName(523 ,user.getLanguage())%>"<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>"<font color="red"><%=SystemEnv.getHtmlLabelName(15178 ,user.getLanguage())+SystemEnv.getHtmlLabelName(355,user.getLanguage())%></font>/<%=SystemEnv.getHtmlLabelName(26932 ,user.getLanguage())+SystemEnv.getHtmlLabelName(355,user.getLanguage())%>"</span>  
	     </div>
	     <%} if("mood".equals(reportType)) {%>
	    <div class="remarkDiv" style="text-align: left;" id="moodRemarks">
	          <span  style="margin-right: 8px"><img src="images/mood-unhappy_wev8.png" align="absmiddle" width="16px" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%></span>
	          <span  style="margin-right: 8px"><img src="images/mood-happy_wev8.png" align="absmiddle" width="16px" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%></span>
	          <span  style="margin-right: 8px">"<%=SystemEnv.getHtmlLabelName(523 ,user.getLanguage())%>"<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>"<font color="red"><%=SystemEnv.getHtmlLabelName(26917 ,user.getLanguage())+SystemEnv.getHtmlLabelName(852,user.getLanguage())%></font>/<%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())+SystemEnv.getHtmlLabelName(852,user.getLanguage())%>"</span>
	    </div>
	    <%} %>
	 
	  </div>
	</div>
    <%
     List conditionList=reportManager.getConditionList(tempid);
    %>
    <div id="blogReportDiv" style="overflow-x:auto;width: 100%">
     <%if(conditionList.size()>0){%>
      <table id="reportList" style="width:100%;;border-collapse:collapse;margin-top: 3px;margin-bottom: 40px;table-layout: fixed;"  border="1" cellspacing="0" bordercolor="#dfdfdf" cellpadding="2" >
	    <tr style="" height="20px">
		    <td style="width:100px;" class="tdWidth" nowrap="nowrap">
			    <div style="float: left;">
	             <input type="checkbox"  onclick="selectBox(this)" title="<%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%>"/>  <!-- 全选 -->
	            </div>
		        <div style="float: left;">
				   <button class="submitButton" style="width:45px;" id="compareBtn" onclick="compareChart('reportList','<%=reportType %>')" type="button"><%=SystemEnv.getHtmlLabelName(26962,user.getLanguage())%></button>
			    </div>
		    </td><!-- 对比 -->
		    
		    <%
		      for(int i=0;i<totaldateList.size();i++){
		    	  int day=((Integer)totaldateList.get(i)).intValue();
		    	 
		    	  boolean isWorkday=false;
		    	  Object object=workdayMap.get(year+"-"+(month<10?("0"+month):""+month)+"-"+(day<10?("0"+day):""+day));
		    	  if(object!=null){
		    	     isWorkday=((Boolean)object).booleanValue();
		    	  if(isWorkday){   
		    %>
		      <td class="tdWidth" nowrap="nowrap" width="*"><%=day%></td>
		    <%}}else{%>
		      <td class="tdWidth" nowrap="nowrap" width="*"><%=day%></td>	
		    <%}}%>
		    <td class="tdWidth" align="center" style="width:150px;max-width:150px;" nowrap="nowrap">
		      <%if("blog".equals(reportType))
			    out.println(SystemEnv.getHtmlLabelName(26929 ,user.getLanguage()));
		       else
		    	out.println(SystemEnv.getHtmlLabelName(26930,user.getLanguage()));
		      %>
		    </td><!-- 工作指数 -->
	    </tr>
    <%
     for(int j=0;j<conditionList.size();j++){
    	Map comditionMap=(Map)conditionList.get(j); 
    	 
        String id=(String)comditionMap.get("id");
        String type=(String)comditionMap.get("type");
        String content=(String)comditionMap.get("content");
    %>
    <%
    if(type.equals("1")){
    	//查看人员状态，非正常状态人员不显示在自定义报表中
    	String status=ResourceComInfo.getStatus(content);
    	if(!status.equals("0")&&!status.equals("1")&&!status.equals("2")&&!status.equals("3"))
    	   continue;	
    	if("blog".equals(reportType)){
			 Map resultMap=reportManager.getBlogReportByUser(content,year,month); 
			  
			 List reportList=(List)resultMap.get("reportList");
			 int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
			 int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();  //微博未提交总数
			 double workIndex=((Double)resultMap.get("workIndex")).doubleValue();        //工作指数 
   %>
	<tr class="item<%=id%>">
	    <td><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=content%>" /><a href="viewBlog.jsp?blogid=<%=content%>" class="index" target="_blank"><%=ResourceComInfo.getLastname(content)%></a><img src="images/delete_wev8.png" onclick="delCon(this,<%=id%>)" style="margin-left: 3px;width:12px;cursor: pointer;display: <%=isnew.equals("true")?"":"none"%>" align="absmiddle"/></td>
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
	    <td><a href="viewBlog.jsp?blogid=<%=content%>" class="index" target="_blank"><span title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%><%=totalUnsubmit%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%><%=totalWorkday%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(workIndex)%></span></a><%=workIndex%><a href="javascript:openChart('blog','<%=content%>',<%=year%>,<%=type%>,'<%=ResourceComInfo.getLastname(content)%><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
		</tr>
 <%}else{
	 Map resultMap=reportManager.getMoodReportByUser(content,year,month); 
	  
	 List reportList=(List)resultMap.get("reportList");
	 int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //当月工作日总数
	 int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();  //微博未提交总数
	 double moodIndex=((Double)resultMap.get("moodIndex")).doubleValue();        //工作指数 
	 int happyDays=((Integer)resultMap.get("happyDays")).intValue();
	 int unHappyDays=((Integer)resultMap.get("unHappyDays")).intValue();
 %>
	 <tr class="item<%=id%>">
	    <td><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=content%>" /><a href="viewBlog.jsp?blogid=<%=content%>" class="index" target="_blank"><%=ResourceComInfo.getLastname(content)%></a><img src="images/delete_wev8.png" onclick="delCon(this,<%=id%>)" style="margin-left: 3px;width:12px;cursor: pointer;display: <%=isnew.equals("true")?"":"none"%>" align="absmiddle"/></td>
	    <%
	    	for(int i=0;i<totaldateList.size();i++){
	    		    	 if(i<reportList.size()){
	    		    		
	    		    		 Map map=(Map)reportList.get(i);
		    		    	 boolean isWorkday=((Boolean)map.get("isWorkday")).booleanValue();
		    		         String faceImg=(String)map.get("faceImg");
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

	     <td><a href="viewBlog.jsp?blogid=<%=content%>" class="index" target="_blank"><span title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%><%=unHappyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%><%=happyDays%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(moodIndex)%></span></a><%=moodIndex%><a href="javascript:openChart('mood','<%=content%>',<%=year%>,<%=type%>,'<%=ResourceComInfo.getLastname(content)%><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
     </tr>
	 <%
 }
    	}else if(type.equals("2")||type.equals("3")){
  	
	  if("blog".equals(reportType)){
		  Map resultMap= reportManager.getOrgReportCount(userid,content,type,year,month); 
	  	  if(resultMap==null) continue;
		  List resultCountList=(List)resultMap.get("resultCountList");
		  List isWorkdayList=(List)resultMap.get("isWorkdayList");
		  int totalAttention=((Integer)resultMap.get("totalAttention")).intValue();
		  int totalUnsubmit=((Integer)resultMap.get("totalUnsubmit")).intValue();
		  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();
		  double workIndex=((Double)resultMap.get("workIndex")).doubleValue();
		  String orgName=type.equals("2")?subCompanyComInfo.getSubCompanyname(content):departmentComInfo.getDepartmentname(content);
 %>
	<tr class="item">
	    <td align="left"><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=content%>" /><span style="cursor: pointer;" onclick="extendRecord(this,'<%=content%>',<%=type%>,<%=year%>,<%=month %>,<%=id%>,'<%=reportType %>')" extend="false" isLoad='false'><img src="images/extend_wev8.png" /><%=orgName%></span><img src="images/delete_wev8.png" onclick="delCon(this,<%=id%>)" style="margin-left: 3px;width:12px;cursor: pointer;display: <%=isnew.equals("true")?"":"none"%>" align="absmiddle"/></td>
	    <%for(int i=0;i<totaldateList.size();i++){
	        if(i<resultCountList.size()){
	        	boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
	        	int unsubmit=((Integer)resultCountList.get(i)).intValue();
	        	if(isWorkday){
	    %>
	            <td align="center" style="width: 18px;"><span style="color:red"><%=unsubmit%></span>/<%=totalAttention%></td>
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
	    } %>
	    <td>
	    	<% 
	    	
	    			index=workIndex;
	    		
	    	%>
	    	<span title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%><%=totalUnsubmit%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%><%=totalWorkday*totalAttention%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(index)%></span><%=index%><a href="javascript:openChart('<%=reportType %>','<%=content%>',<%=year%>,<%=type%>,'<%=orgName%><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
	
  <%}
	  else{
		  Map resultMap= reportManager.getOrgMoodReportCount(userid,content,type,year,month);  
	  	  if(resultMap==null) continue;
		  List resultCountList=(List)resultMap.get("resultCountList");
		  List isWorkdayList=(List)resultMap.get("isWorkdayList");
		  String orgName=type.equals("2")?subCompanyComInfo.getSubCompanyname(content):departmentComInfo.getDepartmentname(content);
		  
		  %>
		  <tr class="item">
	    <td align="left"><input type="checkbox" class="condition" conType="<%=type%>" conValue="<%=content%>" /><span style="cursor: pointer;" onclick="extendRecord(this,'<%=content%>',<%=type%>,<%=year%>,<%=month %>,<%=id%>,'<%=reportType %>')" extend="false" isLoad='false'><img src="images/extend_wev8.png"/><%=orgName%></span><img src="images/delete_wev8.png" onclick="delCon(this,<%=id%>)" style="margin-left: 3px;width:12px;cursor: pointer;display: <%=isnew.equals("true")?"":"none"%>" align="absmiddle"/></td>
	    <%for(int i=0;i<totaldateList.size();i++){
	        if(i<resultCountList.size()){
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
	    } %>
	    <td>
	    
	    		<span title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%><%=resultMap.get("totalUnHappyDays") %><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%><%=resultMap.get("totalHappyDays") %><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(((Double)resultMap.get("totalMoodIndex")).doubleValue())%></span><%=resultMap.get("totalMoodIndex") %><a href="javascript:openChart('<%=reportType %>','<%=content%>',<%=year%>,<%=type%>,'<%=orgName%><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
		  <%
	  }
}
}%>
</table>
<%}%>
</div>
    
</div>

<%if(isnew.equals("true")){%>	
<div id="condition" style="display: <%=isnew.equals("true")?"":"none"%>">
    <div id="condition"  style="margin-right: 8px;float: right;margin-bottom: 20px;">
	   <button class="blueButton" onclick="addCondition()" type="button" style="margin-top:8px;margin-bottom: 20px;width:65px;">
       		<label id="btnLabel"><span class='add'>+</span><%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></span></label>
       </button>
	   
    </div>
</div>
<%}%>
<script type="text/javascript">

  //锁定报表
  function doLock(){
    window.parent.displayLoading(1,"page");
    window.location.href="customReport.jsp?isnew=false&tempid=<%=tempid%>&year=<%=year%>&month=<%=month%>";
  }
  //编辑报表
  function doEdit(){
    window.parent.displayLoading(1,"page");
    window.location.href="customReport.jsp?isnew=true&tempid=<%=tempid%>&year=<%=year%>&month=<%=month%>";
  }

  function extendRecord(obj,value,type,year,month,conditionid,reportType){
	  if(jQuery(obj).attr("extend")=="true"){
	     jQuery(obj).parent().parent().parent().find(".item"+conditionid).hide();
	     jQuery(obj).attr("extend","false");
	     jQuery(obj).find("img").attr("src","images/extend_wev8.png");
	  }else{
	     jQuery(obj).parent().parent().parent().find(".item"+conditionid).show();
	     jQuery(obj).attr("extend","true");
	     jQuery(obj).find("img").attr("src","images/shousuo_wev8.png");
	     if(jQuery(obj).attr("isLoad")=="false"){
	        window.parent.displayLoading(1,"data");
	        jQuery.post("customReportRecord.jsp?reportType="+reportType+"&tempid=<%=tempid%>&isAppend=true&isExtend=true&year="+year+"&month="+month+"&value="+value+"&conditionid="+conditionid+"&type="+type+"",function(data){
	           jQuery(obj).parent().parent().after(data);
	           window.parent.displayLoading(0);
	        });
	        jQuery(obj).attr("isLoad","true");
	     }   
	  }   
   }   

   var type="blog";
   jQuery(document).ready(function(){   
   	 
     jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
     window.parent.displayLoading(0);
     
     jQuery("ul").find("li[class='current']").find("a").attr("style","color:#0185fe !important"); 
  });
  
  function selectBox(obj){
   jQuery("input[type='checkbox']").each(function(){
		changeCheckboxStatus(this,obj.checked);
 	});
  }
  
 function changeMonth(year,month){
    
    jQuery("ul li a").each(function(){
		 jQuery(this).removeAttr("style");  
 	});
 	jQuery(jQuery("ul").find("li")[month-1]).find("a").attr("style","color:#0185fe !important");
 
    window.parent.displayLoading(1,"page");
    window.location.href="customReport.jsp?isnew=<%=isnew%>&tempid=<%=tempid%>&year="+year+"&month="+month+"&reportType=<%=reportType%>";
  }
  
 function changeYear(){
    window.parent.displayLoading(1,"page");
    var year=jQuery("#yearSelect").val();
    window.location.href="customReport.jsp?isnew=<%=isnew%>&tempid=<%=tempid%>&year="+year+"&reportType=<%=reportType%>";
 } 

  function changeReport(obj,typeTemp){
      window.parent.displayLoading(1,"page"); 
	  reportType=typeTemp;
	  window.location.href="customReport.jsp?isnew=<%=isnew%>&tempid=<%=tempid%>&year=<%=year%>&month=<%=month%>&reportType="+typeTemp;

	   jQuery(".reportTab a").css("font-weight","normal");
	   jQuery(obj).css("font-weight","bold");
	   jQuery(".reportDiv").hide();
	   jQuery("#"+type+"ReportDiv").show();
	   jQuery(".remarkDiv").hide();
	   jQuery("#"+type+"Remarks").show();
  }
  var compareYear=<%=year%>;
  var compareMonth=<%=month%>;
  var reportType="<%=reportType%>";
  
  function compareChart(reportdiv,charType){
  
   var conType="";    
   var conValue="";
   var conditions=jQuery("#"+reportdiv).find(".condition:checked"); 
   if(conditions.length==0){
      window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>");//请选择条件
      return ;
   }
   conditions.each(function(){
      conType=conType+","+jQuery(this).attr("conType");
      conValue=conValue+","+jQuery(this).attr("conValue");
   });
   conType=conType.substr(1);
   conValue=conValue.substr(1);
   
    var diag = new window.top.Dialog();
    diag.Modal = true;
    diag.Drag=false;
	diag.Width = 680;
	diag.Height = 425;
	diag.ShowButtonRow=false;
	diag.Title =reportName;
	reportName=reportName.replace(/\'/,"'");
	diag.URL = "/blog/compareChart.jsp?title="+reportName+"&conValue="+conValue+"&conType="+conType+"&year="+compareYear+"&month="+compareMonth+"&chartType="+charType;
    diag.show();
  }
  
   var index=2;
   function addCondition(){
        index++;
        var str="<div class='conDiv' id='con_"+index+"' _index='"+index+"'><div class='conType'>"+
		        "	<div class='left' style='width:240px'><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>："+getShareTypeStr()+"</div>"+
		        "	<div class='left m-l-5'>"+getShareContentStr("relatedshareid_"+index)+"</div>"+ //报表条件
		        "	<div class='clear'></div>"+
		        "</div><div class='operationdiv'>"+
		        "<div class='operationItem'>"+
		        '<button class="grayButton" onclick="deleteCon('+index+')" type="button" style="width:45px;">'+
		       	'	<label id="btnLabel"><span class="add">-</span><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></span></label>'+
		       	'</button>'+
		        '</div>'+	//删除
				"</div><div class='conLine'></div><div id='blog_"+index+"'></div><div style='display:none' id='mood_"+index+"'></div></div>"
        
        jQuery("#condition").before(str);
        beautySelect();
        
        intBrowser("relatedshareid_"+index,1);
     }
    
    function deleteCon(index){
       jQuery("#con_"+index).remove();
    } 
  
   function getShareTypeStr(){
		return  "<select class='sharetype inputstyle' id='sharetype_"+index+"'  name='sharetype' onChange=\"onChangeConditiontype(this)\" >"+
		"	<option value='1' selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>" +
        "	<option value='2'><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>" +
        "	<option value='3'><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>" +
        "</select>";        
	}
	
   function getShareContentStr(fieldId){
		return "<INPUT type='hidden' name='relatedshareid'  class='relatedshareid' id=\""+fieldId+"\" value=''>"+ 
		"<input type='hidden' name='shareid' value='0'>"+
		"<span id='"+fieldId+"_fieldspan'></span>";
	}	  
   
   function onChangeConditiontype(obj){
		var thisvalue=jQuery(obj).val();
		var fieldId = jQuery(obj).parents("div.conDiv").find(".relatedshareid").attr("id");
		var fieldName =jQuery(obj).parents("div.conDiv").find(".relatedshareid").attr("name");
		intBrowser(fieldId,thisvalue);
	}
	
   function　intBrowser(fieldId,fieldType){
		
		var completeUrlStr = "";
		var browserUrlStr = "";
		if(fieldType == 1){
			completeUrlStr = "/data.jsp";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp";
		}
		if(fieldType == 2){
			completeUrlStr = "/data.jsp?type=164";
			browserUrlStr = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp";
		}
		if(fieldType == 3){
			completeUrlStr = "/data.jsp?type=57";
			browserUrlStr ="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
		}	
		
		if(fieldType !=5){		
			$("#"+fieldId+"_fieldspan").e8Browser({
			   name:fieldId,
			   viewType:"0",
			   browserValue:"0",
			   isMustInput:"1",
			   browserSpanValue:"",
			   hasInput:true,
			   linkUrl:"#",
			   isSingle:false,
			   completeUrl:completeUrlStr,
			   browserUrl:browserUrlStr,
			   width:"150px",
			   hasAdd:false,
			   isSingle:true,
			   _callback:'callBackSelectUpdate'
			  });	
		}else{
			jQuery("#"+fieldId).parent().html(this.getShareContentStr(fieldId));
		}
   }
   
   function callBackSelectUpdate(event,data,fieldId,oldid){
		jQuery("#"+fieldId).val(data.id);
		var index=jQuery("#"+fieldId).parents("div.conDiv").attr("_index");
		createReport(index);
	}			
	

    
    var year=<%=year%>;
    var month=<%=month%> ;
    function createReport(index){
       var isAppend=true;
       var value=jQuery("#relatedshareid_"+index).val();
       var type=jQuery("#sharetype_"+index).val();
       if(value==""){
           window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18131,user.getLanguage())%>"); //请选择条件
           return ;
       }    
       if(jQuery.trim(jQuery("#blogReportDiv").html())=="")
           isAppend=false;
       window.parent.displayLoading(1,"data");
       jQuery.post("customReportRecord.jsp?reportType=<%=reportType%>&tempid=<%=tempid%>&isAppend="+isAppend+"&isExtent=false&year="+year+"&month="+month+"&value="+value+"&index="+index+"&type="+type+"&reportType="+reportType,function(data){
          data=jQuery.trim(data);
          if(data=="null")
             window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26161,user.getLanguage())+SystemEnv.getHtmlLabelName(19040,user.getLanguage())%>"); //没有可查看人员 
          else{   
	          if(isAppend)
	            jQuery("#reportList tbody").append(data);
	          else
	            jQuery("#blogReportDiv").html(data);  
	            jQuery("#con_"+index).remove();
	          jQuery('body').jNice();     
          }  
         window.parent.displayLoading(0); 
       });
       
    }
   
  function delCon(obj,index){
    if(window.confirm("<%=SystemEnv.getHtmlLabelName(16631,user.getLanguage())+SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>?")){ //确认删除条件
	    jQuery(obj).parent().parent().remove();
	    jQuery(".item"+index).remove();
	    jQuery.post("blogOperation.jsp?operation=delCondition&conditionid="+index); 
    }
  } 
   
  function editTitle(){
     jQuery("#titleSpan").hide();
     jQuery("#titleText").show();
     jQuery("#editTitle").hide();
     jQuery("#savaTitle").show();
  }
  
  var reportName="<%=tempName%>";
  function saveTitle(){
     var tempName=jQuery("#titleText").val();
     var reg = /^[\w\u4e00-\u9fa5]+$/;
     //var reg = /^[a-zA-Z0-9\u4e00-\u9fa5]+$/;
     if(!reg.test(tempName)){
        window.top.Dialog.alert("请输入字母、数字、中文或下划线！");
        return ;
     }
     
     jQuery("#titleSpan").show();
     jQuery("#titleText").hide();
     jQuery("#editTitle").show();
     jQuery("#savaTitle").hide();
     
     jQuery('#<%=tempid%>', window.parent.document).find(".tabTitle").text(tempName);
     jQuery('#<%=tempid%>', window.parent.document).find(".tabTitle").attr("title",tempName);
     
     reportName=tempName;
     jQuery("#titleSpan").text(tempName);
     jQuery.post("blogOperation.jsp",{"operation":"editReport","tempid":"<%=tempid%>","tempName":tempName},function(){
     	parent.refreshTab("<%=tempid%>" , tempName);
     });
  	 
  }
  
  //对比
 function doCompare(){
   jQuery("#compareBtn").click();
 }  
 
 
 function onShowSubcompany(inputid,spanid,index){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(names);
	          createReport(index);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
 }
 
  function onShowDepartment(inputid,spanid,index){
	   var currentids=jQuery("#"+inputid).val();
	   var id1=window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="+currentids);
	   if(id1){
	       var ids=id1.id;
	       var names=id1.name;
	       if(ids.length>0){
	          jQuery("#"+inputid).val(ids);
	          jQuery("#"+spanid).html(names);
	          createReport(index);
	       }else{
	          jQuery("#"+inputid).val("");
	          jQuery("#"+spanid).html("");
	       }
       }
	}
	
function onShowResource(inputid,spanid,index){
  var id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
  if(id1){
	  var id=id1.id;
	  var name=id1.name;
	  
	  /*检查当前用户对选择人员是否具有查看权限*/
	  if(id!=""){
	  	jQuery.post("blogOperation.jsp",{"operation":"isCanView","attentionid":attentionid},function(data){
	  	   data=jQuery.trim(data);
	       if(data!="true"){
	       	 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(17545,user.getLanguage())%>");
	       }else{
	       	 jQuery("#"+inputid).val(id);
		     jQuery("#"+spanid).html(name);
		     createReport(index);
	       }
	  	});
	  }else{
	     jQuery("#"+inputid).val("");
	     jQuery("#"+spanid).html("");
	  }
  }
  
}
 
</script>	
</body>
</html>