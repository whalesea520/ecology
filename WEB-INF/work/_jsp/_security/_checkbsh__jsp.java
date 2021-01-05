/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._security;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.util.*;
import java.io.*;
import java.util.regex.*;
import java.util.concurrent.*;
import weaver.hrm.*;
import org.apache.commons.lang.StringUtils;
import java.text.DateFormat;

public class _checkbsh__jsp extends com.caucho.jsp.JavaPage
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
      
    response.setHeader("cache-control", "no-cache");
    response.setHeader("pragma", "no-cache");
    response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	
	if(user==null){
		response.sendRedirect("/login/Login.jsp");
		return;
	}
	if(user.getUID()!=1){
		out.println("\u8bf7\u4f7f\u7528sysadmin\u767b\u5f55\u7cfb\u7edf\u540e\u8bbf\u95ee\u8be5\u9875\u9762\u3002");
		return;
	}
	

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
    manager.addTaglibFunctions(_jsp_functionMap, "wea", "/WEB-INF/weaver.tld");
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("security/checkbsh.jsp"), 7902858300882962505L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string2 = "\r\n<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\r\n<html>\r\n<head>\r\n<title>BSH\u8865\u4e01\u5347\u7ea7\u7ed3\u679c</title>\r\n\r\n<LINK href=\"/css/Weaver_wev8.css\" type=text/css rel=STYLESHEET>\r\n</head>\r\n<body>\r\n<div style=\"margin:0 auto;width:800px;margin-top:50px;\">\r\n<h1><b>\r\n	<font style=\"color:red;\">\u770b\u5230\u672c\u9875\u9762\u8868\u793aBSH\u5b89\u5168\u8865\u4e01\u5305\u5df2\u7ecf\u5347\u7ea7\u6210\u529f\uff01</font>\r\n</b></h1>\r\n</div>\r\n</body>\r\n</html>\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}