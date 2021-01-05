/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._search;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.formmode.service.CustomSearchButtService;
import weaver.general.Util;
import java.util.*;
import com.weaver.formmodel.util.StringHelper;

public class _customsearchbuttoperation__jsp extends com.caucho.jsp.JavaPage
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
    response.setContentType("text/html");
    response.setCharacterEncoding("UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
String id = Util.null2String(request.getParameter("id"));
String operation = Util.null2String(request.getParameter("operation"));
CustomSearchButtService customSearchButtService = new CustomSearchButtService();
Map<String,	Object> dataMap = new HashMap<String,Object>();
dataMap.put("id", id);
int objid = Util.getIntValue(request.getParameter("objid"),0);
dataMap.put("objid", objid);
dataMap.put("buttonname", Util.null2String(request.getParameter("buttonname")));
dataMap.put("hreftype", Util.getIntValue(request.getParameter("hreftype"),1));
dataMap.put("hreftargetOpenWay", Util.getIntValue(request.getParameter("hreftargetOpenWay"),1));
dataMap.put("hreftargetParid", Util.null2String(request.getParameter("hreftargetParid")));
dataMap.put("hreftargetParval", Util.null2String(request.getParameter("hreftargetParval")));
dataMap.put("hreftarget", Util.null2String(request.getParameter("hreftarget")));
dataMap.put("jsmethodname", Util.null2String(request.getParameter("jsmethodname")));
dataMap.put("jsParameter", Util.null2String(request.getParameter("jsParameter")));
dataMap.put("jsmethodbody", Util.null2String(request.getParameter("jsmethodbody")));
dataMap.put("interfacePath", Util.null2String(request.getParameter("interfacePath")));
dataMap.put("isshow", Util.getIntValue(request.getParameter("isshow"),0));
dataMap.put("describe", Util.null2String(request.getParameter("describe")));
dataMap.put("showorder", Util.getDoubleValue(request.getParameter("showorder"),0));
if("create".equals(operation)){
	id = customSearchButtService.saveOrUpdateCustomButton(dataMap);
	String url = "/formmode/search/CustomSearchButtonAdd.jsp?objid="+objid+"&id="+id;
	out.print("<script>window.location.href='"+url+"';</script>");
}else if("delete".equals(operation)){
	customSearchButtService.deleteCustomButton(id);
	response.sendRedirect("/formmode/search/CustomSearchButton.jsp?id="+objid);
}else if("checkMethodName".equals(operation)){
	String methodName = Util.null2String(request.getParameter("methodName"));
	String sql = "select * from mode_customSearchButton where objid="+objid+" and jsmethodname like '%"+methodName+"%'";
	if(!StringHelper.isEmpty(id)){
		sql+=" and id!="+id;
	}
	rs.executeSql(sql);
	if(rs.getCounts()>0){
		out.print("true");
	}
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/search/CustomSearchButtOperation.jsp"), -4642987591633934209L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
