/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._lgc._search;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.hrm.*;
import weaver.general.*;
import weaver.systeminfo.*;
import weaver.systeminfo.menuconfig.*;
import java.net.URLDecoder;

public class _lgcproductmenuxml__jsp extends com.caucho.jsp.JavaPage
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
    response.setContentType("text/xml; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

int parentid = Util.getIntValue(request.getParameter("parentid"),0);
String searchName = URLDecoder.decode(Util.null2String(request.getParameter("searchName")),"UTF-8");

      out.write(_jsp_string2, 0, _jsp_string2.length);
      
	StringBuffer treeStr = new StringBuffer();
	String sql = "";
	if(!searchName.equals("")){
		sql = " select id,assetcount, assortmentname ,(select count(*) from LgcAssetAssortment where supassortmentid = t1.id) child_count"+
		" from LgcAssetAssortment t1 where assortmentname like '%"+searchName+"%' order by id asc";
	}else{
		sql = " select id,assetcount, assortmentname ,(select count(*) from LgcAssetAssortment where supassortmentid = t1.id) child_count"+
		" from LgcAssetAssortment t1 where supassortmentid="+parentid+" order by id asc";
	}
	
	RecordSet.executeSql(sql);
 	while(RecordSet.next()){
 		treeStr = new StringBuffer();
 		String mainname = RecordSet.getString("assortmentname");
 		int _count = RecordSet.getInt("assetcount");
 		String mainid = RecordSet.getString("id");
 		
    //\u7b2c\u4e00\u5c42
    treeStr.append("<tree ");
    //text
    treeStr.append("text=\"");
    treeStr.append(
    Util.replace(
    Util.replace(
		Util.replace(
		Util.replace(
		Util.replace(
		Util.toScreen(mainname,user.getLanguage())
    		,"<","&lt;",0)
    		,">","&gt;",0)
    		,"&","&amp;",0)
    		,"'","&apos;",0)
    		,"\"","&quot;",0)
    		
    );
    treeStr.append("\" ");
    //action
    treeStr.append("action=\"");
    treeStr.append("javascript:onClickCustomField("+mainid+");");
    treeStr.append("\" ");
    //icon
    //treeStr.append("icon=\"/images/treeimages/book1_close_wev8.gif\" ");
    //openIcon
    //treeStr.append("openIcon=\"/images/treeimages/book1_open_wev8.gif\" ");
    //target
    treeStr.append("target=\"_self\" ");
  	//_id
    treeStr.append("_id=\""+mainid+"\" ");
    //src
    if(RecordSet.getInt("child_count") > 0){
    	treeStr.append("src=\"LgcProductMenuXML.jsp?parentid="+mainid+"\" ");
    }
    //num
    treeStr.append("num=\"" + _count + "\" ");
    treeStr.append(" />");
    
    out.println(treeStr.toString());
 	}

      out.write(_jsp_string3, 0, _jsp_string3.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("lgc/search/LgcProductMenuXML.jsp"), -5354027690680481560L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string3;
  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  static {
    _jsp_string3 = "\r\n</tree>".toCharArray();
    _jsp_string2 = "\r\n<tree>\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string0 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n\r\n\r\n\r\n".toCharArray();
  }
}
