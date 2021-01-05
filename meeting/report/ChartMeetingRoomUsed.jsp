<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.sql.Timestamp" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="StatisticComInfo" class="weaver.meeting.search.StatisticComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%	
 	StatisticComInfo.setTimeSag(6); 
 	StatisticComInfo.setSubIds(request.getParameter("subIds"));
 	StatisticComInfo.setBegindate(request.getParameter("begindate"));
 	StatisticComInfo.setEnddate(request.getParameter("enddate"));
 	int totalTimes=Util.getIntValue(request.getParameter("total"),-1);
 	int mode=Util.getIntValue(request.getParameter("mode"));
 	String otherwhere = "";
 	String searchAddressSql = "select id,name,subcompanyid from MeetingRoom where (status=1 or status is null ) ";
 	otherwhere = StatisticComInfo.getMeetingUsedSql(1);
 	String groupSql=" group by id,name,subcompanyid ";
 	
 	Map map=null;
 	Map<String,Object> map1=new HashMap<String,Object>();
    List list=new ArrayList();
    String name="";
    String address = "";
 	String searchSql = "SELECT address from  meeting where repeatType=0 " + StatisticComInfo.getMeetingUsedSql(2);
 	rs.execute(searchSql);
 	System.out.println("searchSql==="+searchSql);
 	while(rs.next()){
 		address +=","+rs.getString("address")+",";
 	}
 	address  = address+",";
 	rs.executeSql(searchAddressSql + otherwhere + groupSql);
 	String count[] ;
 	while(rs.next()){
 			map=new HashMap();
 	    	map.put("name",rs.getString("name")+"("+SubCompanyComInfo.getSubCompanyname(rs.getString("subcompanyid"))+")");
 	    	count = address.split(","+rs.getString("id")+",");
 	    	map.put("y",totalTimes==0?0:(count.length - 1)*100.0/totalTimes);
 	    	list.add(map);
 	}
    String jsonStr=JSONArray.fromObject(list).toString();
%>
<HTML>
  <HEAD>
  </HEAD>
  <BODY width=100% height=100%>
     <div id="MeetingUsedDiv" style="min-width: 400px; height: 450px;"></div>
 </BODY>
<script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script>
<script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">

	var isInternetExplorer = navigator.userAgent.indexOf('MSIE') != -1;
	 
 	var mode="<%=mode%>";
	var jsonStr='<%=jsonStr%>';
	var jsonData=eval('('+jsonStr+')');
	if(isInternetExplorer){
		setTimeout('showMeetingUsedDiv()',mode==0?500:1500);
	}else{
		setTimeout('showMeetingUsedDiv()',10);
	}
 
	function showMeetingUsedDiv(){
   	// Build the chart
       $('#MeetingUsedDiv').highcharts({
           chart: {
               plotBackgroundColor: null,
               plotBorderWidth: null,
               plotShadow: false,
               //borderColor: '#DADADA',
              borderWidth:0
           },
           title: {
               text: "<%=SystemEnv.getHtmlLabelName(32527,user.getLanguage()) %>",
               style: {
					color: '#000000',//#3E576F',
					fontSize: '24px'
				}
           },
           tooltip: {
       	    pointFormat: '<b>{point.percentage:.2f}%</b>'
           },
           plotOptions: {
               pie: {
                   allowPointSelect: true,
                   cursor: 'pointer',
                   dataLabels: {
                       enabled: true,
                       color: '#000000',
	                   connectorColor: '#000000',
	                   distance: 30,
	                   format: '<b>{point.percentage:.2f}%</b>'
                   },
                   showInLegend: true
               }
           },
           series:[{
               type: 'pie',
               name: '<%=SystemEnv.getHtmlLabelName(32527,user.getLanguage()) %>',
               data:  jsonData
           }] ,
           credits: {
			enabled: false
		},       
        lang: {
           noData: "<%=SystemEnv.getHtmlLabelName(26161,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage()) %>"
        }
       });
      }

</SCRIPT>