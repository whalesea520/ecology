
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.blog.BlogDao"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.blog.WorkDayDao"%>
<%@page import="weaver.blog.BlogReportManager"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.blog.BlogManager"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo"></jsp:useBean>
<jsp:useBean id="appDao" class="weaver.blog.AppDao"></jsp:useBean>
<html>
<head>
<script type='text/javascript' src='js/timeline/lavalamp.min_wev8.js'></script>
<script type='text/javascript' src='js/timeline/easing_wev8.js'></script>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="css/blog_wev8.css" type=text/css rel=STYLESHEET>
<link href="js/timeline/lavalamp_wev8.css" rel="stylesheet" type="text/css"> 
<script type='text/javascript' src='js/blogUtil_wev8.js'></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>

<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
</head>
<%
String userid=""+user.getUID();
String from=Util.null2String(request.getParameter("from"));
String type=Util.null2String(request.getParameter("type"));

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
String monthStr=month<10?("0"+month):(""+month);

BlogManager blogManager=new BlogManager(user);
List attentionList=blogManager.getMyAttention(userid);
String titlename = "";
%>
<body style="height: 98%;">
<div id="divTopMenu"></div>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
   <%
     RCMenu += "{"+SystemEnv.getHtmlLabelName(26962,user.getLanguage())+",javascript:doCompare(),_self} ";
	 RCMenuHeight += RCMenuHeightStep ;
   %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if(attentionList.size()>0){ %>

<div style="width:100%;">
  <div align="center" id="reportTitle" class="reportTitle" style="display: <%=!"other".equals(from)?"block":"none"%>"><%=year+"-"+monthStr%> <%=SystemEnv.getHtmlLabelName(26943,user.getLanguage())%></div><!-- 关注报表 -->
  <div style="margin-top: 3px;margin-bottom: 15px">
       <div class="lavaLampHead">
      	 <div style="border-bottom:#b6b6b6 1px solid">
             <div style="width: 80%;float: left;">
					<ul class="lavaLamp" id="timeContent">
					  <%for(int i=startMonth;i<=endMonth;i++){ 
					      monthStr=i<10?("0"+i):("")+i;
					  %>
					     <li <%=i==month?"class='current'":""%>><a href="javascript:changeMonth(<%=year%>,<%=i%>,'<%=monthStr%>','<%=SystemEnv.getHtmlLabelName(26943,user.getLanguage())%>')"><%=i%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></a></li><!-- 月 -->
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
		  <a href="javascript:void())" onclick="changeReport(this,'blog')" style="margin-right: 8px;" class="items"><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></a><!-- 微博报表 -->
		  <%if(appDao.getAppVoByType("mood").isActive()){ %>
		  <a href="javascript:void())" onclick="changeReport(this,'mood')" style="margin-right: 8px;"><%=SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></a><!-- 心情报表 -->
		  <%} %>
	  </div>
	  <div style="float: right;">
	     <div class="remarkDiv" style="text-align: left;" id="blogRemarks">
	         <span style="margin-right: 8px"><img src="images/submit-no_wev8.png" align="absmiddle" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%></span>
	         <span  style="margin-right: 8px"><img src="images/submit-ok_wev8.png" align="absmiddle" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%></span>
	         <span  style="margin-right: 8px">"<%=SystemEnv.getHtmlLabelName(523 ,user.getLanguage())%>"<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>"<font color="red"><%=SystemEnv.getHtmlLabelName(15178 ,user.getLanguage())+SystemEnv.getHtmlLabelName(355,user.getLanguage())%></font>/<%=SystemEnv.getHtmlLabelName(26932 ,user.getLanguage())+SystemEnv.getHtmlLabelName(355,user.getLanguage())%>"</span>  
	     </div>
	     
	    <div class="remarkDiv" style="text-align: left;display: none;" id="moodRemarks">
	          <span  style="margin-right: 8px"><img src="images/mood-unhappy_wev8.png" align="absmiddle" width="16px" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(26918,user.getLanguage())%></span>
	          <span  style="margin-right: 8px"><img src="images/mood-happy_wev8.png" align="absmiddle" width="16px" style="margin-right: 5px" /><%=SystemEnv.getHtmlLabelName(26917,user.getLanguage())%></span>
	          <span  style="margin-right: 8px">"<%=SystemEnv.getHtmlLabelName(523 ,user.getLanguage())%>"<%=SystemEnv.getHtmlLabelName(15191,user.getLanguage())%>"<font color="red"><%=SystemEnv.getHtmlLabelName(26917 ,user.getLanguage())+SystemEnv.getHtmlLabelName(852,user.getLanguage())%></font>/<%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())+SystemEnv.getHtmlLabelName(852,user.getLanguage())%>"</span>
	    </div>
	  </div>
	</div>
    
    <div id="reportDiv">
    
    </div>
    <br>
    <br>
</div>
<%}else
	out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(26963 ,user.getLanguage())+"</div>");	//当前没有被关注的人
