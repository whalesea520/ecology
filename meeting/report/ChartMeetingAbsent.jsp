<!DOCTYPE HTML>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="StatisticComInfo" class="weaver.meeting.search.StatisticComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%	
 	StatisticComInfo.setTimeSag(Util.getIntValue(request.getParameter("timeSag"))); 
 	StatisticComInfo.setSubIds(request.getParameter("subIds"));
 	StatisticComInfo.setDepIds(request.getParameter("depIds"));
 	StatisticComInfo.setSelectType(Util.getIntValue(request.getParameter("selectType")));
 	StatisticComInfo.setBegindate(request.getParameter("begindate"));
 	StatisticComInfo.setEnddate(request.getParameter("enddate"));
 	
 	String currentTime = request.getParameter("currentTime");
 	
 	//-----会议缺席次数排名,状态5结束,状态2正常,判断是否提交决议和时间判断
    //判断是否是oracle
    String absFiled=" t1.memberid,t3.lastname,t3.seclevel,sum(1) as total ";
    String absTable=" from Meeting_Member2 t1,Meeting t2 ,HrmResource t3 ";
	String absWhere=" where t1.meetingid=t2.id  and t1.memberid=t3.id and (t1.isattend is null or t1.isattend='2') and t2.repeatType = 0 "+
				" and (t2.meetingstatus =5 or (t2.meetingstatus=2 and (t2.isdecision=2 or ";
	if(rs.getDBType().equals("oracle")){
    	absWhere+=" (t2.enddate||' '||decode(t2.endTime,'','00:00',t2.endTime)<'"+currentTime+"')))) ";
    }else{
    	absWhere+=" (t2.enddate+' '+(CASE t2.endTime WHEN '' then '00:00' ELSE t2.endTime END) <'"+currentTime+"')))) ";
    }	
	String absGO=" GROUP BY t1.memberid,seclevel,t3.lastname  ORDER BY total desc ,seclevel,memberid desc ";
    String absentSql=absFiled+absTable+absWhere+StatisticComInfo.getAbsentSql()+absGO;
    if(rs.getDBType().equals("oracle")){
    	absentSql="select  * from (SELECT "+absentSql+" ) where rownum<=10 ";
    }else{
    	absentSql="SELECT top 10 "+absentSql;
    }
    rs.executeSql(absentSql);
    //System.out.println("absentSql:"+absentSql);
    Map map=null;
    List list=new ArrayList();
    String name="";
    while(rs.next()){
   		map= new HashMap();
    	map.put("name",rs.getString("lastname"));
    	map.put("y",rs.getInt("total"));
    	list.add(map);
    }
    String absentJsonStr=JSONArray.fromObject(list).toString();
%>
<HTML>
  <HEAD>
	
  </HEAD>
  <BODY width=100% height=100%>
     <div id="AbsentDiv" style="margin: 5 auto;margin-top:10px; min-width: 400px; height: 500px;"></div>
 </BODY>
 <script type="text/javascript" src="/js/highcharts/highcharts_wev8.js"></script>
 <script type="text/javascript" src="/js/highcharts/modules/no-data-to-display_wev8.js"></script>
<SCRIPT LANGUAGE="JavaScript">
	var isInternetExplorer = navigator.userAgent.indexOf('MSIE') != -1;	
	var jsonStr='<%=absentJsonStr%>';
 	var jsonData=eval('('+jsonStr+')');
 	if(isInternetExplorer){
		setTimeout('showAbsentDiv()',800);
	}else{
		setTimeout('showAbsentDiv()',10);
	}
function showAbsentDiv(){
	$('#AbsentDiv').highcharts({
          chart: {
              type: 'column',
              //borderColor: '#DADADA',
              borderWidth:0
          },
          title: {
              text: '<%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())+SystemEnv.getHtmlLabelName(32557,user.getLanguage())+SystemEnv.getHtmlLabelName(26755,user.getLanguage())+SystemEnv.getHtmlLabelName(352,user.getLanguage())+SystemEnv.getHtmlLabelName(19082,user.getLanguage()) %>',// 会议+缺席+次数+统计+排名',
              style: {
				color: '#000000',
				fontSize: '24px'
			}
          },
          tooltip:{
          		headerFormat: '<span style="font-size: 10px">{point.key}</span>',
				pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b><br/>'
          },
          xAxis: {
              type: 'category'
          },
          yAxis: {
              min: 0,
              title: {
                  text: ' '
              },
              allowDecimals:false
          },
          tooltip: {
            formatter: function() {
                var point = this.point,
                    s = '<b>'+ this.y +'</b><br/>';
                return s;
            }
        },
          credits: {
              enabled: false
          }, 
          legend:{
        	enabled:false
        },
        plotOptions: {
            series: {
                borderWidth: 0,
                dataLabels: {
                    enabled: true,
                }
            }
        },      
       lang: {
           noData: "<%=SystemEnv.getHtmlLabelName(26161,user.getLanguage())+SystemEnv.getHtmlLabelName(563,user.getLanguage()) %>" //没有 + 数据
       },
       series:[{
       		colorByPoint: true,
            data:  jsonData
        }]
      });
}
</SCRIPT>
</HTML>