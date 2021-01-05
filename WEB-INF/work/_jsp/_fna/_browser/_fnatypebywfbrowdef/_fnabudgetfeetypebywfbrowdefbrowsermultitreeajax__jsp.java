/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._fna._browser._fnatypebywfbrowdef;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
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

public class _fnabudgetfeetypebywfbrowdefbrowsermultitreeajax__jsp extends com.caucho.jsp.JavaPage
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
      weaver.conn.RecordSet rs3;
      rs3 = (weaver.conn.RecordSet) pageContext.getAttribute("rs3");
      if (rs3 == null) {
        rs3 = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs3", rs3);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
StringBuffer result = new StringBuffer();

User user = HrmUserVarify.getUser (request , response) ;
if(user == null){
	
}else{
	int userId = user.getUID();
	
	String id = Util.null2String(request.getParameter("id"));
	String name = Util.null2String(request.getParameter("name"));
	String otherParam = Util.null2String(request.getParameter("otherParam"));

	if("".equals(id)){//\u521d\u59cb\u5316\u7ec4\u7ec7\u67b6\u6784\u6811
		String _id = "0";
		String _name = SystemEnv.getHtmlLabelName(33026,user.getLanguage());//\u6240\u6709\u79d1\u76ee
		String _feelevel = "0";
		
		result.append("{"+
			"id:"+JSONObject.quote(_feelevel+"_"+_id)+","+
			"name:"+JSONObject.quote(_name)+","+
			"isParent:true"+
			//"icon:"+JSONObject.quote("/images/treeimages/global16_wev8.gif")+
			"}");
		
	}else{
		String[] idArray = id.split("_");
		int feelevel = Util.getIntValue(idArray[0], -10)+1;
		id = idArray[1];
		
		int idx = 0;
		String sql1 = "select a.id, a.name, a.codename, a.feelevel, a.Archive from FnaBudgetfeeType a "+
			" where a.feelevel = "+feelevel+" "+
			" and a.supsubject = "+Util.getIntValue(id)+" "+
			" ORDER BY a.displayOrder,a.codename, a.name, a.id ";
		rs1.executeSql(sql1);
		while(rs1.next()){
			String _id = rs1.getString("id");
			String _name = rs1.getString("name");
			int _feelevel = Util.getIntValue(rs1.getString("feelevel"));
			int _canceled = Util.getIntValue(rs1.getString("Archive"), 0);
			
			String _name1 = _name;
			if(_canceled == 1){
				_name1 += "("+SystemEnv.getHtmlLabelName(22151,user.getLanguage())+")";//\u5c01\u5b58
				continue;
			}
			
			if(idx>0){
				result.append(",");
			}
			
			String icon = "/images/treeimages/home16_wev8.gif";
			
			String isParent = "true";
			String sql2 = "select count(*) cnt from FnaBudgetfeeType a where a.supsubject = "+Util.getIntValue(_id);
			rs2.executeSql(sql2);
			if(rs2.next() && rs2.getInt("cnt") > 0){
				isParent = "true";
			}else{
				isParent = "false";
			}
			
			result.append("{"+
				"id:"+JSONObject.quote(_feelevel+"_"+_id)+","+
				"name:"+JSONObject.quote(_name1)+","+
				"isParent:"+isParent+""+
				//"icon:"+JSONObject.quote(icon)+
				"}");
			idx++;
		}
		
	}

}
//System.out.println("result="+result.toString());

      out.print(("["+result.toString()+"]" ));
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("fna/browser/fnaTypeByWfBrowdef/FnaBudgetfeeTypeByWfBrowdefBrowserMultiTreeAjax.jsp"), -37892493244913071L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
