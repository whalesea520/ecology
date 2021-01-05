/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._join;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import net.sf.json.JSONObject;
import weaver.security.classLoader.ReflectMethodCall;
import weaver.filter.SecurityCheckList;

public class _securitycheck__jsp extends com.caucho.jsp.JavaPage
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
      weaver.filter.XssUtil xssUtil;
      xssUtil = (weaver.filter.XssUtil) pageContext.getAttribute("xssUtil");
      if (xssUtil == null) {
        xssUtil = new weaver.filter.XssUtil();
        pageContext.setAttribute("xssUtil", xssUtil);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.filter.msg.CheckSecurityUpdateInfo csui;
      csui = (weaver.filter.msg.CheckSecurityUpdateInfo) pageContext.getAttribute("csui");
      if (csui == null) {
        csui = new weaver.filter.msg.CheckSecurityUpdateInfo();
        pageContext.setAttribute("csui", csui);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
	String clientAddr = request.getRemoteAddr();
	if(!"0:0:0:0:0:0:0:1".equals(clientAddr) && !"127.0.0.1".equals(clientAddr) && !("localhost".equals(clientAddr) || "localhost".equals(clientAddr))){
		return;
	}
	ReflectMethodCall rmc = new ReflectMethodCall();
	Boolean isJoinSystemSecurity = (Boolean)rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"joinSystemSecurity",new Class[]{},null);
	if(isJoinSystemSecurity==null)isJoinSystemSecurity = new Boolean(true);
	JSONObject json = new JSONObject();
	//if(new Boolean(true).compareTo(isJoinSystemSecurity)==0){
		json.put("firewallStatus",new Boolean(xssUtil.enableFirewall()));
		json.put("autoUpdateStatus",new Boolean(xssUtil.isAutoUpdateRules()));
		json.put("softwareVersion",csui.getVersion());
		json.put("ruleVersion",csui.getRuleVersion());
		json.put("loginStatus",new Boolean(xssUtil.enableFirewall() && xssUtil.isLoginCheck()));
		json.put("pageStatus",new Boolean(xssUtil.enableFirewall() && xssUtil.getMustXss()));
		json.put("dataStatus",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsSkipRule()));
		json.put("enableServiceCheck",new Boolean(xssUtil.enableFirewall() && xssUtil.getEnableWebserviceCheck()));
		json.put("isUseESAPISQL",new Boolean(xssUtil.enableFirewall() && xssUtil.isUseESAPISQL()));
		json.put("isUseESAPIXSS",new Boolean(xssUtil.enableFirewall() && xssUtil.isUseESAPIXSS()));
		json.put("isResetCookie",new Boolean(xssUtil.enableFirewall() && xssUtil.isResetCookie()));
		json.put("httpOnly",new Boolean(xssUtil.enableFirewall() && xssUtil.getHttpOnly()));
		json.put("hostStatus",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsSkipHost()));
		json.put("isRefAll",new Boolean(xssUtil.enableFirewall() && !xssUtil.getIsRefAll()));
		json.put("httpSep",new Boolean(xssUtil.enableFirewall() && xssUtil.getHttpSep()));
		json.put("isCheckSessionTimeout",new Boolean(xssUtil.enableFirewall() && xssUtil.isCheckSessionTimeout()));
		json.put("isEnableForbiddenIp",new Boolean(xssUtil.enableFirewall() && xssUtil.isEnableForbiddenIp()>1));
		json.put("autoRemind",new Boolean(xssUtil.enableFirewall() && xssUtil.getAutoRemind()));
		SecurityCheckList scl = new SecurityCheckList();
		json.put("isConfigFirewall",new Boolean(scl.isConfigFirewall()));
		json.put("isEnableAccessLog",new Boolean(scl.isEnableAccessLog()));
		json.put("checkSocketTimeout",new Boolean(scl.checkSocketTimeout()));
		json.put("isResinAdmin",new Boolean(!scl.isResinAdmin()));
		json.put("is404PageConfig",new Boolean(scl.is404PageConfig()));
		json.put("is500PageConfig",new Boolean(scl.is500PageConfig()));
		json.put("isDisabledHttpMethod",new Boolean(scl.isDisabledHttpMethod()));
		json.put("joinSystemSecurity",isJoinSystemSecurity);
		
	//}else{
		json.put("result", new Boolean(true));
	//}
	out.println(json.toString());

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("join/securityCheck.jsp"), 7912163614864405555L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  static {
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n".toCharArray();
  }
}
