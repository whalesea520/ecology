
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@page import="weaver.hrm.company.DepartmentComInfo"%>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="net.sf.json.JSONObject"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="appDao" class="weaver.blog.AppDao"></jsp:useBean>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<head>
<script type='text/javascript' src='js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='js/timeline/easing_wev8.js'></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="css/css_wev8.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp_wev8.css" rel="stylesheet" type="text/css"> 
<link href="css/blog_wev8.css" rel="stylesheet" type="text/css"> 
<script type='text/javascript' src='js/blogUtil_wev8.js'></script>
<style>
 .name{padding-left:24px}
</style>
</head>
<%
String userid=""+user.getUID();
String content=Util.null2String(request.getParameter("orgid"));
String type=Util.null2String(request.getParameter("type"));

double index=0.0;
Calendar calendar=Calendar.getInstance();
int currentMonth=calendar.get(Calendar.MONTH)+1;
int currentYear=calendar.get(Calendar.YEAR);

int year=Util.getIntValue(request.getParameter("year"),currentYear);

String reportType=Util.null2String(request.getParameter("reportType"));
if("".equals(reportType)){
	reportType="blog";
}

SubCompanyComInfo subCompanyComInfo=new SubCompanyComInfo();
DepartmentComInfo departmentComInfo=new DepartmentComInfo();
BlogReportManager reportManager=new BlogReportManager();
reportManager.setUser(user);

String orgName=type.equals("2")? subCompanyComInfo.getSubCompanyname(content):departmentComInfo.getDepartmentname(content);

BlogDao blogDao=new BlogDao();
Map monthMap=blogDao.getCompaerMonth(year);
int startMonth=((Integer)monthMap.get("startMonth")).intValue();   //开始月份
int endMonth=((Integer)monthMap.get("endMonth")).intValue();       //结束月份

int month=Util.getIntValue(request.getParameter("month"),endMonth);
String monthStr=month<10?("0"+month):(""+month);

WorkDayDao dayDao=new WorkDayDao(user);
Map dayMap=dayDao.getStartAndEndOfMonth(year,month);
List totaldateList=(List)dayMap.get("totaldateList");

Map enbaleDate=blogDao.getEnableDate();
int enableYear=((Integer)enbaleDate.get("year")).intValue();      //微博开始使用年

