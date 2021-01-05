/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._security._monitor;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.hrm.*;
import weaver.security.classLoader.ReflectMethodCall;

public class _monitorjoin__jsp extends com.caucho.jsp.JavaPage
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
      weaver.security.core.SecurityCore sc;
      sc = (weaver.security.core.SecurityCore) pageContext.getAttribute("sc");
      if (sc == null) {
        sc = new weaver.security.core.SecurityCore();
        pageContext.setAttribute("sc", sc);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
		User user = HrmUserVarify.getUser(request, response);
		if (user == null)
			return;
		int UID = xssUtil.getIntValue(""+xssUtil.getRule().get("userID"),1);
		if (user.getUID() != UID)
		{
			response.sendRedirect("/notice/noright.jsp");
			return;
		}
		ReflectMethodCall rmc = new ReflectMethodCall();	
		String isJoinMonitor = xssUtil.null2String(request.getParameter("isJoinMonitor"));
		String operatetype = xssUtil.null2String(request.getParameter("operatetype"));
		
		if (!operatetype.equals(""))
		{
			if (operatetype.equals("autoupdate")){
				xssUtil.setAutoUpdateRules(isJoinMonitor.equals("1")?true:false);
			}else{
				rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"joinSystemSecurity",new Class[]{Boolean.class},new Boolean(isJoinMonitor.equals("1")?true:false));
			}
		}
		Boolean isJoinSystemSecurity = (Boolean)rmc.call("weaver.security.core.SecurityCore",xssUtil.getSecurityCore(),"joinSystemSecurity",new Class[]{},null);
		if(isJoinSystemSecurity==null)isJoinSystemSecurity = new Boolean(true);
		//System.out.println("operatetype : "+operatetype+" isJoinMonitor : "+isJoinMonitor);
	
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((new Boolean(true).compareTo(isJoinSystemSecurity)==0?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      if(new Boolean(true).compareTo(isJoinSystemSecurity)==0){ 
      out.write(_jsp_string5, 0, _jsp_string5.length);
      }
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((new Boolean(true).compareTo(isJoinSystemSecurity)!=0?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      if(new Boolean(true).compareTo(isJoinSystemSecurity)!=0){ 
      out.write(_jsp_string5, 0, _jsp_string5.length);
      }
      out.write(_jsp_string8, 0, _jsp_string8.length);
      if(new Boolean(true).compareTo(isJoinSystemSecurity)==0){ 
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((xssUtil.isAutoUpdateRules()?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      if(xssUtil.isAutoUpdateRules()){ 
      out.write(_jsp_string5, 0, _jsp_string5.length);
      }
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((!xssUtil.isAutoUpdateRules()?"color:white;background-color:#2c91e6;":"border:1px solid #c0c0c0;"));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      if(!xssUtil.isAutoUpdateRules()){ 
      out.write(_jsp_string5, 0, _jsp_string5.length);
      }
      out.write(_jsp_string13, 0, _jsp_string13.length);
      }
      out.write(_jsp_string14, 0, _jsp_string14.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("security/monitor/MonitorJoin.jsp"), 6651389216641158511L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string9;
  private final static char []_jsp_string12;
  private final static char []_jsp_string0;
  private final static char []_jsp_string4;
  private final static char []_jsp_string5;
  private final static char []_jsp_string7;
  private final static char []_jsp_string2;
  private final static char []_jsp_string13;
  private final static char []_jsp_string3;
  private final static char []_jsp_string11;
  private final static char []_jsp_string10;
  private final static char []_jsp_string8;
  private final static char []_jsp_string1;
  private final static char []_jsp_string14;
  private final static char []_jsp_string6;
  static {
    _jsp_string9 = "\r\n				<div style=\"text-align:center;margin-top:30px;\">\r\n					<span onclick=\"enableAutoUpddate(1);\" style=\"height:36px;text-align:center;line-height:36px;".toCharArray();
    _jsp_string12 = "text-align:center;line-height:36px;display:inline-block;padding-left:10px;padding-right:10px;\">\r\n						".toCharArray();
    _jsp_string0 = "<!DOCTYPE HTML>\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string4 = "display:inline-block;padding-left:10px;padding-right:10px;cursor:pointer;\">\r\n					".toCharArray();
    _jsp_string5 = "<span style=\"padding-right:5px;\">\u221a</span>".toCharArray();
    _jsp_string7 = "text-align:center;line-height:36px;display:inline-block;padding-left:10px;padding-right:10px;\">\r\n					".toCharArray();
    _jsp_string2 = "\r\n\r\n\r\n\r\n<HTML>\r\n	<HEAD>\r\n		<style>\r\n			*{\r\n				font-family: \u5fae\u8f6f\u96c5\u9ed1; \r\n				mso-hansi-font-family: \u5fae\u8f6f\u96c5\u9ed1\r\n			}\r\n			a{\r\n				color:#1c7ae3;\r\n				font-size:12px;\r\n				TEXT-DECORATION:none;\r\n			}\r\n			.strongCss{\r\n				font-weight:bold;\r\n				color:#384049;\r\n			}\r\n		</style>\r\n	</head>\r\n	".toCharArray();
    _jsp_string13 = "\r\n						\u4e0d\u542f\u7528\u5b89\u5168\u8865\u4e01\u81ea\u52a8\u66f4\u65b0\r\n					</span>\r\n				</div>\r\n			".toCharArray();
    _jsp_string3 = "\r\n	<BODY>\r\n		<form id=\"frmRemain\" name=\"frmRemain\" method=post\r\n			action=\"MonitorJoin.jsp\">\r\n			<div style=\"margin-left:40px;margin-right:40px;border-bottom:1px solid #e0e0e0;padding-bottom:48px;\">\r\n				<div style=\"font-size:14px;font-weight:bold;margin-top:42px;padding-bottom:18px;border-bottom:1px solid #e0e0e0;color:#384009\">\u670d\u52a1\u6761\u6b3e</div>\r\n				<div style=\"font-size:12px;font-weight:bold;padding-top:28px;color:#384009\">\u3010\u7cfb\u7edf\u5b89\u5168\u4fdd\u969c\u8ba1\u5212\u8bf4\u660e\u3011</div>\r\n				<div style=\"font-size:12px;color:#62676d\">\r\n					<div style=\"padding-top:20px;\">\r\n						<div>\u6cdb\u5fae\u5b98\u65b9\u4f1a\u6301\u7eed\u5173\u6ce8\u4ea7\u54c1\u5b89\u5168\uff0c\u9488\u5bf9\u4ea7\u54c1\u5b89\u5168\u53ca\u65f6\u53d1\u5e03\u5b89\u5168\u4fee\u590d\u8865\u4e01\uff0c\u8865\u4e01\u4f1a\u5b9a\u671f\u53d1\u5e03\u5230\u6cdb\u5fae\u5b98\u65b9\u7f51\u7ad9\uff1a<a href='http://www.weaver.com.cn/cs/securityDownload.asp' target=\"_blank\">www.weaver.com.cn/cs/securityDownload.asp</a>\uff0c\u53ef\u4ee5\u624b\u52a8\u4e0b\u8f7d\u66f4\u65b0\uff0c<span style=\"font-size:12px;font-weight:bold;\">\u4e5f\u53ef\u4ee5\u901a\u8fc7\u5f00\u542f\u4ee5\u4e0b\u670d\u52a1\u8fdb\u884c\u81ea\u52a8\u66f4\u65b0\uff0c\u4ee5\u4fdd\u8bc1\u7cfb\u7edf\u59cb\u7ec8\u4fdd\u6301\u6700\u5b89\u5168\u7684\u72b6\u6001</span></div>\r\n					</div>\r\n					<div style=\"padding-top:16px;\">\r\n						<b>\u5982\u679c\u52a0\u5165\u7cfb\u7edf\u5b89\u5168\u4fdd\u969c\u8ba1\u5212\uff0c\r\n						<p>\r\n						<font style=\"color:red;font-weight:bold;\">\u52a0\u5165\u5b89\u5168\u4fdd\u969c\u8ba1\u5212\u540e\uff0c\u6cdb\u5fae\u4f1a\u81ea\u52a8\u68c0\u6d4b\u8d35\u65b9\u7cfb\u7edf\u7684\u5b89\u5168\u72b6\u51b5\uff0c\u5982\u679c\u53d1\u73b0\u7cfb\u7edf\u6709\u6f0f\u6d1e\uff0c\u4f1a\u53ca\u65f6\u62a5\u544a\u5e76\u4fee\u590d\u6f0f\u6d1e\uff0c\u4fdd\u969c\u7cfb\u7edf\u5904\u4e8e\u5b89\u5168\u7684\u72b6\u6001\u3002</font>\r\n						</p>\r\n						<p>\u6cdb\u5fae\u4f1a\u91c7\u96c6\u5fc5\u8981\u7684\u4fe1\u606f\uff0c\u4e3b\u8981\u7528\u4e8e\u6cdb\u5fae\u5b89\u5168\u90e8\u95e8\u5373\u65f6\u4e86\u89e3\u7cfb\u7edf\u5f53\u524d\u7684\u5b89\u5168\u72b6\u51b5\uff0c\u91c7\u96c6\u7684\u4fe1\u606f\u4ec5\u9650\u4e8e\uff1a<font style=\"font-size:16px;color:red;\">\u5ba2\u6237\u540d\u79f0\u3001\u7cfb\u7edf\u7248\u672c\u3001\u5b89\u5168\u8865\u4e01\u7248\u672c</font>\uff0c\u5e76\u4e14\u91c7\u96c6\u7684\u4fe1\u606f\u4f1a\u52a0\u5bc6\u540e\u4f20\u8f93\u5230\u6cdb\u5fae\u5b89\u5168\u670d\u52a1\u5668\u4e0a\uff0c\u4ee5\u4f9b\u5206\u6790.</b></p>\r\n					</div>\r\n					<div style=\"padding-top:16px;\">\r\n						\u81ea\u52a8\u66f4\u65b0\u670d\u52a1\u4f1a\u8bbf\u95ee\u5730\u5740\uff1a<a href=\"#\">https://update.e-cology.cn/</a> \u5982\u679c\u5f00\u542f\u670d\u52a1\uff0c\u8bf7\u4fdd\u6301\u5e94\u7528\u670d\u52a1\u5668\u53ef\u4ee5\u6b63\u5e38\u8bbf\u95ee\u8fd9\u4e2a\u5730\u5740\uff08\u5982\u679c\u770b\u5230\u663e\u793a404\u9875\u9762\u5c31\u8bf4\u660e\u6b63\u5e38\uff09.\r\n					</div>\r\n					<div style=\"font-size:12px;font-weight:bold;padding-top:28px;color:#384009\">\u3010\u5b89\u5168\u5e93\u5347\u7ea7\u6545\u969c\u62a5\u4fee\u3011</div>\r\n					<div style=\"padding-top:20px;\">\r\n						\u6cdb\u5fae\u7d27\u6025\u503c\u73ed\u7535\u8bdd\uff08\u975e\u5de5\u4f5c\u65f6\u95f4\uff09\uff1a139-1862-9764\r\n					</div>\r\n				</div>\r\n			</div>\r\n			<div style=\"text-align:center;margin-top:30px;\">\r\n				<input type=\"hidden\" name=\"isJoinMonitor\" id=\"isJoinMonitor\" value=\"1\"/>\r\n				<input name=\"operatetype\" id=\"operatetype\" type=\"hidden\" value=\"\">\r\n				<span onclick=\"joinMonitor(1);\" style=\"height:36px;text-align:center;line-height:36px;".toCharArray();
    _jsp_string11 = "\r\n						\u542f\u7528\u5b89\u5168\u8865\u4e01\u81ea\u52a8\u66f4\u65b0\r\n					</span>\r\n					<span onclick=\"enableAutoUpddate(0);\" style=\"cursor:pointer;margin-left:15px;height:36px;".toCharArray();
    _jsp_string10 = "display:inline-block;padding-left:10px;padding-right:10px;cursor:pointer;\">\r\n						".toCharArray();
    _jsp_string8 = "\r\n					\u4e0d\u52a0\u5165\u5b89\u5168\u4fdd\u969c\u8ba1\u5212\r\n				</span>\r\n			</div>\r\n			".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string14 = "\r\n		</form>\r\n	</BODY>\r\n	<script language=\"javascript\">\r\n	function enableAutoUpddate(value)\r\n	{\r\n		document.getElementById(\"isJoinMonitor\").value=value;\r\n		document.getElementById(\"operatetype\").value=\"autoupdate\";\r\n		document.getElementById(\"frmRemain\").submit();\r\n	}\r\n	function joinMonitor(value)\r\n	{\r\n		document.getElementById(\"isJoinMonitor\").value=value;\r\n		document.getElementById(\"operatetype\").value=\"join\";\r\n		frmRemain.submit();\r\n	}\r\n	</script>\r\n</HTML>".toCharArray();
    _jsp_string6 = "\r\n					\u52a0\u5165\u5b89\u5168\u4fdd\u969c\u8ba1\u5212\r\n				</span>\r\n				<span onclick=\"joinMonitor(0);\" style=\"cursor:pointer;margin-left:15px;height:36px;".toCharArray();
  }
}
