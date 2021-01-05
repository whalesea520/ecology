/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._workflow;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;

public class _workflowselectajax__jsp extends com.caucho.jsp.JavaPage
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
    try {
      
    String returnvalues="";
    int wfid=weaver.general.Util.getIntValue(request.getParameter("workflowid"));
    int formid = weaver.general.Util.getIntValue(request.getParameter("formid"),0);
    int isbill = weaver.general.Util.getIntValue(request.getParameter("isbill"),0);
    int languageid=weaver.general.Util.getIntValue(request.getParameter("languageid"),7);
    int nodeid=weaver.general.Util.getIntValue(request.getParameter("nodeid"));
    String fieldid=weaver.general.Util.null2String(request.getParameter("fieldid"));
    String option=weaver.general.Util.null2String(request.getParameter("option"));
    weaver.workflow.workflow.WfLinkageInfo wfli=new weaver.workflow.workflow.WfLinkageInfo();
    wfli.setFormid(formid);
    wfli.setIsbill(isbill);
    wfli.setWorkflowid(wfid);
    wfli.setLangurageid(languageid);
    if(option.equals("selfield")){
        java.util.ArrayList[] selectfields=wfli.getSelectFieldByEdit(nodeid);
        returnvalues = "$";
        for(int i=0;i<selectfields[0].size();i++){
            if(returnvalues.equals("")) returnvalues=selectfields[0].get(i)+"_"+selectfields[2].get(i)+"$"+selectfields[1].get(i);
            else returnvalues+=","+selectfields[0].get(i)+"_"+selectfields[2].get(i)+"$"+selectfields[1].get(i);
        }
    }
    if(option.equals("selfieldvalue")&&fieldid.indexOf("_")>-1){
        java.util.ArrayList[] selectfieldvalues=wfli.getSelectFieldItem(weaver.general.Util.getIntValue(fieldid.substring(0,fieldid.indexOf("_"))));
        returnvalues = "_$";
        for(int i=0;i<selectfieldvalues[0].size();i++){
            if(returnvalues.equals("")) returnvalues=selectfieldvalues[0].get(i)+"$"+selectfieldvalues[1].get(i);
            else returnvalues+=","+selectfieldvalues[0].get(i)+"$"+selectfieldvalues[1].get(i);
        }
    }
    response.setContentType("text/text;charset=UTF-8");//\u00e8\u00bf\u0094\u00e5\u009b\u009e\u00e7\u009a\u0084\u00e6\u0098\u00aftxt\u00e6\u0096\u0087\u00e6\u009c\u00ac\u00e6\u0096\u0087\u00e4\u00bb\u00b6
    out.print(returnvalues);

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/workflow/WorkflowSelectAjax.jsp"), 5663135670180238793L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }
}