Map blogResultMap= reportManager.getOrgReportCount(userid,content,type,year,month); 
%>
<body style="overflow: auto;padding-right: 10px !important; margin-left: 10px !important;">
<div style="overflow:auto;width: 100%;height: 100%;">
<%if(blogResultMap!=null){ 
  List isWorkdayList=(List)blogResultMap.get("isWorkdayList");
%>	
<div style="width:100%;">
  <div align="center" id="reportTitle" style="margin-top: 8px;" >
    <span id="titleSpan" style="font-weight: bold;font-size: 15px;color: #123885;"><%=year+"-"+monthStr+" "+orgName%></span>  
  </div>
  <div style="margin-top: 3px;margin-bottom: 15px;position: relative;">
          <div class="lavaLampHead">
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
				     <select style="width: 80px;" id="yearSelect" onchange="changeYear()">
				         <%
						   for(int i=currentYear;i>=enableYear;i--){ 
						 %>
						   <option value="<%=i%>" <%=i==year?"selected='selected'":""%>><%=i%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></option><!-- 年 -->
					    <%} %>
				     </select>
		         </div>
			</div>
    </div>
    <div id="blogReportDiv" style="overflow-x:auto;padding-bottom: 30px;width: 100%; ">
      <table id="blogReportList" style="width:100%;;border-collapse:collapse;margin-top: 3px"  border="1" cellspacing="0" bordercolor="#9db1ba" cellpadding="2" >
	    <tr style="" height="20px">
		    <td style="width: 65px;" class="tdWidth" nowrap="nowrap"></td>
		    <%
		      for(int i=0;i<totaldateList.size();i++){
		    	int day=((Integer)totaldateList.get(i)).intValue();
		        if(i<isWorkdayList.size()){
	    		  boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    	  if(isWorkday){
			%>
			      <td class="tdWidth" nowrap="nowrap"><%=day%></td>
			<%    		  
			    	  }
		    	  }else{
		    %>
		          <td class="tdWidth" nowrap="nowrap"><%=day%></td>
		    <%}}%>
		    <td style="width: 5%" align="center"><%=SystemEnv.getHtmlLabelName(26929,user.getLanguage())%></td><!-- 工作指数 -->
	    </tr>
    <%

        
    %>
    <%
		  List resultCountList=(List)blogResultMap.get("resultCountList");
		  int totalAttention=((Integer)blogResultMap.get("totalAttention")).intValue();
		  int totalUnsubmit=((Integer)blogResultMap.get("totalUnsubmit")).intValue();
		  int totalWorkday=((Integer)blogResultMap.get("totalWorkday")).intValue();
		  double workIndex=((Double)blogResultMap.get("workIndex")).doubleValue();
 %>
	<tr class="item">
	    <td align="left"><span style="cursor: pointer;" onclick="extendRecord(this,'<%=content%>',<%=type%>,<%=year%>,<%=month %>,'blog','<%=reportType %>')"  extend="false" isLoad='false' ><img src="images/extend_wev8.png"/><%=SystemEnv.getHtmlLabelName(26470,user.getLanguage())%></span></td><!-- 微博报表 -->
	    <%for(int i=0;i<totaldateList.size();i++){
	        if(i<resultCountList.size()){
	        	boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
	        	int unsubmit=((Integer)resultCountList.get(i)).intValue();
	        	if(isWorkday){
	    %>
	            <td style="width: 18px;" align="center"><span style="color:red"><%=unsubmit%></span>/<%=totalAttention%></td>
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
	    <td>
	    	<% 
	    	
	    			index=workIndex;
	    		
	    	%>
	    	<span title="<%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%><%=totalUnsubmit%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26932,user.getLanguage())%><%=totalWorkday*totalAttention%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(index)%></span><%=index%><a href="javascript:openChart('<%=reportType %>','<%=content%>',<%=2011%>,<%=type%>,'<%=orgName%><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
	
  <%
	if(appDao.getAppVoByType("mood").isActive()){
		  Map moodResultMap= reportManager.getOrgMoodReportCount(userid,content,type,year,month);  
	  	  if(moodResultMap!=null){
		  resultCountList=(List)moodResultMap.get("resultCountList");
		  isWorkdayList=(List)moodResultMap.get("isWorkdayList");
		  %>
		  <tr class="item">
	      <td align="left"><span style="cursor: pointer;" onclick="extendRecord(this,'<%=content%>',<%=type%>,<%=year%>,<%=month %>,'mood','mood')" extend="false" isLoad='false'><img src="images/extend_wev8.png"/><%=SystemEnv.getHtmlLabelName(26769,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></span></td>  <!-- 心情报表 -->
	    <%for(int i=0;i<totaldateList.size();i++){
	        if(i<resultCountList.size()){
	        	boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
	        	int unHappy=((Integer)((HashMap)resultCountList.get(i)).get("unhappy")).intValue();
			    int happy=((Integer)((HashMap)resultCountList.get(i)).get("happy")).intValue();
	        	if(isWorkday){
	    %>
	            <td style="width: 18px;" align="center"><span style="color:red"><%=unHappy%></span>/<%=unHappy+happy%></td>
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
	    <td>
	    
	    		<span title="<%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%><%=moodResultMap.get("totalUnHappyDays")%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%><%=moodResultMap.get("totalHappyDays") %><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>"><%=reportManager.getReportIndexStar(((Double)moodResultMap.get("totalMoodIndex")).doubleValue())%></span><%=moodResultMap.get("totalMoodIndex") %><a href="javascript:openChart('mood','<%=content%>',<%=2011%>,<%=type%>,'<%=orgName%><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%>')" style="text-decoration: none"><img src="images/chart_wev8.png" style="margin-left: 3px;border: 0px" align="absmiddle" /></a></td>
	</tr>
		  <%
	  }}
%>
</table>

  <table style="margin-top: 8px">
       <tr>
          <td><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>：<span style="margin-right: 8px"><img src="images/submit-no_wev8.png" align="absmiddle" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%></span></td>
          <td><span  style="margin-right: 8px"><img src="images/submit-ok_wev8.png" align="absmiddle" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%></span></td>
          <td><span  style="margin-right: 8px">"<%=SystemEnv.getHtmlLabelName(523 ,user.getLanguage())%>"<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>"<font color="red"><%=SystemEnv.getHtmlLabelName(15178 ,user.getLanguage())+SystemEnv.getHtmlLabelName(355,user.getLanguage())%></font>/<%=SystemEnv.getHtmlLabelName(26932 ,user.getLanguage())+SystemEnv.getHtmlLabelName(355,user.getLanguage())%>"</span>  </td>
       </tr>
       <%if(appDao.getAppVoByType("mood").isActive()){ %>
	       <tr>
	          <td style="padding-left: 38px"><span  style="margin-right: 8px"><img src="images/mood-unhappy_wev8.png" align="absmiddle" width="16px" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%></span></td>
	          <td><span  style="margin-right: 8px"><img src="images/mood-happy_wev8.png" align="absmiddle" width="16px" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%></span></td>
	          <td><span  style="margin-right: 8px">"<%=SystemEnv.getHtmlLabelName(523 ,user.getLanguage())%>"<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>"<font color="red"><%=SystemEnv.getHtmlLabelName(26918 ,user.getLanguage())+SystemEnv.getHtmlLabelName(852,user.getLanguage())%></font>/<%=SystemEnv.getHtmlLabelName(852,user.getLanguage())%>"</span></td>
	       </tr>
       <%} %>
   </table>

</div>	

</div>
<%}else{
	out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
}%>
</div> 

<script type="text/javascript">
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
	        jQuery.post("customReportRecord.jsp?reportType="+reportType+"&isAppend=true&isExtend=true&year="+year+"&month="+month+"&value="+value+"&conditionid="+conditionid+"&type="+type+"",function(data){
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
  });
  
 function changeMonth(year,month){
    window.parent.displayLoading(1,"page"); 
    window.location.href="orgReport.jsp?orgid=<%=content%>&type=<%=type%>&year="+year+"&month="+month+"&reportType=<%=reportType%>";
 }
 
 function changeYear(){
    window.parent.displayLoading(1,"page");
    var year=jQuery("#yearSelect").val();
    window.location.href="orgReport.jsp?orgid=<%=content%>&type=<%=type%>&year="+year+"&reportType=<%=reportType%>";
  } 
</script>	
</body>
</html>