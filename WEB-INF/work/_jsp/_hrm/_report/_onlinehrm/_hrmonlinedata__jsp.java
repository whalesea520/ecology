/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._report._onlinehrm;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.text.SimpleDateFormat;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.general.Util;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.general.*;
import weaver.conn.*;

public class _hrmonlinedata__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;
  
  public void
  _jspService(javax.servlet.http.HttpServletRequest request,
              javax.servlet.http.HttpServletResponse response)
    throws java.io.IOException, javax.servlet.ServletException
  {
    javax.servlet.http.HttpSession session = request.getSession(true);
    com.caucho.server.webapp.WebApp _jsp_application = _caucho_getApplication();
    javax.servlet.ServletContext application = _jsp_application;
    com.caucho.jsp.PageContextImpl pageContext = _jsp_application.getJspApplicationContext().allocatePageContext(this, _jsp_application, request, response, null, session, 8192, true, false);
    javax.servlet.jsp.PageContext _jsp_parentContext = pageContext;
    javax.servlet.jsp.JspWriter out = pageContext.getOut();
    final javax.el.ELContext _jsp_env = pageContext.getELContext();
    javax.servlet.ServletConfig config = getServletConfig();
    javax.servlet.Servlet page = this;
    response.setContentType("text/html; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
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
    
    splineCategories=splineCategories.length()==0?splineCategories:splineCategories.substring(1); //x\u8f74\u6570\u636e
    splineSeries=splineSeries.length()==0?splineSeries:splineSeries.substring(1); //y\u8f74\u6570\u636e
    
    columnCategories=columnCategories.length()==0?columnCategories:columnCategories.substring(1); //x\u8f74\u6570\u636e
    columnSeries=columnSeries.length()==0?columnSeries:columnSeries.substring(1); //y\u8f74\u6570\u636e
    
    if("".equals(maxDate))
    	maxWeek=-1;
    else	
    	maxWeek=TimeUtil.getDayOfWeek(maxDate); //\u661f\u671f
    resultstr="{splineData:{categoriesData:["+splineCategories+"],seriesData:["+splineSeries+"]},"+
    		    "columnData:{categoriesData:["+columnCategories+"],seriesData:["+columnSeries+"]},"+	
    		    "maxDate:'"+maxDate+"',maxTime:'"+maxTime+"',maxNum:'"+maxNum+"',maxWeek:"+maxWeek+"}";
	out.println(resultstr);
    

      out.write(_jsp_string2, 0, _jsp_string2.length);
    } catch (java.lang.Throwable _jsp_e) {
      pageContext.handlePageException(_jsp_e);
    } finally {
      _jsp_application.getJspApplicationContext().freePageContext(pageContext);
    }
  }

  private java.util.ArrayList _caucho_depends = new java.util.ArrayList();

  public java.util.ArrayList _caucho_getDependList()
  {
    return _caucho_depends;
  }

  public void _caucho_addDepend(com.caucho.vfs.PersistentDependency depend)
  {
    super._caucho_addDepend(depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  public boolean _caucho_isModified()
  {
    if (_caucho_isDead)
      return true;
    if (com.caucho.server.util.CauchoSystem.getVersionId() != 1886798272571451039L)
      return true;
    for (int i = _caucho_depends.size() - 1; i >= 0; i--) {
      com.caucho.vfs.Dependency depend;
      depend = (com.caucho.vfs.Dependency) _caucho_depends.get(i);
      if (depend.isModified())
        return true;
    }
    return false;
  }

  public long _caucho_lastModified()
  {
    return 0;
  }

  public java.util.HashMap<String,java.lang.reflect.Method> _caucho_getFunctionMap()
  {
    return _jsp_functionMap;
  }

  public void init(ServletConfig config)
    throws ServletException
  {
    com.caucho.server.webapp.WebApp webApp
      = (com.caucho.server.webapp.WebApp) config.getServletContext();
    super.init(config);
    com.caucho.jsp.TaglibManager manager = webApp.getJspApplicationContext().getTaglibManager();
    com.caucho.jsp.PageContextImpl pageContext = new com.caucho.jsp.PageContextImpl(webApp, this);
  }

  public void destroy()
  {
      _caucho_isDead = true;
      super.destroy();
  }

  public void init(com.caucho.vfs.Path appDir)
    throws javax.servlet.ServletException
  {
    com.caucho.vfs.Path resinHome = com.caucho.server.util.CauchoSystem.getResinHome();
    com.caucho.vfs.MergePath mergePath = new com.caucho.vfs.MergePath();
    mergePath.addMergePath(appDir);
    mergePath.addMergePath(resinHome);
    com.caucho.loader.DynamicClassLoader loader;
    loader = (com.caucho.loader.DynamicClassLoader) getClass().getClassLoader();
    String resourcePath = loader.getResourcePathSpecificFirst();
    mergePath.addClassPath(resourcePath);
    com.caucho.vfs.Depend depend;
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/report/onlineHrm/HrmOnlineData.jsp"), 7300120029010902558L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  static {
    _jsp_string1 = "\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
  }
}