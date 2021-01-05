/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._page._element._formmodecustomsearch;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.formmode.virtualform.VirtualFormHandler;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.general.Util;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.systeminfo.SystemEnv;
import net.sf.json.*;

public class _formmodecustomsearchoperation__jsp extends com.caucho.jsp.JavaPage
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
      weaver.conn.RecordSet rs_common;
      rs_common = (weaver.conn.RecordSet) pageContext.getAttribute("rs_common");
      if (rs_common == null) {
        rs_common = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs_common", rs_common);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
String optMode = Util.null2String(request.getParameter("optMode"));
int reportId = Util.getIntValue(request.getParameter("reportid"));
String operationSql = "";
JSONArray aJSON = new JSONArray();
JSONObject oJSON = new JSONObject();


if("getModeReportField".equals(optMode)){
	String reportFieldId = "";
	String reportFieldName = "";
	String reportFieldLabel = "";
	rs_common.executeSql("select * from mode_customsearch where id="+reportId+"");
    boolean isVirtualForm = false;
    if(rs_common.next()){
    	isVirtualForm = VirtualFormHandler.isVirtualForm(Util.getIntValue(rs_common.getString("formid"),0));
    }
    if(!isVirtualForm){
	operationSql = "select * from mode_CustomDspField where fieldid in(-1,-2) and isshow=1 and customid="+reportId+" order by fieldid asc";
	rs_common.executeSql(operationSql);
	while(rs_common.next()){
		reportFieldId = Util.null2String(rs_common.getString("fieldid"));
		if("-1".equals(reportFieldId)){
			reportFieldLabel = SystemEnv.getHtmlLabelName(722,user.getLanguage());
		}else if("-2".equals(reportFieldId)){
			reportFieldLabel = SystemEnv.getHtmlLabelName(882,user.getLanguage());
		}
		oJSON.put("fieldid", reportFieldId);
		oJSON.put("fieldname", reportFieldName);
		oJSON.put("fieldlabel", reportFieldLabel);
		aJSON.add(oJSON);
	}
    }

	operationSql = "select a.fieldid, b.fieldname, c.labelname from mode_CustomDspField a left join workflow_billfield b on a.fieldid=b.id left join HtmlLabelInfo c on b.fieldlabel=c.indexid ";
	operationSql+= "where a.customid="+reportId+" and isshow=1 and c.languageid="+user.getLanguage()+" ";
	//operationSql+= "order by a.dborder asc";
	rs_common.executeSql(operationSql);
	while(rs_common.next()){
		reportFieldId = Util.null2String(rs_common.getString("fieldid"));
		reportFieldName = Util.null2String(rs_common.getString("fieldname"));
		reportFieldLabel = Util.null2String(rs_common.getString("labelname"));
		oJSON.put("fieldid", reportFieldId);
		oJSON.put("fieldname", reportFieldName);
		oJSON.put("fieldlabel", reportFieldLabel);
		aJSON.add(oJSON);
	}
	out.println(aJSON);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/element/FormModeCustomSearch/FormModeCustomSearchOperation.jsp"), -3131368457991371379L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  static {
    _jsp_string1 = "\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
  }
}
