
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@page import="java.text.SimpleDateFormat"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String operation=Util.null2String(request.getParameter("operation"));
	String serverip=Util.null2String(request.getParameter("serverip"));
	String userid=""+user.getUID();
	Date date = new Date();
    SimpleDateFormat dateFormat= new SimpleDateFormat("yyyy-MM-dd");
    
    String sql = "";
	String[] colors = {"#4572A7","#AA4643","#89A54E","#71588F","#4198AF","#DB843D","#93A9CF","#D19392","#B9CD96","#A99BBD"};
    
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
    String sqlwhere = "";
    if(serverip.length()>0){
    	sqlwhere += " and serverip='"+serverip+"' ";
    }
    if("day".equals(operation)){
    	
    	sql = "SELECT distinct point_time,max(online_num) as online_num FROM HrmOnlineAvg WHERE online_date='"+currentdate+"' "+sqlwhere+" group by  point_time order by point_time asc ";
    	rs.execute(sql);
	    
	    while(rs.next()){
	    	String onlineTime=(rs.getInt("point_time")<10?"0"+rs.getInt("point_time"):rs.getInt("point_time"))+":00";
	    	splineCategories=splineCategories+",'"+onlineTime+"'";
	    	splineSeries=splineSeries+","+rs.getString("online_num");
	    }
	    
	    sql="SELECT * FROM HrmOnlineCount WHERE online_date='"+currentdate+"' "+sqlwhere+" ORDER BY online_num desc ";
	    rs.execute(sql);
	    if(rs.next()){
	    	maxNum=rs.getString("online_num");
	    	maxTime=rs.getString("online_time");
	    	maxDate=rs.getString("online_date");
	    }
	    
    }else if("week".equals(operation)){
    	sql = "SELECT avg(online_num) as avg_num ,online_date FROM HrmOnlineAvg WHERE online_date>='"+TimeUtil.getWeekBeginDay()+"' AND online_date <= '"+TimeUtil.getWeekEndDay()+"' "+sqlwhere+" GROUP BY online_date ORDER BY online_date asc " ;
    	rs.execute(sql);
    	while(rs.next()){
    		splineCategories=splineCategories+",'"+rs.getString("online_date")+"'";
    		splineSeries=splineSeries+","+(int)rs.getDouble("avg_num");
	    }
		
    	sql = "SELECT avg(online_num) as avg_num ,online_date FROM HrmOnlineAvg WHERE online_date>='"+TimeUtil.getWeekBeginDay()+"' AND online_date <= '"+TimeUtil.getWeekEndDay()+"' "+sqlwhere+" GROUP BY online_date ORDER BY avg_num desc " ;
    	rs.execute(sql);
    	while(rs.next()){
    		columnCategories=columnCategories+",'"+rs.getString("online_date")+"'";
    		columnSeries=columnSeries+","+(int)rs.getDouble("avg_num");
	    }
    	
		sql="SELECT * FROM HrmOnlineCount WHERE online_date>='"+TimeUtil.getWeekBeginDay()+"' AND online_date <= '"+TimeUtil.getWeekEndDay()+"' "+sqlwhere+" ORDER BY online_num desc ";
	    rs.execute(sql);
	    if(rs.next()){
	    	maxNum=rs.getString("online_num");
	    	maxTime=rs.getString("online_time");
	    	maxDate=rs.getString("online_date");
	    }
	    
    }else if("month".equals(operation)){
    	sql = "SELECT avg(online_num) as avg_num ,online_date FROM HrmOnlineAvg WHERE online_date>='"+TimeUtil.getMonthBeginDay()+"' AND online_date <= '"+TimeUtil.getMonthEndDay()+"' "+sqlwhere+" GROUP BY online_date ORDER BY online_date asc " ;
    	rs.execute(sql);
    	while(rs.next()){
    		splineCategories=splineCategories+",'"+rs.getString("online_date")+"'";
    		splineSeries=splineSeries+","+(int)rs.getDouble("avg_num");
	    }
	    
    	if(rs.getDBType().equals("oracle"))
    		sql = "select * from (SELECT avg(online_num) as avg_num ,online_date FROM HrmOnlineAvg WHERE online_date>='"+TimeUtil.getMonthBeginDay()+"' AND online_date <= '"+TimeUtil.getMonthEndDay()+"' "+sqlwhere+" GROUP BY online_date ORDER BY avg_num desc,online_date desc) t where rownum<=10 " ;
    	else
    		sql = "SELECT top 10 avg(online_num) as avg_num ,online_date FROM HrmOnlineAvg WHERE online_date>='"+TimeUtil.getMonthBeginDay()+"' AND online_date <= '"+TimeUtil.getMonthEndDay()+"' "+sqlwhere+" GROUP BY online_date ORDER BY avg_num desc,online_date desc " ;
    	rs.execute(sql);
    	while(rs.next()){
    		columnCategories=columnCategories+",'"+rs.getString("online_date")+"'";
    		columnSeries=columnSeries+","+(int)rs.getDouble("avg_num");
	    }
    	
	    sql="SELECT * FROM HrmOnlineCount WHERE online_date>='"+TimeUtil.getMonthBeginDay()+"' AND online_date <= '"+TimeUtil.getMonthEndDay()+"' "+sqlwhere+" ORDER BY online_num desc ";
	    rs.execute(sql);
	    if(rs.next()){
	    	maxNum=rs.getString("online_num");
	    	maxTime=rs.getString("online_time");
	    	maxDate=rs.getString("online_date");
	    }
	    
    }else if("quarter".equals(operation)){
    		sql = "SELECT avg(online_num) as avg_num,online_month FROM HrmOnlineAvg WHERE  online_month in "+TimeUtil.getQuarterMonth(currentMonth)+" and online_year="+currentYear+" "+sqlwhere+" GROUP BY online_month order by online_month asc ";
    		rs.execute(sql);
        	while(rs.next()){
        		int onlineMonth=rs.getInt("online_month");
        		splineCategories=splineCategories+",'"+currentYear+"-"+(onlineMonth<10?("0"+onlineMonth):onlineMonth)+"'";
        		splineSeries=splineSeries+","+(int)rs.getDouble("avg_num");
    	    }
    	    
        	if(rs.getDBType().equals("oracle"))
        		sql = "select * from (SELECT avg(online_num) as avg_num,online_date FROM HrmOnlineAvg WHERE  online_month in "+TimeUtil.getQuarterMonth(currentMonth)+" and online_year="+currentYear+" "+sqlwhere+" GROUP BY online_date order by avg_num desc,online_date desc) t where rownum<=10 ";
        	else
        		sql = "SELECT top 10 avg(online_num) as avg_num,online_date FROM HrmOnlineAvg WHERE  online_month in "+TimeUtil.getQuarterMonth(currentMonth)+" and online_year="+currentYear+" "+sqlwhere+" GROUP BY online_date order by avg_num desc,online_date desc ";
        	rs.execute(sql);
        	while(rs.next()){
        		columnCategories=columnCategories+",'"+rs.getString("online_date")+"'";
        		columnSeries=columnSeries+","+(int)rs.getDouble("avg_num");
    	    }
        	
    	    sql="SELECT * FROM HrmOnlineCount WHERE online_month in "+TimeUtil.getQuarterMonth(currentMonth)+" and online_year="+currentYear+" "+sqlwhere+" ORDER BY online_num desc ";
    	    rs.execute(sql);
    	    if(rs.next()){
    	    	maxNum=rs.getString("online_num");
    	    	maxTime=rs.getString("online_time");
    	    	maxDate=rs.getString("online_date");
    	    }
    }else if("year".equals(operation)){
    		sql = "SELECT avg(online_num) as avg_num,online_month FROM HrmOnlineAvg WHERE online_year="+currentYear+" "+sqlwhere+" GROUP BY online_month order by online_month asc ";
    		rs.execute(sql);
        	while(rs.next()){
        		int onlineMonth=rs.getInt("online_month");
        		splineCategories=splineCategories+",'"+currentYear+"-"+(onlineMonth<10?("0"+onlineMonth):onlineMonth)+"'";
        		splineSeries=splineSeries+","+(int)rs.getDouble("avg_num");
    	    }
        	
        	if(rs.getDBType().equals("oracle"))
        		sql = "select * from (SELECT avg(online_num) as avg_num,online_date FROM HrmOnlineAvg WHERE online_year="+currentYear+" "+sqlwhere+" GROUP BY online_date order by avg_num desc,online_date desc) t where rownum<=10 ";
        	else
        		sql = "SELECT top 10 avg(online_num) as avg_num,online_date FROM HrmOnlineAvg WHERE online_year="+currentYear+" "+sqlwhere+" GROUP BY online_date order by avg_num desc,online_date desc ";
        	rs.execute(sql);
        	while(rs.next()){
        		columnCategories=columnCategories+",'"+rs.getString("online_date")+"'";
        		columnSeries=columnSeries+","+(int)rs.getDouble("avg_num");
    	    }
    	    
    	    sql="SELECT * FROM HrmOnlineCount WHERE online_year="+currentYear+" "+sqlwhere+" ORDER BY online_num desc,id desc ";
    	    rs.execute(sql);
    	    if(rs.next()){
    	    	maxNum=rs.getString("online_num");
    	    	maxTime=rs.getString("online_time");
    	    	maxDate=rs.getString("online_date");
    	    }
    }else if("self_time".equals(operation)){
    	String begindate = request.getParameter("begindate");
    	String enddate = request.getParameter("enddate");
    	
    	if(rs.getDBType().equals("oracle"))
    		sql = "select * from (select avg(online_num) as avg_num,online_date FROM HrmOnlineAvg WHERE online_date >= '"+begindate+"' AND online_date <= '"+enddate+"' "+sqlwhere+" group by online_date ORDER BY avg_num desc) t where rownum<=10 ";
    	else
    		sql = "select top 10 avg(online_num) as avg_num,online_date FROM HrmOnlineAvg WHERE online_date >= '"+begindate+"' AND online_date <= '"+enddate+"' "+sqlwhere+" group by online_date ORDER BY avg_num desc";	
    	rs.execute(sql);
    	while(rs.next()){
    		columnCategories=columnCategories+",'"+rs.getString("online_date")+"'";
    		columnSeries=columnSeries+","+(int)rs.getDouble("avg_num");
	    }
    	
    	sql="SELECT * FROM HrmOnlineCount WHERE online_date>='"+begindate+"' AND online_date <= '"+enddate+"' "+sqlwhere+" ORDER BY online_num desc "; 
	    rs.execute(sql);
	    if(rs.next()){
	    	maxNum=rs.getString("online_num");
	    	maxTime=rs.getString("online_time");
	    	maxDate=rs.getString("online_date");
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
