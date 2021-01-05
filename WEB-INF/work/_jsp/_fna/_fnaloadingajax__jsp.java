/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._fna;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.file.ExcelFile;
import weaver.general.Util;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;
import org.json.JSONObject;
import weaver.fna.interfaces.thread.FnaThreadResult;

public class _fnaloadingajax__jsp extends com.caucho.jsp.JavaPage
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
      
boolean isDone = true;
String infoStr = "";
String resultJson = "";
User user = HrmUserVarify.getUser(request, response);
if(user == null){
	isDone = true;
}else{
	//\u552f\u4e00\u6807\u8bc6
	String guid = Util.null2String(request.getParameter("guid")).trim();
	FnaThreadResult fnaThreadResult = new FnaThreadResult();
	//\u662f\u5426\u64cd\u4f5c\u5b8c\u6210\u6807\u8bc6
	isDone = "true".equalsIgnoreCase((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_isDone"));
	//\u8fdb\u5ea6\u4fe1\u606f\u5b57\u7b26\u4e32
	infoStr = Util.null2String((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_infoStr")).trim();
	//\u64cd\u4f5c\u5b8c\u6210\u540e\u8fd4\u56de\u6570\u636ejson\u5b57\u7b26\u4e32
	resultJson = Util.null2String((String)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_resultJson")).trim();
	if(isDone){
		//\u9488\u5bf9\u5bfc\u5165excel\u5bf9\u8c61\u7279\u6b8a\u5904\u7406\uff0c\u5982\u679c\u5b58\u5728_excelFile\u5bf9\u8c61\uff0c\u5219\u83b7\u53d6\u5bf9\u8c61\u540e\u653e\u5165seesion\u4e2d\u3002
		ExcelFile excelFile = (ExcelFile)fnaThreadResult.getInfoObjectByInfoKey(guid, "FnaLoadingAjax_"+guid+"_excelFile");
		if(excelFile!=null){
			session.setAttribute("FnaLoadingAjax_"+guid+"_excelFile", excelFile);
		}
		
		//\u5982\u679c\u64cd\u4f5c\u5b8c\u6210\uff0c\u5219\u5728\u6240\u6709\u4e8b\u9879\u5b8c\u6210\u540e\uff0c\u6309guid\u79fb\u9664\u7ebf\u7a0b\u4fe1\u606f
		fnaThreadResult.removeInfoByGuid(guid);
	}
}
//\u4fdd\u8bc1\uff1a\u64cd\u4f5c\u5b8c\u6210\u540e\u8fd4\u56de\u6570\u636ejson\u5b57\u7b26\u4e32\uff0c\u4e0d\u4e3a\u7a7a\uff1b
//\u5b9e\u9645\u8fd4\u56dejson\u5bf9\u8c61\u53ef\u80fd\u5404\u4e0d\u76f8\u540c\uff0c\u4f46\u662f\uff0c\u5fc5\u7136\u90fd\u5305\u542b\u4ee5\u4e0b\u4e24\u4e2a\u53c2\u6570\uff0c\u6240\u4ee5\uff0c\u9ed8\u8ba4\u521d\u59cb\u5316\u8fd9\u4e24\u4e2a\u53c2\u6570\uff0c\u907f\u514d\u524d\u7aef\u89e3\u6790\u51fa\u9519\uff1b
if("".equals(resultJson)){
	resultJson = "{\"flag\":false,\"msg\":\"\"}";
}

      out.print(("{\"flag\":"+isDone+",\"infoStr\":"+JSONObject.quote(infoStr)+",\"resultJson\":"+resultJson+"}" ));
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("fna/FnaLoadingAjax.jsp"), 7817060977828546179L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}