/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._mobile._plugin;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import net.sf.json.*;
import java.util.*;
import java.text.*;
import weaver.general.*;
import weaver.file.*;
import weaver.hrm.*;
import weaver.hrm.attendance.manager.*;
import weaver.hrm.attendance.domain.*;
import weaver.hrm.attendance.domain.HrmScheduleSign.*;
import weaver.hrm.report.schedulediff.*;

public class _checkin__jsp extends com.caucho.jsp.JavaPage
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
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.mobile.plugin.ecology.service.PluginServiceImpl ps;
      ps = (weaver.mobile.plugin.ecology.service.PluginServiceImpl) pageContext.getAttribute("ps");
      if (ps == null) {
        ps = new weaver.mobile.plugin.ecology.service.PluginServiceImpl();
        pageContext.setAttribute("ps", ps);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
response.setContentType("application/json;charset=UTF-8");

Map result = new HashMap();
User user = HrmUserVarify.getUser(request, response);
if(user==null) {
	//\u672a\u767b\u5f55\u6216\u767b\u5f55\u8d85\u65f6
	result.put("error", "005");
	JSONObject jo = JSONObject.fromObject(result);
	out.println(jo);
	return;
}
FileUpload fu = new FileUpload(request);
String type = Util.null2String(fu.getParameter("type"));//"checkin":\u7b7e\u5230,"checkout":\u7b7e\u9000
String ipaddr = Util.null2String(fu.getParameter("ipaddr"));//ip\u5730\u5740,eg:192.168.1.5
String latlng = Util.null2String(fu.getParameter("latlng"));//\u7ecf\u7eac\u5ea6,eg:31.253313,121.241581
String addr = Util.null2String(fu.getParameter("addr"));//\u7ecf\u7eac\u5ea6\u5bf9\u5e94\u5730\u5740
boolean inCom = "1".equals(fu.getParameter("inCompany"));//\u662f\u5426\u5728\u516c\u53f8
//int signType = bean.getSignType();
//List<String> signTimes = bean.getSignTimes();
if(type.equals("getStatus")){
	HrmScheduleSignManager signManager = new HrmScheduleSignManager();
	HrmScheduleSign bean = signManager.getSignData(user.getUID());//\u4f20\u9012\u7528\u6237ID
	List<ScheduleSignButton> signButtons =  bean.getSignButtons(); 
	List<ScheduleSignButton> currentButtons = bean.getCurrentSignButtons();	
	//\u5982\u679c\u662f\u6392\u73ed\u4eba\u5458\u3001\u5de5\u4f5c\u65e5\u3001\u8fd8\u6709\u5141\u8bb8\u975e\u5de5\u4f5c\u65e5\u7b7e\u5230\uff0c\u63d0\u4f9b\u8003\u52e4\u6309\u94ae
	if(bean.isSchedulePerson() || bean.isWorkDay()||!bean.getSignSet().isOnlyWorkday()){
		
		Map list = new HashMap();
		for(int i=0;i<currentButtons.size();i++){
			ScheduleSignButton ssb = currentButtons.get(i);
			list.put(ssb.getTime(),ssb.getTime());
		}
		for(int i=0;i<signButtons.size();i++){
		    ScheduleSignButton ssb = signButtons.get(i);
		    boolean isSign = ssb.isSign();
		    if(list.get(ssb.getTime())!=null){ //\u5f53\u524d\u7b7e\u5230\u7b7e\u9000\u7ec4
		    		if(ssb.getType().endsWith("On")){//\u7b7e\u5230
						if(!isSign){ //\u672a\u7b7e\u5230
							ssb.setIsEnable("true");
							break;
						}
					}
					if(ssb.getType().endsWith("Off")){//\u7b7e\u9000
						ScheduleSignButton ssbam = signButtons.get(i-1);
						boolean isOnSign = ssbam.isSign();
						if(isOnSign){//\u5df2\u7b7e\u5230\u5373\u663e\u793a\u7b7e\u9000\u6309\u94ae\uff0c\u652f\u6301\u591a\u6b21\u7b7e\u9000
							ssb.setIsEnable("true");
							break;
						}
					}
			}
		}
	}
		
	result.put("signbtns", signButtons);
}else{
    result = ps.checkIn(user, type, ipaddr, latlng, addr, inCom);
}

if(result!=null) {
	JSONObject jo = JSONObject.fromObject(result);

	out.println(jo);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("mobile/plugin/CheckIn.jsp"), -4811436956393196882L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  static {
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}