/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._mobile._plugin._1;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.Map;
import weaver.hrm.User;
import java.util.HashMap;
import weaver.general.Util;
import weaver.general.BaseBean;
import weaver.hrm.HrmUserVarify;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.attendance.domain.*;
import weaver.hrm.attendance.manager.*;
import weaver.hrm.schedule.HrmAnnualManagement;
import weaver.hrm.schedule.HrmPaidSickManagement;
import weaver.hrm.schedule.manager.HrmScheduleManager;
import net.sf.json.JSONObject;
import weaver.common.StringUtil;
import weaver.mobile.webservices.workflow.WorkflowService;
import weaver.mobile.webservices.workflow.WorkflowServiceImpl;

public class _workflowbillaction__jsp extends com.caucho.jsp.JavaPage
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
      weaver.hrm.attendance.manager.HrmAttProcSetManager attProcSetManager;
      attProcSetManager = (weaver.hrm.attendance.manager.HrmAttProcSetManager) pageContext.getAttribute("attProcSetManager");
      if (attProcSetManager == null) {
        attProcSetManager = new weaver.hrm.attendance.manager.HrmAttProcSetManager();
        pageContext.setAttribute("attProcSetManager", attProcSetManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.common.StringUtil strUtil;
      strUtil = (weaver.common.StringUtil) pageContext.getAttribute("strUtil");
      if (strUtil == null) {
        strUtil = new weaver.common.StringUtil();
        pageContext.setAttribute("strUtil", strUtil);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
BaseBean logBean = new BaseBean();
//\u83b7\u53d6\u5f53\u524d
try{
	String action = StringUtil.vString(request.getParameter("action"));
	String _cmd = StringUtil.vString(request.getParameter("cmd"));
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	if("getLeaveDays".equals(action)){
		String fromDate = StringUtil.vString(request.getParameter("fromDate"));
		String fromTime = StringUtil.vString(request.getParameter("fromTime"));
		String toDate = StringUtil.vString(request.getParameter("toDate"));
		String toTime = StringUtil.vString(request.getParameter("toTime"));
		String resourceId = StringUtil.vString(request.getParameter("resourceId"));
		String newLeaveType = StringUtil.vString(request.getParameter("newLeaveType"));
		boolean worktime = Boolean.parseBoolean(StringUtil.vString(request.getParameter("worktime"), "true"));
		WorkflowService wfService = new WorkflowServiceImpl();
		String result = wfService.getLeaveDays(fromDate, fromTime, toDate, toTime, resourceId, worktime,newLeaveType);
		
		Map daymap = new HashMap();
		daymap.put("resourceId", resourceId);
		daymap.put("days", result);
		
		JSONObject jo = JSONObject.fromObject(daymap);
		result = jo.toString();
		out.print(result);
	} else if(_cmd.equals("leaveInfo")) {
		String result = "";
		String allannualValue = "";
		String allpsldaysValue = "";
		String paidLeaveDaysValue = "";
		float realAllannualValue = 0;
		float realAllpsldaysValue = 0;
		float realPaidLeaveDaysValue = 0;
		String currentDate = StringUtil.vString(request.getParameter("currentDate"));
		String resourceId = StringUtil.vString(request.getParameter("resourceId"));
		String bohai = StringUtil.vString(request.getParameter("bohai"));
		int workflowid = StringUtil.parseToInt(request.getParameter("workflowid"));
		int nodetype = StringUtil.parseToInt(request.getParameter("nodetype"));
		HrmAttVacationManager attVacationManager = new HrmAttVacationManager();
		if("getAnnualInfo".equals(action)){
			String userannualinfo = HrmAnnualManagement.getUserAannualInfo(resourceId,currentDate);
			String thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
			String lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
			String allannual = Util.TokenizerString2(userannualinfo,"#")[2];
			allannualValue = allannual;
			float[] freezeDays = attVacationManager.getFreezeDays(resourceId,currentDate);
			if(freezeDays[0] > 0) allannual += " - "+freezeDays[0];	
			realAllannualValue = strUtil.parseToFloat(allannualValue, 0);
			if(bohai.equals("true")){
					realAllannualValue = (float)strUtil.round(realAllannualValue - freezeDays[0]);
			}else{
				if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
					realAllannualValue = (float)strUtil.round(realAllannualValue - freezeDays[0]);
				}
			}
			result = SystemEnv.getHtmlLabelName(21614,user.getLanguage())+" : "+lastyearannual+"\r\n"+SystemEnv.getHtmlLabelName(21615,user.getLanguage())+" : "+thisyearannual+"\r\n"+SystemEnv.getHtmlLabelName(21616,user.getLanguage())+" : "+allannual;	
		} else if("getPSInfo".equals(action)){
			String leavetype = Util.null2String(request.getParameter("leavetype"));
			String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(resourceId, currentDate,leavetype);
			String thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
			String lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
			String allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
			allpsldaysValue = allpsldays;
	 		float freezeDays = attVacationManager.getPaidFreezeDays(resourceId,leavetype);
		 	if(freezeDays > 0) allpsldays += " - "+freezeDays;
		 	realAllpsldaysValue = strUtil.parseToFloat(allpsldaysValue, 0);
			if(bohai.equals("true")){
					realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezeDays);
			}else{
				if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
					realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezeDays);
				}
			}	
			result = SystemEnv.getHtmlLabelName(131649,user.getLanguage())+" : "+lastyearpsldays+"\r\n"+SystemEnv.getHtmlLabelName(131650,user.getLanguage())+" : "+thisyearpsldays+"\r\n"+SystemEnv.getHtmlLabelName(131651,user.getLanguage())+" : "+allpsldays;
		} else if("getTXInfo".equals(action)){
			HrmPaidLeaveTimeManager paidLeaveTimeManager = new HrmPaidLeaveTimeManager();
			String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(resourceId, currentDate));
			paidLeaveDaysValue = paidLeaveDays;
			float[] freezeDays = attVacationManager.getFreezeDays(resourceId);
			realPaidLeaveDaysValue = strUtil.parseToFloat(paidLeaveDaysValue, 0);
			if(freezeDays[2] > 0) paidLeaveDays += " - "+freezeDays[2];	
			if(bohai.equals("true")){
					realPaidLeaveDaysValue = (float)strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
			}else{
				if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
					realPaidLeaveDaysValue = (float)strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
				}
			}
			result = SystemEnv.getHtmlLabelName(82854,user.getLanguage())+" : "+paidLeaveDays;	
		}
		Map daymap = new HashMap();
		daymap.put("resourceId", resourceId);
		daymap.put("info", result);
		daymap.put("allannualValue", allannualValue);
		daymap.put("realAllannualValue", realAllannualValue);
		daymap.put("allpsldaysValue", allpsldaysValue);
		daymap.put("realAllpsldaysValue", realAllpsldaysValue);
		daymap.put("paidLeaveDaysValue", paidLeaveDaysValue);
		daymap.put("realPaidLeaveDaysValue", realPaidLeaveDaysValue);
		
		JSONObject jo = JSONObject.fromObject(daymap);
		result = jo.toString();
		out.print(result);
	}
}catch(Exception e) {
	logBean.writeLog("", e);
}

      out.write(_jsp_string1, 0, _jsp_string1.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("mobile/plugin/1/workflowBillAction.jsp"), -7141625070314547581L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}