/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._docs._category;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.hrm.*;
import weaver.common.util.xtree.TreeNode;
import weaver.docs.category.DocTreeDocFieldConstant;

public class _doctreedocfieldleftxml__jsp extends com.caucho.jsp.JavaPage
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
      weaver.docs.category.DocTreeDocFieldComInfo DocTreeDocFieldComInfo;
      DocTreeDocFieldComInfo = (weaver.docs.category.DocTreeDocFieldComInfo) pageContext.getAttribute("DocTreeDocFieldComInfo");
      if (DocTreeDocFieldComInfo == null) {
        DocTreeDocFieldComInfo = new weaver.docs.category.DocTreeDocFieldComInfo();
        pageContext.setAttribute("DocTreeDocFieldComInfo", DocTreeDocFieldComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.docs.category.DocTreeDocFieldManager DocTreeDocFieldManager;
      DocTreeDocFieldManager = (weaver.docs.category.DocTreeDocFieldManager) pageContext.getAttribute("DocTreeDocFieldManager");
      if (DocTreeDocFieldManager == null) {
        DocTreeDocFieldManager = new weaver.docs.category.DocTreeDocFieldManager();
        pageContext.setAttribute("DocTreeDocFieldManager", DocTreeDocFieldManager);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

      out.write(_jsp_string3, 0, _jsp_string3.length);
      

TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

TreeNode root=new TreeNode();
String titleName=DocTreeDocFieldComInfo.getTreeDocFieldName(DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
root.setTitle(titleName);
root.setNodeId("field_"+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID);
root.setTarget("_self"); 
root.setIcon("/images/treeimages/global_wev8.gif");
root.setHref("javascript:setTreeDocField('field_"+DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID+"')");
envelope.addTreeNode(root);

int maxLevel=DocTreeDocFieldConstant.TREE_DOC_FIELD_MAX_LEVEL+1;
String rootId=DocTreeDocFieldConstant.TREE_DOC_FIELD_ROOT_ID;
DocTreeDocFieldManager.getTreeDocFieldTreeList(root,rootId,0,maxLevel,"treeDocFieldStructure","");

//envelope.marshal(out);
weaver.common.util.string.StringUtil.parseXml(out, envelope);

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("docs/category/DocTreeDocFieldLeftXML.jsp"), -3299058541711014435L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string3;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string3 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}
