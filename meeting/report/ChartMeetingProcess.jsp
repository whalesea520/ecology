<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="StatisticComInfo" class="weaver.meeting.search.StatisticComInfo" scope="page" />
<jsp:setProperty name="StatisticComInfo" property="timeSag" param="timeSag"/>
<jsp:setProperty name="StatisticComInfo" property="subIds" param="subIds"/>
<jsp:setProperty name="StatisticComInfo" property="depIds" param="depIds"/>
<jsp:setProperty name="StatisticComInfo" property="selectType" param="selectType"/>
<jsp:setProperty name="StatisticComInfo" property="begindate" param="begindate"/>
<jsp:setProperty name="StatisticComInfo" property="enddate" param="enddate"/>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	
 	StatisticComInfo.setTimeSag(Util.getIntValue(request.getParameter("timeSag"))); 
 	StatisticComInfo.setSubIds(request.getParameter("subIds"));
 	StatisticComInfo.setDepIds(request.getParameter("depIds"));
 	StatisticComInfo.setSelectType(Util.getIntValue(request.getParameter("selectType")));
 	StatisticComInfo.setBegindate(request.getParameter("begindate"));
 	StatisticComInfo.setEnddate(request.getParameter("enddate"));
 	
 	String currentTime = request.getParameter("currentTime");
 	
 	//-----会议完成情况统计
    String progressSql=" SELECT mt.name,sum(case when w.status!=0 then 1 else 0 end) as finish,";
    
    if(rs.getDBType().equals("oracle")){
		progressSql+=" sum(case when w.status=0 and (w.begindate||' '||decode(w.begintime,'','00:00',w.begintime))>'"+currentTime+"' then 1 else 0 end) as nostart,"+
				" sum(case when w.status=0 and (w.enddate||' '||decode(w.endtime,'','00:00',w.endtime))<'"+currentTime+"' then 1 else 0 end) as delay,"+
				" sum(case when w.status=0 and (w.begindate||' '||decode(w.begintime,'','00:00',w.begintime))<='"+currentTime+
				"' and (w.enddate||' '||decode(w.endtime,'','00:00',w.endtime))>='"+currentTime+"' then 1 else 0 end) as doing  ";
	}else{
		progressSql+=" sum(case when w.status=0 and (w.begindate+' '+(CASE w.begintime WHEN '' then '00:00' ELSE w.begintime END))>'"+currentTime+"' then 1 else 0 end) as nostart,"+
				" sum(case when w.status=0 and (w.enddate+' '+(CASE w.endtime WHEN '' then '00:00' ELSE w.endtime END))<'"+currentTime+"' then 1 else 0 end) as delay,"+
				" sum(case when w.status=0 and (w.begindate+' '+(CASE w.begintime WHEN '' then '00:00' ELSE w.begintime END))<='"+currentTime+
				"' and (w.enddate+' '+(CASE w.endtime WHEN '' then '00:00' ELSE w.endtime END))>='"+currentTime+"' then 1 else 0 end) as doing  ";
	}
	progressSql+=" from Meeting_Decision d, WorkPlan w, Meeting m,Meeting_Type mt,HrmResource t3 WHERE d.meetingid = m.id and m.repeatType = 0 ";
	if(rs.getDBType().equals("oracle")){
		progressSql+=" AND  w.meetingid = to_char(m.id) ";
	}else{
		progressSql+=" AND w.meetingid = convert(VARCHAR(100), m.id) ";
	}
		progressSql+=" AND d.subject = w.name AND d.hrmid01 = w.resourceid and m.meetingtype=mt.id and m.caller=t3.id "+StatisticComInfo.getProgressSql()+" group by mt.name ";			
	rs.executeSql(progressSql);
	//System.out.println("progressSql:"+progressSql);
	Map proMap=new HashMap();
    List xxlist=new ArrayList();//X轴
    List nolist=new ArrayList();//未开始数据
    List delaylist=new ArrayList();//延期数据
    List inglist=new ArrayList();//进行中数据
    List finishlist=new ArrayList();//完成数据
    while(rs.next()){
    	xxlist.add(rs.getString("name"));
    	nolist.add(rs.getInt("nostart"));
    	delaylist.add(rs.getInt("delay"));
    	inglist.add(rs.getInt("doing"));
    	finishlist.add(rs.getInt("finish"));
    }
    proMap.put("xList",xxlist);
    proMap.put("nList",nolist);
    proMap.put("dList",delaylist);
    proMap.put("iList",inglist);
    proMap.put("fList",finishlist);
    String progressJsonStr=JSONObject.fromObject(proMap).toString();
  
%>
<HTML>
  <HEAD>
  </HEAD>
  <BODY width=100% height=100%>
     <div id="ProgressDiv" style="margin: 5 auto;min-width: 400px; height: 500px;"></div>
 </BODY>
<script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script>
<script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
	var isInternetExplorer = navigator.userAgent.indexOf('MSIE') != -1;	
   	var jsonStr='<%=progressJsonStr%>';
 	var jsonData=eval('('+jsonStr+')');
	if(isInternetExplorer){
		setTimeout('showProgressDiv()',800);
	}else{
		setTimeout('showProgressDiv()',10);
	}
function showProgressDiv(){ 
	
	$('#ProgressDiv').highcharts({
           chart: {
               type: 'column',
                
               borderWidth:0
           },
           title: {
               text: '<%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())+SystemEnv.getHtmlLabelName(1332,user.getLanguage())+SystemEnv.getHtmlLabelName(555,user.getLanguage())+SystemEnv.getHtmlLabelName(622,user.getLanguage()) %>',// 会议+任务+完成+情况
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
           credits: {
               enabled: false
           },
           tooltip: {
               headerFormat: '<span style="font-size:10px">{point.key}</span><table>',
               pointFormat: '<tr><td style="color:{series.color};padding:0">{series.name}: </td>' +
                   '<td style="padding:0"><b>{point.y} </b></td></tr>',
               footerFormat: '</table>',
               shared: true,
               useHTML: true
           },
           series: [
           {name: '<%=SystemEnv.getHtmlLabelName(1979,user.getLanguage())%>',data: jsonData.nList}, //未开始
           {name: '<%=SystemEnv.getHtmlLabelName(32556,user.getLanguage())%>',data: jsonData.dList},//已延期
           {name: '<%=SystemEnv.getHtmlLabelName(1960,user.getLanguage())%>',data: jsonData.iList},//进行中
           {name: '<%=SystemEnv.getHtmlLabelName(1961,user.getLanguage())%>',data: jsonData.fList}//已完成
           ],
           colors:['#4F81BD','#C0504D','#9BBB59','#8064A2'],
           plotOptions: {
               column: {
                   pointPadding: 0.2,
                   borderWidth: 1
               }
           },       
	       lang: {
	           noData: "<%=SystemEnv.getHtmlLabelName(26161,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage()) %>"
	       }
       });
 
}

</SCRIPT>