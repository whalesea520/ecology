/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._resource;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.file.*;
import java.util.*;
import weaver.join.hrm.in.IHrmImportAdapt;
import weaver.join.hrm.in.HrmResourceVo;
import weaver.join.hrm.in.IHrmImportProcess;
import weaver.join.hrm.in.processImpl.HrmImportProcess;
import weaver.matrix.MatrixUtil;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class _hrmimportprocess__jsp extends com.caucho.jsp.JavaPage
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
      
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      
	if (!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit",
			user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}


      out.write(_jsp_string1, 0, _jsp_string1.length);
      
 /*\u7efc\u5408\u8003\u8651\u591a\u6570\u636e\u6e90\u540e\uff0c\u5b9e\u73b0\u901a\u8fc7\u914d\u7f6e\u6587\u4ef6\u914d\u7f6e\u9002\u914d\u5668\u548c\u89e3\u6790\u7c7b*/

  IHrmImportAdapt importAdapt=(IHrmImportAdapt)Class.forName("weaver.join.hrm.in.adaptImpl.HrmImportAdaptExcel").newInstance();
  
  FileUploadToPath fu = new FileUploadToPath(request) ; 
  
  //\u91cd\u590d\u6027\u5b57\u6bb5\uff0c\u6570\u636e\u5e93\u4e2d\u6709\u76f8\u540c\u7684\u5219\u4f1aupdate
  String keyField=fu.getParameter("keyField");
  
  //\u5c06\u91cd\u590d\u6027\u9a8c\u8bc1\u5b57\u6bb5\u653e\u5165\u7f13\u5b58\uff0c\u5728HrmImportLog.jsp\u4e2d\u83b7\u53d6\uff0c\u7528\u4e8e\u5224\u65ad\u5173\u952e\u5b57\u6bb5\u5217
  session.setAttribute("keyField",keyField);
  
  //\u5bfc\u5165\u7c7b\u578b  \u6dfb\u52a0|\u66f4\u65b0
  String importType=fu.getParameter("importType");
  
  List errorInfo=importAdapt.creatImportMap(fu);  
  
  
  //\u5982\u679c\u8bfb\u53d6\u6570\u636e\u548c\u9a8c\u8bc1\u6a21\u677f\u6ca1\u6709\u53d1\u751f\u9519\u8bef
  if(errorInfo.isEmpty()){
	  Map hrMap=importAdapt.getHrmImportMap();
	
	  IHrmImportProcess importProcess=(IHrmImportProcess)Class.forName("weaver.join.hrm.in.processImpl.HrmImportProcess").newInstance();
	  
	  importProcess.processMap(keyField,hrMap,importType,session); 
	  
	  session.setAttribute("importStatus","over");
	//\u540c\u6b65\u90e8\u95e8\u6570\u636e\u5230\u77e9\u9635
	  MatrixUtil.sysDepartmentData();
	  //\u540c\u6b65\u5206\u90e8\u6570\u636e\u5230\u77e9\u9635
      MatrixUtil.sysSubcompayData();
  }else{
  	session.setAttribute("importStatus","error");
  	session.setAttribute("errorInfo",errorInfo);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/resource/HrmImportProcess.jsp"), -3198750992896577133L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  static {
    _jsp_string2 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}