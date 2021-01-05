/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._meeting._data;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.Date;
import java.sql.Timestamp;
import weaver.systeminfo.*;
import java.text.SimpleDateFormat;
import weaver.general.Util;
import weaver.meeting.MeetingShareUtil;

public class _getdata__jsp extends com.caucho.jsp.JavaPage
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
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet recordSet;
      recordSet = (weaver.conn.RecordSet) pageContext.getAttribute("recordSet");
      if (recordSet == null) {
        recordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("recordSet", recordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.cpt.capital.CapitalComInfo CapitalComInfo;
      CapitalComInfo = (weaver.cpt.capital.CapitalComInfo) pageContext.getAttribute("CapitalComInfo");
      if (CapitalComInfo == null) {
        CapitalComInfo = new weaver.cpt.capital.CapitalComInfo();
        pageContext.setAttribute("CapitalComInfo", CapitalComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.meeting.Maint.MeetingRoomComInfo MeetingRoomComInfo;
      MeetingRoomComInfo = (weaver.meeting.Maint.MeetingRoomComInfo) pageContext.getAttribute("MeetingRoomComInfo");
      if (MeetingRoomComInfo == null) {
        MeetingRoomComInfo = new weaver.meeting.Maint.MeetingRoomComInfo();
        pageContext.setAttribute("MeetingRoomComInfo", MeetingRoomComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.company.SubCompanyComInfo SubCompanyComInfo;
      SubCompanyComInfo = (weaver.hrm.company.SubCompanyComInfo) pageContext.getAttribute("SubCompanyComInfo");
      if (SubCompanyComInfo == null) {
        SubCompanyComInfo = new weaver.hrm.company.SubCompanyComInfo();
        pageContext.setAttribute("SubCompanyComInfo", SubCompanyComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.company.DepartmentComInfo DepartmentComInfo;
      DepartmentComInfo = (weaver.hrm.company.DepartmentComInfo) pageContext.getAttribute("DepartmentComInfo");
      if (DepartmentComInfo == null) {
        DepartmentComInfo = new weaver.hrm.company.DepartmentComInfo();
        pageContext.setAttribute("DepartmentComInfo", DepartmentComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.crm.Maint.CustomerInfoComInfo CustomerInfoComInfo;
      CustomerInfoComInfo = (weaver.crm.Maint.CustomerInfoComInfo) pageContext.getAttribute("CustomerInfoComInfo");
      if (CustomerInfoComInfo == null) {
        CustomerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
        pageContext.setAttribute("CustomerInfoComInfo", CustomerInfoComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.meeting.defined.MeetingFieldComInfo MeetingFieldComInfo;
      MeetingFieldComInfo = (weaver.meeting.defined.MeetingFieldComInfo) pageContext.getAttribute("MeetingFieldComInfo");
      if (MeetingFieldComInfo == null) {
        MeetingFieldComInfo = new weaver.meeting.defined.MeetingFieldComInfo();
        pageContext.setAttribute("MeetingFieldComInfo", MeetingFieldComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      

String method = Util.null2String(request.getParameter("method"));
String showdate = Util.null2String(request.getParameter("showdate"));
String timezone = Util.null2String(request.getParameter("timezone"));
String viewtype = Util.null2String(request.getParameter("viewtype"));

if("list".equals(method)){
	request.getRequestDispatcher("/meeting/data/CalendarData.jsp").forward(request,response);
} else if("getNextMeeting".equals(method)){
	weaver.hrm.User user = weaver.hrm.HrmUserVarify.getUser(request, response);
	String userid = Util.null2String(request.getParameter("userid"));
	String divname = Util.null2String(request.getParameter("divname"));
	if("".equals(userid)){
		userid = ""+user.getUID();
	}
	String allUser=MeetingShareUtil.getAllUser(user);
	Date newdate = new Date() ;
	long datetime = newdate.getTime() ;
	Timestamp timestamp = new Timestamp(datetime) ;
	String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
	String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16);
				
	StringBuffer sqlStringBuffer = new StringBuffer();
	sqlStringBuffer.append("select t1.id,t1.name,t1.address,t1.customizeAddress,t1.caller,t1.contacter,t1.begindate,t1.begintime,t1.enddate,t1.endtime,t1.meetingstatus,t1.isdecision ");
	sqlStringBuffer.append(" from Meeting_ShareDetail t2,   Meeting t1 , Meeting_Type  t ");
	
	sqlStringBuffer.append(" WHERE ");
	sqlStringBuffer.append(" (t1.id = t2.meetingId) AND t1.isdecision <> 2 and t1.repeatType = 0");
	sqlStringBuffer.append(" and (t1.meetingStatus IN (2, 4) AND (t2.userId in(" + allUser + ")) )");
	sqlStringBuffer.append(" and t1.meetingStatus > 1 and (t1.cancel <> 1 or t1.cancel is null) ");
	sqlStringBuffer.append(" AND ((t1.begindate > '");
	sqlStringBuffer.append(CurrentDate);
	sqlStringBuffer.append("') OR (t1.beginDate = '");
	sqlStringBuffer.append(CurrentDate);
	sqlStringBuffer.append("' And t1.begintime > = '");
	sqlStringBuffer.append(CurrentTime);
	sqlStringBuffer.append("' ) ) ");
	sqlStringBuffer.append(" AND ( exists ( select 1 from Meeting_Member2 where t1.id = Meeting_Member2.meetingid and Meeting_Member2.memberid in ("+ allUser +")) or t1.caller in ("+ allUser+") or t1.contacter in( "+allUser +") ) ");
	sqlStringBuffer.append(" order by t1.beginDate, t1.begintime,t1.id ");
	//System.out.println("sql2:"+sqlStringBuffer.toString());
	recordSet.executeSql(sqlStringBuffer.toString());
	String startDate = "";
	String startTime = "";
	String endDate = "";
	String endTime = "";
	String sdt = "";
	String edt = "";
	String sTime = "";
	String meetingRoom = "";
	String meetingname = "";
	String caller = "";
	String members = "";
	if(recordSet.next()){
		startDate = recordSet.getString("beginDate");
		startTime = recordSet.getString("begintime");
		endDate = recordSet.getString("endDate");
		endTime = recordSet.getString("endtime");
		SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm");
		SimpleDateFormat format2 = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		//System.out.println("startTime:"+startTime);
		Date sDate = format2.parse(startDate.trim()	+ " " + startTime.trim());
		sTime = format.format(sDate);
		sdt = startDate.trim()	+ " " + startTime.trim();
		edt = endDate.trim()	+ " " + endTime.trim();
		//System.out.println("sTime:"+sTime);
		meetingRoom = MeetingRoomComInfo.getMeetingRoomInfoname(Util.null2String(recordSet.getString("address")));
		if(meetingRoom == null || "".equals(meetingRoom)){
			meetingRoom = Util.null2String(recordSet.getString("customizeAddress")+"("+SystemEnv.getHtmlLabelName(19516,user.getLanguage())+")");
		}
		meetingname = recordSet.getString("name");
		caller = ResourceComInfo.getLastname(Util.null2String(recordSet.getString("caller")));
		int id = recordSet.getInt("id");
		rs.executeSql("select memberid, membertype from Meeting_Member2 where  meetingid ="+ id + " order by membertype,id");
		String mname = "";
		while(rs.next()){
			int mbrtype = rs.getInt("membertype");
			if(mbrtype == 1){
				mname = ResourceComInfo.getLastname(Util.null2String(rs.getString("memberid")));
				members += ("".equals(mname))?"":(mname+" ");
			} else if(mbrtype == 2){
				mname = CustomerInfoComInfo.getCustomerInfoname(Util.null2String(rs.getString("memberid")));
				members += ("".equals(mname))?"":(mname+" ");
			}
		}
		
		
	
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((SystemEnv.getHtmlLabelName(82888,user.getLanguage())));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((SystemEnv.getHtmlLabelName(82889,user.getLanguage())));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("2")),user.getLanguage()) ));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((meetingname));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((meetingname));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("5")),user.getLanguage()) ));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((meetingRoom));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((meetingRoom));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("3")),user.getLanguage()) ));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((caller));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((SystemEnv.getHtmlLabelName(277,user.getLanguage()) ));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((sdt+" ~ "+ edt));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((sdt+" ~ "+ edt));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((SystemEnv.getHtmlLabelName(Util.getIntValue(MeetingFieldComInfo.getLabel("29")),user.getLanguage()) ));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((members));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((sTime ));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      
	} else {
	
		out.print(SystemEnv.getHtmlLabelName(82887,user.getLanguage()));
	
	}
}else if("getSubordinate".equals(method)){
	request.getRequestDispatcher("/workplan/calendar/data/WorkPlanViewOperation.jsp").forward(request,response);
}


 
      out.write(' ');
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("meeting/data/getData.jsp"), -3199407455251095406L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string3;
  private final static char []_jsp_string14;
  private final static char []_jsp_string5;
  private final static char []_jsp_string7;
  private final static char []_jsp_string6;
  private final static char []_jsp_string12;
  private final static char []_jsp_string4;
  private final static char []_jsp_string8;
  private final static char []_jsp_string13;
  private final static char []_jsp_string9;
  private final static char []_jsp_string10;
  private final static char []_jsp_string1;
  private final static char []_jsp_string11;
  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  static {
    _jsp_string3 = "<span id=\"showTime\"  ></span>".toCharArray();
    _jsp_string14 = "\" />\r\n	".toCharArray();
    _jsp_string5 = "</div>\r\n				<div style=\"overflow:hidden;width:163px;color:#000;margin-top:0px;margin-bottom:15px;padding-left: 15px;\" title=\"".toCharArray();
    _jsp_string7 = "</p></div>\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		<tr style=\"height:1px;\">\r\n			<td></td>\r\n			<td class=\"Lineblack\" >\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		<tr style=\"vertical-align: top;\">\r\n			<td></td>\r\n			<td>\r\n				<div class=\"spanhead\" style=\"color:#929292;margin-top:15px;margin-bottom:1px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-2_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;\">".toCharArray();
    _jsp_string6 = "\"><p style=\"word-break: break-all;\">".toCharArray();
    _jsp_string12 = "</div>\r\n				<div style=\"overflow:hidden;width:163px;color:#000;margin-top:0px;margin-bottom:15px;padding-left: 15px;\"><p style=\"word-break: break-all;\">".toCharArray();
    _jsp_string4 = "</p></div>\r\n			</td>\r\n			<td>&nbsp;&nbsp;&nbsp;</td>\r\n		</tr>\r\n		<tr style=\"height:1px;\">\r\n			<td></td>\r\n			<td class=\"Lineblack\" >\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		<tr style=\"vertical-align: top;\">\r\n			<td></td>\r\n			<td>\r\n				<div class=\"spanhead\" style=\"color:#929292;margin-top:15px;margin-bottom:1px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-1_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;\">".toCharArray();
    _jsp_string8 = "</p></div>\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		<tr style=\"height:1px;\">\r\n			<td></td>\r\n			<td class=\"Lineblack\" >\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		<tr style=\"vertical-align: top;\">\r\n			<td></td>\r\n			<td>\r\n				<div class=\"spanhead\" style=\"color:#929292;margin-top:15px;margin-bottom:10px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-4_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;\">".toCharArray();
    _jsp_string13 = "</p></div>\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		</table>\r\n	  <input id=\"sTime\" name=\"sTime\" type=\"hidden\" value=\"".toCharArray();
    _jsp_string9 = "</div>\r\n				<div style=\"overflow:hidden;width:163px;color:#000;margin-top:0px;margin-bottom:15px;padding-left: 15px;\" ><p style=\"word-break: break-all;\">".toCharArray();
    _jsp_string10 = "</p></div>\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		<tr style=\"height:1px;\">\r\n			<td></td>\r\n			<td class=\"Lineblack\" >\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		<tr style=\"vertical-align: top;\">\r\n			<td></td>\r\n			<td>\r\n				<div class=\"spanhead\" style=\"color:#929292;margin-top:10px;margin-bottom:10px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-3_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;\">".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string11 = "</p></div>\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		<tr style=\"height:1px;\">\r\n			<td></td>\r\n			<td class=\"Lineblack\" >\r\n			</td>\r\n			<td></td>\r\n		</tr>\r\n		<tr style=\"vertical-align: top;\">\r\n			<td></td>\r\n			<td>\r\n				<div class=\"spanhead\" style=\"color:#929292;margin-top:10px;margin-bottom:10px;padding-left: 18px;background-image: url(/images/ecology8/meeting/mt-2-5_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;\">".toCharArray();
    _jsp_string2 = "\r\n	  <table height=100% border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n		<COLGROUP>\r\n		<COL width=\"10px\">\r\n		<COL width=\"182px\">\r\n		<COL width=\"10px\">\r\n		<tr style=\"vertical-align: top;\">\r\n			<td>&nbsp;&nbsp;&nbsp;</td>\r\n			<td>\r\n				<div style=\"overflow:hidden;width:148px;color:#000;margin-top:15px;min-height:34px;margin-bottom:15px;padding-left: 30px;background-image: url(/images/ecology8/meeting/mt-3_wev8.png); background-position: 0px 50%; background-repeat: no-repeat;\"> \r\n				<p style=\"word-break: break-all;\">".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}
