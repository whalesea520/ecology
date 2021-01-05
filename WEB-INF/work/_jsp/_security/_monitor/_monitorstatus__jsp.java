/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._security._monitor;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.hrm.*;
import java.util.Properties;
import weaver.filter.ServerDetector;
import weaver.filter.msg.CheckSecurityUpdateInfo;

public class _monitorstatus__jsp extends com.caucho.jsp.JavaPage
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
    response.setContentType("text/html; charset=GBK");
    request.setCharacterEncoding("GBK");
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
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
		User user = HrmUserVarify.getUser (request , response) ;
		if(user == null)  return ;
		if (user.getUID()!=1)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		Properties props=System.getProperties();
		csui.getRemoteServerVersion();
	
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((props.getProperty("os.name")+" "+props.getProperty("os.arch")+" "+props.getProperty("os.version") ));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((xssUtil.getCompanyname() ));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((xssUtil.getEcVersion() ));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((ServerDetector.getServerId()));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((props.getProperty("java.version")+" "+props.getProperty("sun.arch.data.model") ));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((csui.getVersion() ));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((csui.getRuleVersion() ));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((csui.getNewversion() ));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((csui.getNewversion().compareTo(csui.getVersion())>0?"<a href='http://www.weaver.com.cn/cs/securityDownload.asp' target='_blank'>\u4e0b\u8f7d</a>":""
      ));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((csui.getRuleNewVersion() ));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((csui.getRuleNewVersion().compareTo(csui.getRuleVersion())>0?"<a href='http://www.weaver.com.cn/cs/securityDownload.asp' target='_blank'>\u4e0b\u8f7d</a>":""
      ));
      out.write(_jsp_string13, 0, _jsp_string13.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("security/monitor/MonitorStatus.jsp"), -2002665876138059049L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string9;
  private final static char []_jsp_string7;
  private final static char []_jsp_string6;
  private final static char []_jsp_string12;
  private final static char []_jsp_string5;
  private final static char []_jsp_string10;
  private final static char []_jsp_string11;
  private final static char []_jsp_string1;
  private final static char []_jsp_string4;
  private final static char []_jsp_string8;
  private final static char []_jsp_string13;
  private final static char []_jsp_string0;
  private final static char []_jsp_string3;
  static {
    _jsp_string2 = "\r\n\r\n<HTML>\r\n	<HEAD>\r\n		<style type=\"text/css\">\r\n			*{\r\n				font-family: \u5fae\u8f6f\u96c5\u9ed1; \r\n				mso-hansi-font-family: \u5fae\u8f6f\u96c5\u9ed1\r\n			}\r\n			.fieldlabel{\r\n				font-size:12px;\r\n				color:#8e9297;\r\n			}\r\n			.fieldvalue{\r\n				font-size:12px;\r\n				color:#384049;\r\n			}\r\n			a{\r\n				color:#1c7ae3;\r\n				font-size:12px;\r\n				TEXT-DECORATION:none;\r\n			}\r\n		</style>\r\n	</head>\r\n	".toCharArray();
    _jsp_string9 = "</span>\r\n					</div>\r\n					<div style=\"padding-top:22px;\">\r\n						<span class=\"fieldlabel\">\u5ba2\u6237\u7aef\u5b89\u5168\u5305\u89c4\u5219\u5e93\u7248\u672c\uff1a</span>\r\n						<span class=\"fieldvalue\">".toCharArray();
    _jsp_string7 = "</span>\r\n					</div>\r\n					<div style=\"padding-top:22px;\">\r\n						<span class=\"fieldlabel\">JVM\u4fe1\u606f\uff1a</span>\r\n						<span class=\"fieldvalue\">".toCharArray();
    _jsp_string6 = "</span>\r\n					</div>\r\n					<div style=\"padding-top:22px;\">\r\n						<span class=\"fieldlabel\">web\u4e2d\u95f4\u4ef6\u7248\u672c\uff1a</span>\r\n						<span class=\"fieldvalue\">".toCharArray();
    _jsp_string12 = "</span>\r\n					</div>\r\n					<div style=\"padding-top:22px;\">\r\n						<span class=\"fieldlabel\">\u6cdb\u5fae\u5b98\u7f51\u5b89\u5168\u5305\u89c4\u5219\u5e93\u7248\u672c\uff1a</span>\r\n						<span class=\"fieldvalue\">".toCharArray();
    _jsp_string5 = "</span>\r\n					</div>\r\n					<div style=\"padding-top:22px;\">\r\n						<span class=\"fieldlabel\">\u7248\u672c\u53f7\uff1a</span>\r\n						<span class=\"fieldvalue\">".toCharArray();
    _jsp_string10 = "</span>\r\n					</div>\r\n					<div style=\"padding-top:22px;\">\r\n						<span class=\"fieldlabel\">\u6cdb\u5fae\u5b98\u7f51\u5b89\u5168\u5305\u8f6f\u4ef6\u7248\u672c\uff1a</span>\r\n						<span class=\"fieldvalue\">".toCharArray();
    _jsp_string11 = "&nbsp;&nbsp;&nbsp;&nbsp;".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string4 = "</span>\r\n					</div>\r\n					<div style=\"padding-top:22px;\">\r\n						<span class=\"fieldlabel\">ecology\u4fe1\u606f\uff1a</span>\r\n						<span class=\"fieldvalue\"></span>\r\n					</div>\r\n					<div style=\"padding-top:22px;\">\r\n						<span class=\"fieldlabel\">\u6388\u6743\uff1a</span>\r\n						<span class=\"fieldvalue\">".toCharArray();
    _jsp_string8 = "</span>\r\n					</div>\r\n					<div style=\"padding-top:22px;\">\r\n						<span class=\"fieldlabel\">\u5ba2\u6237\u7aef\u5b89\u5168\u5305\u8f6f\u4ef6\u7248\u672c\uff1a</span>\r\n						<span class=\"fieldvalue\">".toCharArray();
    _jsp_string13 = "</span>\r\n					</div>\r\n				</div>\r\n			</div>\r\n		</div>\r\n	</BODY>\r\n</HTML>".toCharArray();
    _jsp_string0 = "\r\n\r\n".toCharArray();
    _jsp_string3 = "\r\n	<BODY>\r\n		<div style=\"width:406px;height:506px;border:1px solid #d2d2d2;margin-top:80px;margin-right:auto;margin-left:auto;\">\r\n			<div style=\"width:100%;height:52px;line-height:52px;text-align:center;font-weight:bold;color:#384049;background-color:#f0f3f4;\">\r\n				\u73af\u5883\u4fe1\u606f\r\n			</div>\r\n			<div style=\"width:100%;height:100%;\">\r\n				<div style=\"margin-left:80px;padding-top:30px;\">\r\n					<div>\r\n						<span class=\"fieldlabel\">\u7cfb\u7edf\u7248\u672c\uff1a</span>\r\n						<span class=\"fieldvalue\">".toCharArray();
  }
}