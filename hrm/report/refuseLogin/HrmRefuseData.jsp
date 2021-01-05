
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String operation=Util.null2String(request.getParameter("operation"));
	String userid=""+user.getUID();
	Date date = new Date();
    SimpleDateFormat dateFormat= new SimpleDateFormat("yyyy-MM-dd");
    
    String sql = "";
    
    String resultstr="";
    String categoriesData="";
    String seriesData="";
    String maxDate="";
    String  maxTime="";
    String maxNum="";
    int maxWeek=0;
    
    String splineCategories="";
    String splineSeries="";
    
    String columnCategories="";
    String columnSeries="";
    
    Calendar calendar=Calendar.getInstance();
    String currentdate=TimeUtil.getCurrentDateString();
    int currentYear=calendar.get(Calendar.YEAR);
    int currentMonth=calendar.get(Calendar.MONTH)+1;
    
    if("day".equals(operation)){
    	
    	sql = "SELECT refuse_hour,refuse_num FROM HrmRefuseAvg WHERE refuse_date='"+currentdate+"' order by refuse_hour asc ";
	    rs.execute(sql);
	    
	    while(rs.next()){
	    	String onlineTime=(rs.getInt("refuse_hour")<10?"0"+rs.getInt("refuse_hour"):rs.getInt("refuse_hour"))+"";
	    	splineCategories=splineCategories+",'"+onlineTime+"'";
	    	splineSeries=splineSeries+","+rs.getString("refuse_num");
	    }
	    
	    sql="SELECT * FROM HrmRefuseAvg WHERE refuse_date='"+currentdate+"' ORDER BY refuse_num desc ";
	    rs.execute(sql);
	    if(rs.next()){
	    	maxNum=rs.getString("refuse_num");
	    	maxTime=(rs.getInt("refuse_hour")<10?("0"+rs.getInt("refuse_hour")):rs.getInt("refuse_hour"))+SystemEnv.getHtmlLabelName(81823,user.getLanguage());
	    	maxDate=rs.getString("refuse_date");
	    }
	    
    }else if("week".equals(operation)){
    	sql = "SELECT max(refuse_num) as max_num ,refuse_date FROM HrmRefuseAvg WHERE refuse_date>='"+TimeUtil.getWeekBeginDay()+"' AND refuse_date <= '"+TimeUtil.getWeekEndDay()+"' GROUP BY refuse_date ORDER BY refuse_date asc " ;
    	rs.execute(sql);
    	while(rs.next()){
    		splineCategories=splineCategories+",'"+rs.getString("refuse_date")+"'";
    		splineSeries=splineSeries+","+(int)rs.getDouble("max_num");
	    }
		
    	sql = "SELECT max(refuse_num) as max_num ,refuse_date FROM HrmRefuseAvg WHERE refuse_date>='"+TimeUtil.getWeekBeginDay()+"' AND refuse_date <= '"+TimeUtil.getWeekEndDay()+"' GROUP BY refuse_date ORDER BY max_num desc " ;
    	rs.execute(sql);
    	while(rs.next()){
    		columnCategories=columnCategories+",'"+rs.getString("refuse_date")+"'";
    		columnSeries=columnSeries+","+(int)rs.getDouble("max_num");
	    }
    	
		sql="SELECT * FROM HrmRefuseAvg WHERE refuse_date>='"+TimeUtil.getWeekBeginDay()+"' AND refuse_date <= '"+TimeUtil.getWeekEndDay()+"' ORDER BY refuse_num desc ";
	    rs.execute(sql);
	    if(rs.next()){
	    	maxNum=rs.getString("refuse_num");
	    	maxTime=(rs.getInt("refuse_hour")<10?("0"+rs.getInt("refuse_hour")):rs.getInt("refuse_hour"))+SystemEnv.getHtmlLabelName(81823,user.getLanguage());
	    	maxDate=rs.getString("refuse_date");
	    }
	    
    }else if("month".equals(operation)){
    	sql = "SELECT max(refuse_num) as max_num ,refuse_date FROM HrmRefuseAvg WHERE refuse_date>='"+TimeUtil.getMonthBeginDay()+"' AND refuse_date <= '"+TimeUtil.getMonthEndDay()+"' GROUP BY refuse_date ORDER BY refuse_date asc " ;
    	rs.execute(sql);
    	while(rs.next()){
    		splineCategories=splineCategories+",'"+rs.getString("refuse_date")+"'";
    		splineSeries=splineSeries+","+(int)rs.getDouble("max_num");
	    }
	    
    	if(rs.getDBType().equals("oracle"))
    		sql = "select * from (SELECT max(refuse_num) as max_num ,refuse_date FROM HrmRefuseAvg WHERE refuse_date>='"+TimeUtil.getMonthBeginDay()+"' AND refuse_date <= '"+TimeUtil.getMonthEndDay()+"' GROUP BY refuse_date ORDER BY max_num desc,refuse_date desc) t where rownum<=10 " ;
    	else
    		sql = "SELECT top 10 max(refuse_num) as max_num ,refuse_date FROM HrmRefuseAvg WHERE refuse_date>='"+TimeUtil.getMonthBeginDay()+"' AND refuse_date <= '"+TimeUtil.getMonthEndDay()+"' GROUP BY refuse_date ORDER BY max_num desc,refuse_date desc " ;
    	rs.execute(sql);
    	while(rs.next()){
    		columnCategories=columnCategories+",'"+rs.getString("refuse_date")+"'";
    		columnSeries=columnSeries+","+(int)rs.getDouble("max_num");
	    }
    	
	    sql="SELECT * FROM HrmRefuseAvg WHERE refuse_date>='"+TimeUtil.getMonthBeginDay()+"' AND refuse_date <= '"+TimeUtil.getMonthEndDay()+"' ORDER BY refuse_num desc ";
	    rs.execute(sql);
	    if(rs.next()){
	    	maxNum=rs.getString("refuse_num");
	    	maxTime=(rs.getInt("refuse_hour")<10?("0"+rs.getInt("refuse_hour")):rs.getInt("refuse_hour"))+SystemEnv.getHtmlLabelName(81823,user.getLanguage());
	    	maxDate=rs.getString("refuse_date");
	    }
	    
    }else if("quarter".equals(operation)){
    		sql = "SELECT max(refuse_num) as max_num,refuse_month FROM HrmRefuseAvg WHERE  refuse_month in "+TimeUtil.getQuarterMonth(currentMonth)+" and refuse_year="+currentYear+" GROUP BY refuse_month order by refuse_month asc ";
    		rs.execute(sql);
        	while(rs.next()){
        		int refuseMonth=rs.getInt("refuse_month");
        		splineCategories=splineCategories+",'"+currentYear+"-"+(refuseMonth<10?("0"+refuseMonth):refuseMonth)+"'";
        		splineSeries=splineSeries+","+(int)rs.getDouble("max_num");
    	    }
    	    
        	if(rs.getDBType().equals("oracle"))
        		sql = "select * from (SELECT max(refuse_num) as max_num,refuse_date FROM HrmRefuseAvg WHERE  refuse_month in "+TimeUtil.getQuarterMonth(currentMonth)+" and refuse_year="+currentYear+" GROUP BY refuse_date order by max_num desc,refuse_date desc) t where rownum<=10 ";
        	else
        		sql = "SELECT top 10 max(refuse_num) as max_num,refuse_date FROM HrmRefuseAvg WHERE  refuse_month in "+TimeUtil.getQuarterMonth(currentMonth)+" and refuse_year="+currentYear+" GROUP BY refuse_date order by max_num desc,refuse_date desc ";
        	rs.execute(sql);
        	while(rs.next()){
        		columnCategories=columnCategories+",'"+rs.getString("refuse_date")+"'";
        		columnSeries=columnSeries+","+(int)rs.getDouble("max_num");
    	    }
        	
    	    sql="SELECT * FROM HrmRefuseAvg WHERE refuse_month in "+TimeUtil.getQuarterMonth(currentMonth)+" and refuse_year="+currentYear+" ORDER BY refuse_num desc ";
    	    rs.execute(sql);
    	    if(rs.next()){
    	    	maxNum=rs.getString("refuse_num");
    	    	maxTime=(rs.getInt("refuse_hour")<10?("0"+rs.getInt("refuse_hour")):rs.getInt("refuse_hour"))+SystemEnv.getHtmlLabelName(81823,user.getLanguage());
    	    	maxDate=rs.getString("refuse_date");
    	    }
    }else if("year".equals(operation)){
    		sql = "SELECT max(refuse_num) as max_num,refuse_month FROM HrmRefuseAvg WHERE refuse_year="+currentYear+" GROUP BY refuse_month order by refuse_month asc ";
    		rs.execute(sql);
        	while(rs.next()){
        		int refuseMonth=rs.getInt("refuse_month");
        		splineCategories=splineCategories+",'"+currentYear+"-"+(refuseMonth<10?("0"+refuseMonth):refuseMonth)+"'";
        		splineSeries=splineSeries+","+(int)rs.getDouble("max_num");
    	    }
        	
        	if(rs.getDBType().equals("oracle"))
        		sql = "select * from (SELECT max(refuse_num) as max_num,refuse_date FROM HrmRefuseAvg WHERE refuse_year="+currentYear+" GROUP BY refuse_date order by max_num desc,refuse_date desc) t where rownum<=10 ";
        	else
        		sql = "SELECT top 10 max(refuse_num) as max_num,refuse_date FROM HrmRefuseAvg WHERE refuse_year="+currentYear+" GROUP BY refuse_date order by max_num desc,refuse_date desc ";
        	rs.execute(sql);
        	while(rs.next()){
        		columnCategories=columnCategories+",'"+rs.getString("refuse_date")+"'";
        		columnSeries=columnSeries+","+(int)rs.getDouble("max_num");
    	    }
    	    
    	    sql="SELECT * FROM HrmRefuseAvg WHERE refuse_year="+currentYear+" ORDER BY refuse_num desc,refuse_month desc,id desc ";
    	    rs.execute(sql);
    	    if(rs.next()){
    	    	maxNum=rs.getString("refuse_num");
    	    	maxTime=(rs.getInt("refuse_hour")<10?("0"+rs.getInt("refuse_hour")):rs.getInt("refuse_hour"))+SystemEnv.getHtmlLabelName(81823,user.getLanguage());
    	    	maxDate=rs.getString("refuse_date");
    	    }
    }else if("self_time".equals(operation)){
    	String begindate = request.getParameter("begindate");
    	String enddate = request.getParameter("enddate");
    	
    	if(rs.getDBType().equals("oracle"))
    		sql = "select * from (select max(refuse_num) as max_num,refuse_date FROM HrmRefuseAvg WHERE refuse_date >= '"+begindate+"' AND refuse_date <= '"+enddate+"' group by refuse_date ORDER BY max_num desc) t where rownum<=10 ";
    	else
    		sql = "select top 10 max(refuse_num) as max_num,refuse_date FROM HrmRefuseAvg WHERE refuse_date >= '"+begindate+"' AND refuse_date <= '"+enddate+"' group by refuse_date ORDER BY max_num desc";	
    	rs.execute(sql);
    	while(rs.next()){
    		columnCategories=columnCategories+",'"+rs.getString("refuse_date")+"'";
    		columnSeries=columnSeries+","+(int)rs.getDouble("max_num");
	    }
    	
    	sql="SELECT * FROM HrmRefuseAvg WHERE refuse_date>='"+begindate+"' AND refuse_date <= '"+enddate+"' ORDER BY refuse_num desc "; 
	    rs.execute(sql);
	    if(rs.next()){
	    	maxNum=rs.getString("refuse_num");
	    	maxTime=(rs.getInt("refuse_hour")<10?("0"+rs.getInt("refuse_hour")):rs.getInt("refuse_hour"))+SystemEnv.getHtmlLabelName(81823,user.getLanguage());
	    	maxDate=rs.getString("refuse_date");
	    }
    }
    
    splineCategories=splineCategories.length()==0?splineCategories:splineCategories.substring(1); //x轴数据
    splineSeries=splineSeries.length()==0?splineSeries:splineSeries.substring(1); //y轴数据
    
    columnCategories=columnCategories.length()==0?columnCategories:columnCategories.substring(1); //x轴数据
    columnSeries=columnSeries.length()==0?columnSeries:columnSeries.substring(1); //y轴数据
    
    if("".equals(maxDate))
    	maxWeek=-1;
    else	
    	maxWeek=TimeUtil.getDayOfWeek(maxDate); //星期
    resultstr="{splineData:{categoriesData:["+splineCategories+"],seriesData:["+splineSeries+"]},"+
    		    "columnData:{categoriesData:["+columnCategories+"],seriesData:["+columnSeries+"]},"+	
    		    "maxDate:'"+maxDate+"',maxTime:'"+maxTime+"',maxNum:'"+maxNum+"',maxWeek:"+maxWeek+"}";
	out.println(resultstr);
    
%>
