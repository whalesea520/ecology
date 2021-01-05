/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._browserdatadefinition;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.workflow.browserdatadefinition.ConditionFieldConfig;
import weaver.workflow.browserdatadefinition.ConditionField;
import java.util.List;
import weaver.general.Util;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.User;
import weaver.conn.RecordSet;

public class _requestbrowserfunction_0page_0fnabudgetfeetype__jsp extends com.caucho.jsp.JavaPage
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
    weaver.common.util.taglib.BrowserTag _jsp_BrowserTag_0 = null;
    com.caucho.jsp.StaticJspFragmentSupport _jsp_fragment_0 = null;
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.general.BaseBean baseBean;
      baseBean = (weaver.general.BaseBean) pageContext.getAttribute("baseBean");
      if (baseBean == null) {
        baseBean = new weaver.general.BaseBean();
        pageContext.setAttribute("baseBean", baseBean);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.fna.general.FnaCommon FnaCommon;
      FnaCommon = (weaver.fna.general.FnaCommon) pageContext.getAttribute("FnaCommon");
      if (FnaCommon == null) {
        FnaCommon = new weaver.fna.general.FnaCommon();
        pageContext.setAttribute("FnaCommon", FnaCommon);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
	//\u6d4f\u89c8\u6570\u636e\u81ea\u5b9a\u4e49-\u671f\u95f4

	User bdfUser = (User) request.getAttribute("bdfUser");
	ConditionField field = (ConditionField) request.getAttribute("bdfField");
	ConditionFieldConfig conf = field.getConfig();

	String value = field.getValue();
	if (value == null || value.isEmpty()) {
		//\u9ed8\u8ba4\u9009\u62e9\u5168\u90e8
		value = "38";
	}
	
	String sql = "";
	RecordSet rs = new RecordSet();
	String workflowId = request.getAttribute("wfid").toString();
	String fieldId = request.getAttribute("fieldId").toString();
	String fieldType = request.getAttribute("type").toString();
	List list = FnaCommon.getWfBrowdefList(workflowId, fieldId, fieldType);
	String feetypeRange = "";
	if(list != null){
		int idx = 0;
		for(Object obj : list){
			if(idx > 0){
				feetypeRange += ",";
			}
			feetypeRange += (String)obj;
			idx++;
		}
	}
	
	StringBuffer shownameSubject = new StringBuffer();
	if(!"".equals(feetypeRange)){
		sql = "select a.id, a.name from FnaBudgetfeeType a where a.id in ("+feetypeRange+") ORDER BY a.codename, a.name, a.id ";
		feetypeRange = "";
		rs.executeSql(sql);
		while(rs.next()){
			if(shownameSubject.length() > 0){
				shownameSubject.append(",");
				feetypeRange+=",";
			}
			shownameSubject.append(Util.null2String(rs.getString("name")).trim());
			feetypeRange+=Util.null2String(rs.getString("id")).trim();
		}
	}
	

      out.write(_jsp_string2, 0, _jsp_string2.length);
      _jsp_BrowserTag_0 = new weaver.common.util.taglib.BrowserTag();
      _jsp_BrowserTag_0.setJspContext(pageContext);
      _jsp_BrowserTag_0.setViewType("0");
      _jsp_BrowserTag_0.setName("feetypeRange");
      _jsp_BrowserTag_0.setBrowserUrl("/systeminfo/BrowserMain.jsp?url=/fna/browser/fnaTypeByWfBrowdef/FnaBudgetfeeTypeByWfBrowdefBrowserMulti.jsp%3Fselectids=#id#");
      _jsp_BrowserTag_0.setHasInput("true");
      _jsp_BrowserTag_0.setIsSingle("false");
      _jsp_BrowserTag_0.setHasBrowser("true");
      _jsp_BrowserTag_0.setIsMustInput("1");
      _jsp_BrowserTag_0.setCompleteUrl("/data.jsp?type=FnaFeetypeWfBtnSetting");
      _jsp_BrowserTag_0.setWidth("85%");
      _jsp_BrowserTag_0.setBrowserValue(feetypeRange );
      _jsp_BrowserTag_0.setTemptitle(SystemEnv.getHtmlLabelName(172,bdfUser.getLanguage())+SystemEnv.getHtmlLabelName(1462,bdfUser.getLanguage()) );
      _jsp_BrowserTag_0.setBrowserSpanValue(FnaCommon.escapeHtml(shownameSubject.toString()) );
      _jsp_BrowserTag_0.setJspBody(_jsp_fragment_0 = com.caucho.jsp.StaticJspFragmentSupport.create(_jsp_fragment_0, pageContext, "\r\n"));
      _jsp_BrowserTag_0.doTag();
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
    manager.addTaglibFunctions(_jsp_functionMap, "wea", "/WEB-INF/weaver.tld");
    manager.addTaglibFunctions(_jsp_functionMap, "brow", "/browserTag");
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/browserdatadefinition/RequestBrowserfunction_page_fnabudgetfeetype.jsp"), -2305758659789961446L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("WEB-INF/tld/browser.tld"), 840991278995890201L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, new com.caucho.make.ClassDependency(weaver.common.util.taglib.BrowserTag.class, -2685375837665967596L));
  }

  static {
    try {
    } catch (Exception e) {
      e.printStackTrace();
      throw new RuntimeException(e);
    }
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}