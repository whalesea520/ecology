/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._page._maint._common;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import java.io.*;
import weaver.hrm.*;
import weaver.general.*;
import net.sf.json.JSONObject;
import weaver.page.PageManager;

public class _customresourcelistjson__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  private String getFileNode(String dir){
  	StringBuffer returnStr = new StringBuffer();
  	PageManager pm = new PageManager();
  	String dirAbs = pm.getRealPath("/page/resource/userfile/");
  	if(!"".equals(dir)) dirAbs+=dir;
  	if (dirAbs.charAt(dirAbs.length()-1) == '\\') {
  		dirAbs = dirAbs.substring(0, dirAbs.length()-1) + "/";
  	} else if (dirAbs.charAt(dirAbs.length()-1) != '/') {
  		dirAbs += "/";
  	}
  	dirAbs  = Util.StringReplace(dirAbs,"\\","/");
  	returnStr.append("[");
      if (new File(dirAbs).exists()) {
  		String[] files = new File(dirAbs).list(new FilenameFilter() {
  		    public boolean accept(File dirAbs, String name) {
  				return name.charAt(0) != '.';
  		    }
  		});
  		Arrays.sort(files, String.CASE_INSENSITIVE_ORDER);
  		if(files.length>0){
  			for (int i=0; i<files.length;i++) {
  				JSONObject json = new JSONObject ();
  				String file = files[i];
  				File _file =  new File(dirAbs, file);
  			    if (_file.isDirectory()) {
  			    	json.put("id",new Date().getTime());
  					json.put("isParent",true);
  					json.put("parentId",_file.getParentFile().getName());
  					
  					json.put("name",file);		
  					json.put("dirtype","cus");
  					json.put("dirrealpath",dir + file + "/");
  					if("flash".equals(file)||"image".equals(file)||"other".equals(file)||"video".equals(file)){
  						json.put("dirtype","sys");
  					}
  					
  					File[] hasFiles = new File(dirAbs + file).listFiles();
  					if(hasFiles.length>0){
  						for (int k=0; k<hasFiles.length;k++) {
  							if(hasFiles[k].isDirectory()){
  								json.put("isParent",true);
  								break;
  							}else{
  								json.put("isParent",false);
  							}
  						}
  					}else{
  						json.put("isParent",false);
  					}
  			    	returnStr.append(json.toString());
  			    	returnStr.append(",");
  			    }
  			}
  		}
      }
      return returnStr.toString().substring(0,returnStr.toString().length()-1)+"]";
  }

  
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

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
String dir = Util.null2String(request.getParameter("dir"));
out.print(getFileNode(dir));

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/CustomResourceListJSON.jsp"), 5205077222989058067L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n".toCharArray();
  }
}
