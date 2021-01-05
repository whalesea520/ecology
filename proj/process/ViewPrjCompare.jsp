<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<%@ page import="java.text.DecimalFormat" %>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectTransUtil" class="weaver.proj.util.ProjectTransUtil" scope="page" />
<jsp:useBean id="SQLUtil" class="weaver.proj.util.SQLUtil" scope="page" />
<jsp:useBean id="KnowledgeTransMethod" class="weaver.general.KnowledgeTransMethod" scope="page"/>
<jsp:useBean id="PrjTimeAndWorkdayUtil" class="weaver.proj.util.PrjTimeAndWorkdayUtil" scope="page" />
<%
String ProjID = Util.null2String(request.getParameter("ProjID"));
String versions = Util.null2String(request.getParameter("versions"));
String[] arr= versions.split(",");
if(!(arr!=null&&arr.length>=2)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
String nameQuery=Util.null2String(request.getParameter("flowTitle"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>

<style>
.progress-label {
     float: left;
     margin-left: 50%;
     margin-top: 5px;
     font-weight: bold;
     text-shadow: 1px 1px 0 #fff;
}
.ui-progressbar{ 
background : ; 
padding:1px; 
}	
.ui-progressbar-value{ 
background : #A5E994; 
} 

</style>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}
if("<%=isclose%>"=="1"){
	parentWin.closeDialog();	
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdReport_wev8.gif";
String titlename = "V"+arr[0]+""+SystemEnv.getHtmlLabelNames("83895",user.getLanguage())+"V"+arr[1]+""+SystemEnv.getHtmlLabelNames("83888",user.getLanguage())+"";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelNames("18553",user.getLanguage())+",javascript:onCompare(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<form name="weaver" id="weaver">
<input type="hidden" name="projid" value="<%=ProjID%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important;display:none;">
			<span id="advancedSearch" class="advancedSearch" style="display:none"><%=SystemEnv.getHtmlLabelNames("347",user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelNames("23036",user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>



</form>

<%
String sql1=" select "+SQLUtil.filteSql(RecordSet3.getDBType(), "dbo.getPrjTaskInfoBeginDate(t1.id,'"+arr[0]+"') as begindate,dbo.getPrjTaskInfoEndDate(t1.id,'"+arr[0]+"') as enddate,dbo.getPrjTaskInfoFinish(t1.id,'"+arr[0]+"') as finish ")+" from prj_projectinfo t1 where t1.id="+ProjID;
String sql2=" select "+SQLUtil.filteSql(RecordSet3.getDBType(), "dbo.getPrjTaskInfoBeginDate(t1.id,'"+arr[1]+"') as begindate,dbo.getPrjTaskInfoEndDate(t1.id,'"+arr[1]+"') as enddate,dbo.getPrjTaskInfoFinish(t1.id,'"+arr[1]+"') as finish ")+" from prj_projectinfo t1 where t1.id="+ProjID;
String sql3=" select "+SQLUtil.filteSql(RecordSet3.getDBType(), "dbo.getPrjBeginDate(t1.id) as begindate,dbo.getPrjEndDate(t1.id) as enddate,dbo.getPrjFinish(t1.id) as finish ")+" from prj_projectinfo t1 where t1.id="+ProjID;

String begindate1="";
String enddate1="";
String finish1="";
String begindate2="";
String enddate2="";
String finish2="";
String curBegindate="";
String curEnddate="";
String curFinish="";
RecordSet1.executeSql(sql1);
RecordSet2.executeSql(sql2);
RecordSet3.executeSql(sql3);
if(RecordSet1.next()){
	begindate1=RecordSet1.getString("begindate");
	enddate1=RecordSet1.getString("enddate");
	finish1=RecordSet1.getString("finish");
}
if(RecordSet2.next()){
	begindate2=RecordSet2.getString("begindate");
	enddate2=RecordSet2.getString("enddate");
	finish2=RecordSet2.getString("finish");
}
if(RecordSet3.next()){
	curBegindate=RecordSet3.getString("begindate");
	curEnddate=RecordSet3.getString("enddate");
	curFinish=RecordSet3.getString("finish");
}




//计算总工时
String totalworkday1 = "";
String totalworkday2 = "";
String totalworkday3 = "";
String totalbegintime1 = "";
String totalbegintime2 = "";
String totalbegintime3 = "";
String totalendtime1 = "";
String totalendtime2 = "";
String totalendtime3 = "";
Map<String,String> result1 = PrjTimeAndWorkdayUtil.getTimeForProj(begindate1,enddate1,"","",ProjID,arr[0]);
Map<String,String> result2 = PrjTimeAndWorkdayUtil.getTimeForProj(begindate2,enddate2,"","",ProjID,arr[1]);
Map<String,String> result3 = PrjTimeAndWorkdayUtil.getTimeForProj(curBegindate,curEnddate,"","",ProjID,"");
totalworkday1 = result1.get("totalworkday1");
totalworkday2 = result2.get("totalworkday1");
totalworkday3 = result3.get("totalworkday1");
totalbegintime1 = result1.get("totalbegintime");
totalbegintime2 = result2.get("totalbegintime");
totalbegintime3 = result3.get("totalbegintime");
totalendtime1 = result1.get("totalendtime");
totalendtime2 = result2.get("totalendtime");
totalendtime3 = result3.get("totalendtime");
DecimalFormat format = new DecimalFormat("0.00");
String begintime4 = format.format((double)TimeUtil.timeInterval(begindate1+" "+totalbegintime1+":00",begindate2+" "+totalbegintime2+":00")/ 60/60/24);
String endtime4 = format.format((double)TimeUtil.timeInterval(enddate1+" "+totalendtime1+":00", enddate2+" "+totalendtime2+":00")/ 60/60/24);
String begintime5 = format.format((double)TimeUtil.timeInterval(begindate2+" "+totalbegintime2+":00",curBegindate+" "+totalbegintime3+":00")/ 60/60/24);
String endtime5 = format.format((double)TimeUtil.timeInterval(enddate2+" "+totalendtime2+":00", curEnddate+" "+totalendtime3+":00")/ 60/60/24);

%>


<table class=ListStyle id="oTable"   border=0 cellspacing=1>
      	<COLGROUP>
		<COL width="20%">
		<COL width="15%">
		<COL width="15%">
		<COL width="15%">
		<COL width="35%">
          <tr class=header>
            <td><%=SystemEnv.getHtmlLabelNames("83890",user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelNames("22172",user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelNames("22169",user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelNames("22171",user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelNames("847",user.getLanguage())%></td>
          </tr>
          <tr class="DataLight">
          	<td><%=SystemEnv.getHtmlLabelNames("83891",user.getLanguage())%>（V<%=arr[1] %>）</td>
          	<td><%=totalworkday2 %></td>
          	<td><%=begindate2+" "+totalbegintime2 %></td>
          	<td><%=enddate2+" "+totalendtime2 %></td>
          	<td><%=KnowledgeTransMethod.getPercent(finish2, ProjectTransUtil.getPrjTaskProgressbar(curFinish, "")) %></td>
          </tr>
          <tr class="DataLight">
          	<td><%=SystemEnv.getHtmlLabelNames("83892",user.getLanguage())%>（V<%=arr[0] %>）</td>
          	<td><%=totalworkday1 %></td>
          	<td><%=begindate1+" "+totalbegintime1 %></td>
          	<td><%=enddate1+" "+totalendtime1 %></td>
          	<td><%=KnowledgeTransMethod.getPercent(finish1, ProjectTransUtil.getPrjTaskProgressbar(curFinish, "")) %></td>
          </tr>
          <tr class="DataLight">
          	<td><%=SystemEnv.getHtmlLabelNames("1356",user.getLanguage())%></td>
          	<td><%=totalworkday3 %></td>
          	<td><%=curBegindate+" "+totalbegintime3 %></td>
          	<td><%=curEnddate+" "+totalendtime3 %></td>
          	<td><%=KnowledgeTransMethod.getPercent(curFinish, ProjectTransUtil.getPrjTaskProgressbar(curFinish, "")) %></td>
          </tr>
          <tr class="DataLight">
          	<td>V<%=arr[0] %><%=SystemEnv.getHtmlLabelNames("83895",user.getLanguage())%>V<%=arr[1] %><%=SystemEnv.getHtmlLabelNames("83897",user.getLanguage())%></td>
          	<td><%=Math.abs( Double.valueOf(totalworkday2)-Double.valueOf(totalworkday1)) %></td>
          	<td><%=Math.abs(Double.valueOf(begintime4)) %></td>
          	<td><%=Math.abs(Double.valueOf(endtime4)) %></td>
          	<td></td>
          </tr>
          <tr class="DataLight">
          	<td><%=SystemEnv.getHtmlLabelNames("1356,83895",user.getLanguage())%>V<%=arr[1] %><%=SystemEnv.getHtmlLabelNames("83897",user.getLanguage())%></td>
          	<td><%=Math.abs( Double.valueOf(totalworkday3)-Double.valueOf(totalworkday3)) %></td>
          	<td><%=Math.abs(Double.valueOf(begintime5))%></td>
          	<td><%=Math.abs(Double.valueOf(endtime5)) %></td>
          	<td></td>
          </tr>
          
          
          
</table>


<%
if("1".equals(isDialog)){
	%>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>	
	
	<%
}
%>

<script type="text/javascript">
function initProgressbar(){
	$(".progressbar").each(function(i){
		var rate=parseInt($(this).attr("rate"));
		var status=parseInt($(this).attr("status"));
		$(this).find("div.progress-label").text(rate+"%");
		$(this).progressbar({value:rate});
		if(status===1){//overtime task
			$(this).find( ".ui-progressbar-value" ).css({'background':'#F9A9AA'});
		}
		
	});
}
function onBtnSearchClick(){
	weaver.submit();
}
$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	initProgressbar();
});
</script>
</BODY>
</HTML>
