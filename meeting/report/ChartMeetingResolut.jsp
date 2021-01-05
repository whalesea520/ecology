<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="StatisticComInfo" class="weaver.meeting.search.StatisticComInfo" scope="page" />
<jsp:setProperty name="StatisticComInfo" property="timeSag" param="timeSag"/>
<jsp:setProperty name="StatisticComInfo" property="subIds" param="subIds"/>
<jsp:setProperty name="StatisticComInfo" property="begindate" param="begindate"/>
<jsp:setProperty name="StatisticComInfo" property="enddate" param="enddate"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	
 	StatisticComInfo.setTimeSag(Util.getIntValue(request.getParameter("timeSag"))); 
 	StatisticComInfo.setSubIds(request.getParameter("subIds"));
 	StatisticComInfo.setDepIds(request.getParameter("depIds"));
 	StatisticComInfo.setSelectType(Util.getIntValue(request.getParameter("selectType")));
 	StatisticComInfo.setBegindate(request.getParameter("begindate"));
 	StatisticComInfo.setEnddate(request.getParameter("enddate"));
 	
 	String currentTime = request.getParameter("currentTime");
 	
 	
 	//-----会议决议提交情况,同缺席判断会议结束
    String resolutionSql="SELECT t2.name,sum(case when isdecision=2 then 1 else 0 end )as y,sum(case when isdecision!=2 then 1 else 0 end )as n "+   
			" FROM meeting t1 ,Meeting_Type t2,HrmResource t3 where t1.meetingtype=t2.id and t1.caller=t3.id and t1.repeatType = 0 "+
			" and (t1.meetingstatus =5 or (t1.meetingstatus =2 and (isdecision=2 or ";
	if(rs.getDBType().equals("oracle")){
    	resolutionSql+=" (t1.enddate||' '||decode(t1.endTime,'','00:00',t1.endTime)<'"+currentTime+"')))) ";
    }else{
    	resolutionSql+=" (t1.enddate+' '+(CASE t1.endTime WHEN '' then '00:00' ELSE t1.endTime END) <'"+currentTime+"')))) ";
    }
	//其他查询条件
	resolutionSql+=StatisticComInfo.getResolutSql()+" group by t2.name ";
	
	rs.executeSql(resolutionSql);
	//System.out.println("resolutionSql:"+resolutionSql);
	Map resMap=new HashMap();
    List xlist=new ArrayList();//X轴
    List ylist=new ArrayList();//yes数据
    List nlist=new ArrayList();//no数据
    while(rs.next()){
    	xlist.add(rs.getString("name"));
    	ylist.add(rs.getInt("y"));
    	nlist.add(rs.getInt("n"));
    }
    resMap.put("xList",xlist);
    resMap.put("yList",ylist);
    resMap.put("nList",nlist);
    String resolutJsonStr=JSONObject.fromObject(resMap).toString();
    //System.out.println(resolutJsonStr);
  
%>
<HTML>
  <HEAD>
  </HEAD>
  <BODY width=100% height=100%>
     <div id="ResolutionDiv" style="margin: 5 auto;min-width: 400px; height: 500px;"></div>
 </BODY>
<script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script>
<script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
	var jsonStr='<%=resolutJsonStr%>';
 	var jsonData=eval('('+jsonStr+')');
	var isInternetExplorer = navigator.userAgent.indexOf('MSIE') != -1;
	if(isInternetExplorer){
		setTimeout('showResolutionDiv()',800);
	}else{
		setTimeout('showResolutionDiv()',10);
	}	

function showResolutionDiv(){ 
		
	$('#ResolutionDiv').highcharts({
           chart: {
               type: 'column',
               
               borderWidth:0
           },
           title: {
               text:  '<%=SystemEnv.getHtmlLabelName(2194,user.getLanguage())+SystemEnv.getHtmlLabelName(725,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage())%>', //会议决议+提交+情况
               style: {
						color: '#000000',//#3E576F',
						fontSize: '24px'
					}
           },
           xAxis: {
               categories: jsonData.xList
           },
           yAxis: {
               min: 0,
               title: {
                   text: ' '
               },
	           allowDecimals:false
           },
           colors:['#4572A7','#AA4643'],
           credits: {
               enabled: false
           },       
	       lang: {
	           noData: "<%=SystemEnv.getHtmlLabelName(26161,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage()) %>"
	       },
           series: [
           {name: '<%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%>',data: jsonData.yList}, //已提交
           {name: '<%=SystemEnv.getHtmlLabelName(32555,user.getLanguage())%>',data: jsonData.nList}] //未提交
       });
 
}

</SCRIPT>