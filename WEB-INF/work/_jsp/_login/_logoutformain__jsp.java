/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._login;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.hrm.User;
import weaver.hrm.HrmUserVarify;
import java.util.Map;
import weaver.hrm.settings.RemindSettings;

public class _logoutformain__jsp extends com.caucho.jsp.JavaPage
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
      weaver.login.LicenseCheckLogin LicenseCheckLogin;
      LicenseCheckLogin = (weaver.login.LicenseCheckLogin) pageContext.getAttribute("LicenseCheckLogin");
      if (LicenseCheckLogin == null) {
        LicenseCheckLogin = new weaver.login.LicenseCheckLogin();
        pageContext.setAttribute("LicenseCheckLogin", LicenseCheckLogin);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
   
	User user = HrmUserVarify.getUser(request, response);
	RemindSettings settings0 = (RemindSettings) application.getAttribute("hrmsettings");
	Map logmessages = (Map) application.getAttribute("logmessages");
	String a_logmessage = "";
	if (logmessages != null)
		a_logmessage = Util.null2String((String)logmessages.get(""+ user.getUID()));
	String s_logmessage = Util.null2String((String)session.getAttribute("logmessage"));
	if (s_logmessage == null)
		s_logmessage = "";
	String relogin0 = Util.null2String(settings0.getRelogin());
	String fromPDA = Util.null2String((String)session.getAttribute("loginPAD"));
	//hubo \u6e05\u9664\u5c0f\u7a97\u53e3\u767b\u5f55\u6807\u8bc6
	if (request.getSession(true).getAttribute("layoutStyle") != null)
		request.getSession(true).setAttribute("layoutStyle", null);
	
	//xiaofeng \u6709\u6548\u7684\u767b\u5165\u8005\u5728\u9000\u51fa\u65f6\u6e05\u9664\u767b\u9646\u6807\u8bb0,\u8e22\u51fa\u7684\u7528\u6237\u76f4\u63a5\u9000\u51fa
	if (!relogin0.equals("1") && !s_logmessage.equals(a_logmessage)) {
		if (fromPDA.equals("1")) {
			response.sendRedirect("/login/LoginPDA.jsp");
		} else {
			response.sendRedirect("/login/Login.jsp");
		}
		return;
	} else {
		logmessages = (Map) application.getAttribute("logmessages");
		if (logmessages != null)
			logmessages.remove("" + user.getUID());
	}
    
	String loginfile = Util.getCookie(request, "loginfileweaver");
	
	LicenseCheckLogin.updateOnlinFlag(""+ user.getUID());
	
	request.getSession(true).removeValue("moniter");
	request.getSession(true).removeValue("WeaverMailSet");
	request.getSession(true).invalidate();

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("login/LogoutForMain.jsp"), 2227527880372502853L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  static {
    _jsp_string1 = "\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}
