/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._fna._maintenance;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.hrm.resource.ResourceComInfo;
import weaver.conn.RecordSet;
import weaver.fna.maintenance.BudgetfeeTypeComInfo;
import weaver.systeminfo.SystemEnv;
import weaver.general.BaseBean;
import org.apache.commons.lang.StringEscapeUtils;
import org.json.JSONObject;
import weaver.general.Util;
import java.util.*;
import java.sql.Timestamp;
import weaver.general.GCONST;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;

public class _budgetfeetypebrowsernewajax__jsp extends com.caucho.jsp.JavaPage
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
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs1;
      rs1 = (weaver.conn.RecordSet) pageContext.getAttribute("rs1");
      if (rs1 == null) {
        rs1 = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs1", rs1);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs2;
      rs2 = (weaver.conn.RecordSet) pageContext.getAttribute("rs2");
      if (rs2 == null) {
        rs2 = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs2", rs2);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	
}else{
	int userId = user.getUID();

	String opType = Util.null2String(request.getParameter("opType"));

	if("used".equals(opType)){
		int subjectId = Util.getIntValue(request.getParameter("subjectId"),0);
	
		String sql1 = "delete from FnaBudgetfeeTypeUsed where subjectId = "+subjectId+" and userId = "+userId;
		rs1.executeSql(sql1);

		int idx = 0;
		sql1 = "select * from FnaBudgetfeeTypeUsed where userId = "+userId+" order by orderId desc";
		rs1.executeSql(sql1);
		while(rs1.next()){
			int orderId = rs1.getInt("orderId");
			idx++;
			if(idx >= 20){
				String sql2 = "delete from FnaBudgetfeeTypeUsed where orderId <= "+orderId+" and userId = "+userId;
				rs2.executeSql(sql2);
				break;
			}
		}

		int orderId = 0;
		sql1 = "select max(orderId) maxOrderId from FnaBudgetfeeTypeUsed where userId = "+userId+"";
		rs1.executeSql(sql1);
		while(rs1.next()){
			orderId = rs1.getInt("maxOrderId");
		}
		orderId++;

		sql1 = "insert into FnaBudgetfeeTypeUsed (userId, subjectId, orderId) values ("+userId+", "+subjectId+", "+orderId+")";
		rs1.executeSql(sql1);

		idx = 0;
		sql1 = "select * from FnaBudgetfeeTypeUsed where userId = "+userId+" order by orderId asc";
		rs1.executeSql(sql1);
		while(rs1.next()){
			int _subjectId = rs1.getInt("subjectId");
			
			String sql2 = "update FnaBudgetfeeTypeUsed set orderId = "+idx+" where subjectId = "+_subjectId+" and userId = "+userId;
			rs2.executeSql(sql2);
			
			idx++;
		}
		
		
	}else if("tab".equals(opType)){//\u663e\u793a\u79d1\u76ee\u6811
		int bwTabId = Util.getIntValue(request.getParameter("bwTabId"),0);
	
		String sql1 = "delete from FnaBudgetfeeTypeBwTab where userId = "+userId;
		rs1.executeSql(sql1);
		
		sql1 = "insert into FnaBudgetfeeTypeBwTab (userId, bwTabId) values ("+userId+", "+bwTabId+")";
		rs1.executeSql(sql1);
		
	}

}

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("fna/maintenance/BudgetfeeTypeBrowserNewAjax.jsp"), -2883934685590312356L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}