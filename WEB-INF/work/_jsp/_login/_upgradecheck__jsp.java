/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._login;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.*;
import java.io.*;

public class _upgradecheck__jsp extends com.caucho.jsp.JavaPage
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
      weaver.system.SysUpgradeCominfo suc;
      suc = (weaver.system.SysUpgradeCominfo) pageContext.getAttribute("suc");
      if (suc == null) {
        suc = new weaver.system.SysUpgradeCominfo();
        pageContext.setAttribute("suc", suc);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("login/upgradeCheck.jsp"), 8907485156035474177L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string2 = "\r\n<head>\r\n<title></title>\r\n<style>\r\n.btnclass {\r\n	margin-top:50px;\r\n	margin-left:50px;\r\n	widht:300px;\r\n	height:30px;\r\n}\r\n</style>\r\n<script type=\"text/javascript\">\r\nvar returnflage = 0;\r\nfunction continueExcute(obj) {\r\n	if(obj == 1) {\r\n		if(confirm('\u5ffd\u7565\u9057\u6f0f\u8865\u4e01\u5305\uff0c\u5347\u7ea7\u540e\u7cfb\u7edf\u53ef\u80fd\u5b58\u5728\u5f02\u5e38\u5bfc\u81f4\u65e0\u6cd5\u542f\u52a8\uff0c\u786e\u5b9a\u9057\u6f0f\u5305\u53ef\u5ffd\u7565\u5e76\u7ee7\u7eed\u5347\u7ea7\u3002')){\r\n			$.ajax({\r\n				url:\"/login/continueExcute.jsp\",\r\n				type:\"post\",\r\n				datatype:\"json\",\r\n				success:function(data){\r\n					if(data) {\r\n						window.location.href=\"/login/Upgrade.jsp\";\r\n					}\r\n					\r\n				}\r\n			});\r\n		} \r\n	}else if(obj == 2){\r\n		if(confirm('\u8bf7\u786e\u8ba4\u60a8\u5df2\u7ecf\u67e5\u770b\u9519\u8bef\u65e5\u5fd7\uff0c\u5df2\u6838\u5b9e\u8be5SQL\u8bed\u53e5\u53ef\u4ee5\u76f4\u63a5\u8df3\u8fc7\uff01')){\r\n			$.ajax({\r\n				url:\"/login/continueExcute.jsp\",\r\n				type:\"post\",\r\n				datatype:\"json\",\r\n				success:function(data){\r\n					if(data) {\r\n						window.location.href=\"/login/Upgrade.jsp\";\r\n					}\r\n				}\r\n			});\r\n		} \r\n	} else {\r\n		$.ajax({\r\n			url:\"/login/continueExcute.jsp\",\r\n			type:\"post\",\r\n			datatype:\"json\",\r\n			success:function(data){\r\n				if(data) {\r\n					window.location.href=\"/login/Login.jsp\";\r\n				}\r\n			}\r\n		});\r\n	}\r\n}\r\n\r\nfunction showSQLError() {\r\n	$(\"#alllog\").val(0);//\u53ea\u663e\u793asql\u62a5\u9519\u4fe1\u606f\r\n	document.form1.submit();\r\n}\r\nfunction stopExcute(obj){\r\n	alert('\u8bf7\u5173\u95edResin\uff01')\r\n}\r\nfunction exportFile() {\r\n       //var form = $(\"<form name='formdow'>\");   //\u5b9a\u4e49\u4e00\u4e2aform\u8868\u5355\r\n       //form.attr('style','display:none');   //\u5728form\u8868\u5355\u4e2d\u6dfb\u52a0\u67e5\u8be2\u53c2\u6570\r\n       //form.attr('target','');\r\n       //form.attr('method','post');\r\n       //form.attr('action',\"exportFile.jsp\"); \r\n       //$('body').append(form);  //\u5c06\u8868\u5355\u653e\u7f6e\u5728web\u4e2d\r\n      //form.append(input1);   //\u5c06\u67e5\u8be2\u53c2\u6570\u63a7\u4ef6\u63d0\u4ea4\u5230\u8868\u5355\u4e0a\r\n      $(\"#alllog\").val(1);\r\n       document.form1.submit();\r\n}\r\n\r\nfunction showLog(path) {\r\n	doOpen(\"/login/errorMessage.jsp?path=\"+path,\"\u5347\u7ea7\u9519\u8bef\u65e5\u5fd7\");\r\n}\r\n\r\nvar dWidth = 600;\r\nvar dHeight = 500;\r\nfunction doOpen(url,title){\r\n	if(typeof dialog  == 'undefined' || dialog==null){\r\n		dialog = new window.top.Dialog();\r\n	}\r\n	dialog.currentWindow = window;\r\n	dialog.Title = title;\r\n	dialog.Width =  dWidth || 500;\r\n	dialog.Height =  dWidth || 300;\r\n	dialog.Drag = true;\r\n	dialog.maxiumnable = true;\r\n	dialog.URL = url;\r\n	\r\n	dialog.show();\r\n}\r\nfunction skipall(sqlname) {\r\n	if(confirm('\u8bf7\u786e\u8ba4\u8fd9\u4e2a\u811a\u672c\u5df2\u5728\u6570\u636e\u5e93\u624b\u52a8\u6267\u884c\uff0c\u5426\u5219\u4e0d\u80fd\u76f4\u63a5\u8df3\u8fc7\uff01')){\r\n		$.ajax({\r\n			url:\"/login/continueExcute.jsp?skipall=1\",\r\n			type:\"post\",\r\n			datatype:\"json\",\r\n			success:function(data){\r\n				if(data) {\r\n					window.location.href=\"/login/Upgrade.jsp\";\r\n				}\r\n				\r\n			}\r\n		});\r\n	}\r\n}\r\n</script>\r\n</head>\r\n<body>\r\n<form name=\"form1\" action=\"exportFile.jsp\" type=\"post\">\r\n<input type=\"hidden\" id=\"alllog\" name=\"alllog\" value=\"1\"></input>\r\n</form>\r\n</body>\r\n</html>".toCharArray();
    _jsp_string0 = "\r\n<html>\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