%>	
<script type="text/javascript">
   var type="blog";
   jQuery(document).ready(function(){
   	
   	jQuery("ul").find("li[class='current']").find("a").attr("style","color:#0185fe !important"); 
   	
    if(<%=attentionList.size()%>>0) {  
	     window.parent.displayLoading(1,"data");
	     jQuery("#reportDiv").load("attentionReportRecord.jsp?year=<%=year%>&month=<%=month%>&type=blog",function(){
	        window.parent.displayLoading(0);
	        jQuery('body').jNice();
	     });
	     jQuery(function(){jQuery(".lavaLamp").lavaLamp({ fx: "backout", speed: 700 })});
     }else
        window.parent.displayLoading(0); 
        
  });
  
   function selectBox(obj){
   	jQuery("input[type='checkbox']").each(function(){
		changeCheckboxStatus(this,obj.checked);
 	});
  }
  
 function changeMonth(year,month,monthstr,title){
 	 jQuery("ul li a").each(function(){
		 jQuery(this).removeAttr("style");  
  	  });
  	  jQuery(jQuery("ul").find("li")[month-1]).find("a").attr("style","color:#0185fe !important");
 	
    window.parent.displayLoading(1,"data");
    jQuery("#reportDiv").load("attentionReportRecord.jsp?year="+year+"&month="+month+"&type="+type,function(){
       window.parent.displayLoading(0);
       jQuery('body').jNice();
    });
    jQuery("#reportTitle").html(year+"-"+monthstr+" "+title);
    
    compareYear=year;
    compareMonth=month;
  }
  
  function changeYear(){
    window.parent.displayLoading(1,"page");
    var year=jQuery("#yearSelect").val();
    window.location.href="attentionReport.jsp?year="+year;
  } 
  
  function changeReport(obj,typeTemp){
	type=typeTemp;
	window.parent.displayLoading(1,"data");
	jQuery("#reportDiv").load("attentionReportRecord.jsp?year="+compareYear+"&month="+compareMonth+"&type="+type+"",function(){
	   window.parent.displayLoading(0);
       jQuery('body').jNice();
	});
	   jQuery(".reportTab a").removeClass("items");
	   jQuery(obj).addClass("items");
	   jQuery(".reportDiv").hide();
	   jQuery("#"+type+"ReportDiv").show();
	   jQuery(".remarkDiv").hide();
	   jQuery("#"+type+"Remarks").show();
  }
  var compareYear=<%=year%>;
  var compareMonth=<%=month%>;
  
  function compareChart(reportdiv,title,charType){
   var conType="";    
   var conValue="";
   var conditions=jQuery("#"+reportdiv).find(".condition:checked"); 
   if(conditions.length==0){
      window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(25763 ,user.getLanguage())%>"); //对不起，请选择人员!
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
	diag.Title =title;
	diag.URL = "/blog/compareChart.jsp?title="+title+"&conValue="+conValue+"&conType="+conType+"&year="+compareYear+"&month="+compareMonth+"&chartType="+charType;
    diag.show();
  }

//对比
function doCompare(){
   jQuery("#compareBtn").click();
}
  
</script>	
</body>
</html>