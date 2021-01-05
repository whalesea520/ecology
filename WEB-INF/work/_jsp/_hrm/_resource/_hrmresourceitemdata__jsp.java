/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._resource;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import net.sf.json.*;
import weaver.hrm.*;
import weaver.workflow.workflow.TestWorkflowCheck;
import weaver.workflow.search.WorkflowRequestUtil;

public class _hrmresourceitemdata__jsp extends com.caucho.jsp.JavaPage
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
      weaver.docs.search.DocSearchComInfo DocSearchComInfo;
      DocSearchComInfo = (weaver.docs.search.DocSearchComInfo) pageContext.getAttribute("DocSearchComInfo");
      if (DocSearchComInfo == null) {
        DocSearchComInfo = new weaver.docs.search.DocSearchComInfo();
        pageContext.setAttribute("DocSearchComInfo", DocSearchComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.proj.search.SearchComInfo SearchComInfo;
      SearchComInfo = (weaver.proj.search.SearchComInfo) pageContext.getAttribute("SearchComInfo");
      if (SearchComInfo == null) {
        SearchComInfo = new weaver.proj.search.SearchComInfo();
        pageContext.setAttribute("SearchComInfo", SearchComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.cpt.search.CptSearchComInfo CptSearchComInfo;
      CptSearchComInfo = (weaver.cpt.search.CptSearchComInfo) pageContext.getAttribute("CptSearchComInfo");
      if (CptSearchComInfo == null) {
        CptSearchComInfo = new weaver.cpt.search.CptSearchComInfo();
        pageContext.setAttribute("CptSearchComInfo", CptSearchComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.crm.CrmShareBase CrmShareBase;
      CrmShareBase = (weaver.crm.CrmShareBase) pageContext.getAttribute("CrmShareBase");
      if (CrmShareBase == null) {
        CrmShareBase = new weaver.crm.CrmShareBase();
        pageContext.setAttribute("CrmShareBase", CrmShareBase);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.cowork.CoworkShareManager CoworkShareManager;
      CoworkShareManager = (weaver.cowork.CoworkShareManager) pageContext.getAttribute("CoworkShareManager");
      if (CoworkShareManager == null) {
        CoworkShareManager = new weaver.cowork.CoworkShareManager();
        pageContext.setAttribute("CoworkShareManager", CoworkShareManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.blog.BlogShareManager BlogShareManager;
      BlogShareManager = (weaver.blog.BlogShareManager) pageContext.getAttribute("BlogShareManager");
      if (BlogShareManager == null) {
        BlogShareManager = new weaver.blog.BlogShareManager();
        pageContext.setAttribute("BlogShareManager", BlogShareManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = HrmUserVarify.getUser (request , response) ;

//\u95ee\u98981
TestWorkflowCheck twc=new TestWorkflowCheck();
if(twc.checkURI(session,request.getRequestURI(),request.getQueryString())){
  return;
}

String resourceid = request.getParameter("resourceid");
String currentUserId = "" + user.getUID();

JSONArray json = new JSONArray();
JSONObject data = new JSONObject();

int wf_count = new WorkflowRequestUtil().getRequestCount(user,resourceid);
//\u6d41\u7a0b
data.put("name","item_workflow");
data.put("value",wf_count);
data.put("url","/workflow/request/RequestView.jsp?resourceid="+resourceid+"&isfromtab=true");
json.add(data);

//\u6587\u6863
Object[] docInfo = DocSearchComInfo.getDocCount4Hrm(resourceid,user);
data.put("name","item_word");
data.put("value",docInfo[1]);
data.put("url",docInfo[0]);
json.add(data);

//\u5ba2\u6237
String[] crmInfo = CrmShareBase.getCrmCount4Hrm(resourceid,currentUserId);
data.put("name","item_custom");
data.put("value",crmInfo[1]);
data.put("url",crmInfo[0]);
json.add(data);

//\u9879\u76ee
String[] prjInfo = SearchComInfo.getPrjCount4Hrm(resourceid,user);
data.put("name","item_project");
data.put("value",prjInfo[1]);
data.put("url",prjInfo[0]);
json.add(data);

//\u8d44\u4ea7
String[] cptInfo = CptSearchComInfo.getCptCount4Hrm(resourceid,user);
data.put("name","item_cpt");
data.put("value",cptInfo[1]);
data.put("url",cptInfo[0]);
json.add(data);
	 
//\u534f\u4f5c
String[] coworkInfo = CoworkShareManager.getCoworkCount4Hrm(resourceid,currentUserId);
data.put("name","item_cowork");
data.put("value",coworkInfo[1]);
data.put("url",coworkInfo[0]);
json.add(data);

//\u5fae\u535a
String[] weiboInfo = BlogShareManager.getBlogCount4Hrm(resourceid);
data.put("name","item_weibo");
data.put("value",weiboInfo[1]);
data.put("url",weiboInfo[0]);
json.add(data);

out.print(json.toString());

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/resource/HrmResourceItemData.jsp"), 1368755154730634758L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
