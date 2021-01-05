/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._page._element._mycalendar;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.general.*;
import net.sf.json.JSONObject;
import weaver.hrm.User;
import weaver.hrm.HrmUserVarify;
import java.text.SimpleDateFormat;
import net.sf.json.JsonConfig;
import java.util.StringTokenizer;
import weaver.WorkPlan.WorkPlanShareUtil;
import weaver.WorkPlan.MutilUserUtil;
import weaver.systeminfo.SystemEnv;

public class _workplanviewoperation__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  	public String[] getDate(String startDate,String endDate,String planStart,String planEnd){
  		String format="yyyy-MM-dd";
  		String[] str=new String[2]; 
  		if("".equals(planStart)){
  			str[0]=startDate;
  		}else{
  			Date startDate1=TimeUtil.getString2Date(startDate,format);
  			Date planStart1=TimeUtil.getString2Date(planStart,format);
  			if(startDate1.before(planStart1)){
  				str[0]=planStart;
  			}else{
  				str[0]=startDate;
  			}
  		}
  		if("".equals(planEnd)){
  			str[1]=endDate;
  		}else{
  			Date endDate1=TimeUtil.getString2Date(endDate,format);
  			Date planEnd1=TimeUtil.getString2Date(planEnd,format);
  			if(endDate1.before(planEnd1)){
  				str[1]=endDate;
  			}else{
  				str[1]=planEnd;
  			}
  		}
  		return str;
  	}
  	
  	public void putEvent(String[] str,Map<String,Set<String>> map,String id){
  		String format="yyyy-MM-dd";
  		Date sd=TimeUtil.getString2Date(str[0],format);
  		Date ed=TimeUtil.getString2Date(str[1],format);
  		String tempStr=str[0];
  		if(sd.equals(ed)){
  			if(map.containsKey(tempStr)){
  				map.get(tempStr).add(id);
  			}else{
  				Set<String> set=new LinkedHashSet <String>();
  				set.add(id);
  				map.put(tempStr,set);
  			}
  		}else{
  			while(!sd.after(ed)){
  				tempStr=TimeUtil.getDateString(sd);
  				if(map.containsKey(tempStr)){
  					map.get(tempStr).add(id);
  				}else{
  					Set<String> set=new LinkedHashSet <String>();
  					set.add(id);
  					map.put(tempStr,set);
  				}
  				tempStr=TimeUtil.dateAdd(tempStr, 1);
  				sd=TimeUtil.getString2Date(tempStr,format);
  			}
  		}
  	}
  

  
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
    response.setContentType("application/x-json;charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.conn.RecordSet recordSet;
      recordSet = (weaver.conn.RecordSet) pageContext.getAttribute("recordSet");
      if (recordSet == null) {
        recordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("recordSet", recordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

	User user = HrmUserVarify.getUser(request, response);
	if(user == null)  return ;
	
	//onmousemove="coordinateReport()"
	/*
	 * \u9875\u9762\u53c2\u6570\u63a5\u6536
	 * \u6570\u636e\u5e93\u6570\u636e\u8bfb\u53d6
	 */
	Calendar thisCalendar = Calendar.getInstance(); //\u5f53\u524d\u65e5\u671f
	Calendar selectCalendar = Calendar.getInstance(); //\u7528\u4e8e\u663e\u793a\u7684\u65e5\u671f

	int countDays = 0; //\u9700\u8981\u663e\u793a\u7684\u5929\u6570
	int offsetDays = 0; //\u76f8\u5bf9\u663e\u793a\u663e\u793a\u7b2c\u4e00\u5929\u7684\u504f\u79fb\u5929\u6570
	String thisDate = ""; //\u5f53\u524d\u65e5\u671f
	String selectDate = ""; //\u7528\u4e8e\u663e\u793a\u65e5\u671f

	String beginDate = "";
	String endDate = "";

	String beginYear = "";
	String beginMonth = "";
	String beginDay = "";

	String endYear = "";
	String endMonth = "";
	String endDay = "";

	//\u53c2\u6570\u4f20\u9012
	String userId = String.valueOf(user.getUID()); //\u5f53\u524d\u7528\u6237Id
	String userType = user.getLogintype(); //\u5f53\u524d\u7528\u6237\u7c7b\u578b
	
	String selectUser = Util.null2String(request.getParameter("selectUser")); //\u88ab\u9009\u62e9\u7528\u6237Id				
	String viewType = "3";//\u6708\u89c6\u56fe
	String selectDateString = Util.null2String(request.getParameter("selectdate")); //\u88ab\u9009\u62e9\u65e5\u671f

	boolean appendselectUser = false;

	if ("".equals(selectUser) || userId.equals(selectUser)) {
		appendselectUser = true;
		selectUser = userId;
	}
	selectUser = selectUser.replaceAll(",", "");

	boolean belongshow=MutilUserUtil.isShowBelongto(user);
	String belongids="";
	if(belongshow){
		belongids=User.getBelongtoidsByUserId(user.getUID());
	}
	
	String thisYear = Util.add0((thisCalendar.get(Calendar.YEAR)), 4); //\u5f53\u524d\u5e74
	String thisMonth = Util.add0(
			(thisCalendar.get(Calendar.MONTH)) + 1, 2); //\u5f53\u524d\u6708
	String thisDayOfMonth = Util.add0((thisCalendar
			.get(Calendar.DAY_OF_MONTH)), 2); //\u5f53\u524d\u65e5
	thisDate = thisYear + "-" + thisMonth + "-" + thisDayOfMonth;

	if (!"".equals(selectDateString))
	//\u5f53\u9009\u62e9\u65e5\u671f
	{
		int selectYear = Util.getIntValue(selectDateString.substring(0,
				4)); //\u88ab\u9009\u62e9\u5e74
		int selectMonth = Util.getIntValue(selectDateString.substring(
				5, 7)) - 1; //\u88ab\u9009\u62e9\u6708
		int selectDay = Util.getIntValue(selectDateString.substring(8,
				10)); //\u88ab\u9009\u62e9\u65e5
		selectCalendar.set(selectYear, selectMonth, selectDay);
	}

	String selectYear = Util.add0((selectCalendar.get(Calendar.YEAR)),
			4); //\u5e74 
	String selectMonth = Util.add0(
			(selectCalendar.get(Calendar.MONTH)) + 1, 2); // \u6708
	String selectDayOfMonth = Util.add0((selectCalendar
			.get(Calendar.DAY_OF_MONTH)), 2); //\u65e5    
	String selectWeekOfYear = String.valueOf(selectCalendar
			.get(Calendar.WEEK_OF_YEAR)); //\u7b2c\u51e0\u5468
	String selectDayOfWeek = String.valueOf(selectCalendar
			.get(Calendar.DAY_OF_WEEK)); //\u4e00\u5468\u7b2c\u51e0\u5929
	selectDate = selectYear + "-" + selectMonth + "-"
			+ selectDayOfMonth;

 
	//\u6708\u8ba1\u5212\u663e\u793a
	selectCalendar.set(Calendar.DATE, 1); //\u8bbe\u7f6e\u4e3a\u6708\u7b2c\u4e00\u5929
	int offsetDayOfWeek = selectCalendar.get(Calendar.DAY_OF_WEEK) - 1;
	offsetDays = Integer.parseInt(selectDayOfMonth) - 1
			+ offsetDayOfWeek;
	selectCalendar.add(Calendar.DAY_OF_WEEK, -1 * offsetDayOfWeek); //\u8bbe\u7f6e\u4e3a\u6708\u9996\u65e5\u90a3\u5468\u7684\u7b2c\u4e00\u5929
 
	beginYear = Util.add0(selectCalendar.get(Calendar.YEAR), 4); //\u5e74 
	beginMonth = Util.add0(selectCalendar.get(Calendar.MONTH) + 1, 2); // \u6708
	beginDay = Util.add0(selectCalendar.get(Calendar.DAY_OF_MONTH), 2); //\u65e5 
	beginDate = beginYear + "-" + beginMonth + "-" + beginDay;
	 
	//\u6708\u8ba1\u5212\u663e\u793a
	selectCalendar.add(Calendar.DATE, offsetDays);
	//System.out.println("######" + selectCalendar.get(Calendar.DATE));
	selectCalendar.set(Calendar.DATE, 1); //\u8bbe\u7f6e\u4e3a\u6708\u7b2c\u4e00\u5929
	selectCalendar.add(Calendar.MONTH, 1);
	selectCalendar.add(Calendar.DATE, -1);
	countDays = selectCalendar.get(Calendar.DAY_OF_MONTH); //\u5f53\u6708\u5929\u6570
	int offsetDayOfWeekEnd = 7 - selectCalendar
			.get(Calendar.DAY_OF_WEEK);
	selectCalendar.add(Calendar.DAY_OF_WEEK, offsetDayOfWeekEnd); //\u8bbe\u7f6e\u4e3a\u6708\u672b\u65e5\u90a3\u5468\u7684\u6700\u540e\u4e00\u5929
	 
	endYear = Util.add0(selectCalendar.get(Calendar.YEAR), 4); //\u5e74 
	endMonth = Util.add0(selectCalendar.get(Calendar.MONTH) + 1, 2); // \u6708
	endDay = Util.add0(selectCalendar.get(Calendar.DAY_OF_MONTH), 2); //\u65e5
	endDate = endYear + "-" + endMonth + "-" + endDay; 
	
	String overColor = "";
	String archiveColor = "";
	String archiveAvailable = "0";
	String overAvailable = "0";
	String oversql = "select * from overworkplan order by workplanname desc";
	recordSet.executeSql(oversql);
	while (recordSet.next()) {
		String id = recordSet.getString("id");
		String workplanname = recordSet.getString("workplanname");
		String workplancolor = recordSet.getString("workplancolor");
		String wavailable = recordSet.getString("wavailable");
		if ("1".equals(id)) {
			overColor = workplancolor;
			if ("1".equals(wavailable))
				overAvailable = "1";
		} else {
			archiveColor = workplancolor;
			if ("1".equals(wavailable))
				archiveAvailable = "2";
		}
	}
	if ("".equals(overColor)) {
		overColor = "#c3c3c2";
	}
	if ("".equals(archiveColor)) {
		archiveColor = "#937a47";
	}
	//String temptable = WorkPlanShareBase.getTempTable(userId);
	StringBuffer sqlStringBuffer = new StringBuffer();

	sqlStringBuffer
			.append("SELECT C.*,overworkplan.workplancolor FROM (SELECT * FROM ");
	sqlStringBuffer.append("(");
	sqlStringBuffer
			.append("SELECT name,begindate,begintime ,enddate,endtime,workPlan.id,status,type_n, workPlanType.workPlanTypeColor");
	sqlStringBuffer
			.append(" FROM WorkPlan workPlan, WorkPlanType workPlanType");
	//\u663e\u793a\u6240\u6709\u65e5\u7a0b\uff0c\u5305\u542b\u5df2\u7ed3\u675f\u65e5\u7a0b
	//sqlStringBuffer.append(" WHERE (workPlan.status = 0 or workPlan.status = 1 or workPlan.status = 2)");
	sqlStringBuffer.append(" WHERE (workPlan.status = 0 ");
	if("1".equals(overAvailable)){
		sqlStringBuffer.append(" or workPlan.status =1 ");
	}
	if("2".equals(archiveAvailable)){
		sqlStringBuffer.append(" or workPlan.status =2 ");
	}
	sqlStringBuffer.append(" ) ");
	//sqlStringBuffer.append(Constants.WorkPlan_Status_Unfinished);
	/** Add By Hqf for TD9970 Start **/
	sqlStringBuffer.append(" AND workPlan.deleted <> 1");
	/** Add By Hqf for TD9970 End **/
	sqlStringBuffer
			.append(" AND workPlan.type_n = workPlanType.workPlanTypeId");
	sqlStringBuffer.append(" AND workPlan.createrType = '" + userType
			+ "'");
	
	sqlStringBuffer.append(" AND (");

	sqlStringBuffer.append("(");
	if (recordSet.getDBType().equals("oracle")) {
		sqlStringBuffer
				.append(" ','||workPlan.resourceID||',' LIKE '%,"
						+ selectUser + ",%'");
	} else {
		sqlStringBuffer
				.append(" ','+workPlan.resourceID+',' LIKE '%,"
						+ selectUser + ",%'");
	}
	if(!"".equals(belongids)){
		StringTokenizer idsst = new StringTokenizer(belongids, ",");
		while (idsst.hasMoreTokens()) {
			String id = idsst.nextToken();
			if (recordSet.getDBType().equals("oracle")) {
				sqlStringBuffer
						.append(" OR ','||workPlan.resourceID||',' LIKE '%,"
								+ id + ",%'");
			} else {
				sqlStringBuffer
						.append(" OR ','+workPlan.resourceID+',' LIKE '%,"
								+ id + ",%'");
			}
		}
	}
	sqlStringBuffer.append(")");
	
	sqlStringBuffer.append(" )");


	sqlStringBuffer.append(" AND ( workPlan.beginDate <= '");
	sqlStringBuffer.append(endDate);
	sqlStringBuffer.append("' AND workPlan.endDate >= '");
	sqlStringBuffer.append(beginDate);
	sqlStringBuffer.append("') ");
	sqlStringBuffer.append(" ) A ) C");
	sqlStringBuffer.append(" LEFT JOIN overworkplan ON overworkplan.id=c.status ");
	//sqlStringBuffer.append(" ORDER BY beginDate asc, beginTime ASC");
	sqlStringBuffer.append(" ORDER BY enddate asc, endtime ASC,beginDate asc, beginTime ASC");
	recordSet.executeSql(sqlStringBuffer.toString());
	//recordSet.writeLog(sqlStringBuffer.toString());
	Map result = new HashMap();
	SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm");
	SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	SimpleDateFormat format3 = new SimpleDateFormat("HH:mm");
	Map<String,List> dateMap=new HashMap<String,List>();
	String begindate1="";
	String begintime="";
	String enddate1="";
	String showEndDate="";
	String endTime="";
	List event =null;
	Date timeDate=null;
	Map eventMap=new HashMap();
	String id="";
	Map dateResult = new HashMap();
	while (recordSet.next()) {
		try {
			begindate1=recordSet.getString("begindate").trim();
			boolean isAllDay = false;
			if("".equals(begindate1)) continue;
			id=recordSet.getString("id");
			begintime=recordSet.getString("begintime").trim();
			enddate1=recordSet.getString("enddate").trim();
			
			begintime="".equals(begintime)?"00:00":begintime;
			event= new ArrayList();
			event.add(id);
			event.add(recordSet.getString("name"));
			event.add(begindate1);
			event.add(begintime);
			timeDate=TimeUtil.getString2Date(begintime,"HH:mm");
			event.add(timeDate.getHours()<12?"AM":"PM");
			Date startDate = format2.parse(begindate1+ " " + begintime);
			if (format2.parse(beginDate + " 00:00").getTime()
					- startDate.getTime() > 0) {
				beginDate = recordSet.getString("begindate");
			}
			showEndDate=enddate1;
			if (!"".equals(enddate1)) {
				endTime = recordSet.getString("endtime");
				if ("".equals(endTime.trim())) {
					endTime = "23:59";
				}
				Date endDate2 = format2.parse(enddate1+ " " + endTime);
			}else{
				showEndDate="";
				enddate1=begindate1;//;
				endTime = "23:59";
			}
			if(recordSet.getInt("status")==0){
				event.add(recordSet.getString("workPlanTypeColor"));//\u989c\u8272
			}else{
				event.add(recordSet.getString("workplancolor"));//\u989c\u8272
			}
			event.add(begindate1+" "+begintime+("".equals(showEndDate)?"":SystemEnv.getHtmlLabelName(15322,user.getLanguage())+(enddate1+" "+endTime)));
			putEvent(getDate(beginDate,endDate,begindate1,enddate1),dateResult,id);

		} catch (Exception e) {
			
		}
		eventMap.put(id,event);
	}

	result.put("events", eventMap);
	result.put("dateevents", dateResult);
	result.put("start", beginDate + " 00:00");
	result.put("end", endDate + " 23:59");

	JSONObject obj = JSONObject.fromObject(result);
	out.clearBuffer();
	out.print(obj.toString());

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/element/MyCalendar/WorkPlanViewOperation.jsp"), -834295109523955757L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n".toCharArray();
  }
}
