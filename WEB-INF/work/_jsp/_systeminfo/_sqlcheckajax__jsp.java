/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._systeminfo;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.*;
import weaver.conn.*;
import weaver.hrm.*;
import java.sql.*;
import net.sf.json.JSONObject;
import weaver.servicefiles.DataSourceXML;
import java.util.Hashtable;

public class _sqlcheckajax__jsp extends com.caucho.jsp.JavaPage
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
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.workflow.automatic.automaticconnect automaticconnect;
      automaticconnect = (weaver.workflow.automatic.automaticconnect) pageContext.getAttribute("automaticconnect");
      if (automaticconnect == null) {
        automaticconnect = new weaver.workflow.automatic.automaticconnect();
        pageContext.setAttribute("automaticconnect", automaticconnect);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
out.clear();
response.setContentType("text/xml;charset=UTF-8");
String sqlcontent = Util.null2String(request.getParameter("sql"));
String datasourceid = Util.null2String(request.getParameter("datasourceid"));
String isFormMode = Util.null2String(request.getParameter("isFormMode"));
boolean isCanUse = false;
User user = HrmUserVarify.getUser (request , response) ;
JSONObject jsonObject = new JSONObject();
if(user==null){
	if("1".equals(isFormMode)){
		jsonObject.put("isCanUse",isCanUse);
		jsonObject.put("errormsg","-101");
		response.getWriter().write(jsonObject.toString());
	}
	return;
}
boolean userRight = HrmUserVarify.checkUserRight("WorkflowManage:All", user);
if (!userRight && !HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	if("1".equals(isFormMode)){
		jsonObject.put("isCanUse",isCanUse);
		jsonObject.put("errormsg","-102");
		response.getWriter().write(jsonObject.toString());
	}
	return;
}

String errormsg = "";
try{
	ConnStatement statement = null;
	int index = sqlcontent.indexOf("doFieldSQL(\"");
	if(index > -1){
		sqlcontent = sqlcontent.substring(index+12);
		index = sqlcontent.lastIndexOf("\")");
		if(index > -1){
			sqlcontent = sqlcontent.substring(0, index);
		}
	}
	
	sqlcontent = sqlcontent.trim();
	if(!"".equals(sqlcontent) && !sqlcontent.toLowerCase().startsWith("select")){
		if("1".equals(isFormMode)){
			jsonObject.put("isCanUse",isCanUse);
			jsonObject.put("errormsg","");
			response.getWriter().write(jsonObject.toString());
		}
		return;
	}
	sqlcontent = sqlcontent.replaceAll("\\'\\$([0-9]*)\\$\\'", "'19700101'");
	sqlcontent = sqlcontent.replaceAll("\\$([0-9]*)\\$", "'19700101'");
	sqlcontent = sqlcontent.replaceAll("\\$(-[0-9]*)\\$", "'19700101'");
	sqlcontent = sqlcontent.replaceAll("\\$([currentdate]*)\\$", "1970-01-01");
	sqlcontent = sqlcontent.replaceAll("\\$([billid|currentuser|currentdept|wfcreater|wfcredept|id|requestid]*)\\$", "0");
	if(!"".equals(sqlcontent)){
		if("".equals(datasourceid) || "null".equals(datasourceid)){
			try{
				statement = new ConnStatement();
				statement.setStatementSql(sqlcontent);
				statement.executeQuery();
				isCanUse = true;
			}catch(Exception e){
				errormsg = e.getMessage();
				isCanUse = false;
			}finally{
				try{
					statement.close();
					statement = null;
				}catch(Exception e){
					errormsg = e.getMessage();
					//\u00e6\u009e\u0081\u00e6\u009c\u0089\u00e5\u008f\u00af\u00e8\u0083\u00bd\u00e5\u0087\u00ba\u00e9\u0094\u0099\u00ef\u00bc\u008c\u00e5\u0087\u00ba\u00e9\u0094\u0099\u00e6\u0097\u00b6\u00e4\u00b8\u008d\u00e5\u0081\u009a\u00e4\u00bb\u00bb\u00e4\u00bd\u0095\u00e5\u00a4\u0084\u00e7\u0090\u0086
				}
			}
		}else{//\u00e6\u0095\u00b0\u00e6\u008d\u00ae\u00e6\u00ba\u0090
			Connection conn = null;
			Statement stmt = null;
			try{
				conn = automaticconnect.getConnection("datasource."+datasourceid);//\u00e8\u008e\u00b7\u00e5\u00be\u0097\u00e5\u00a4\u0096\u00e9\u0083\u00a8\u00e8\u00bf\u009e\u00e6\u008e\u00a5
				stmt = conn.createStatement();
				stmt.executeQuery(sqlcontent);
				isCanUse = true;
			}catch(Exception e){
				errormsg = e.getMessage();
				isCanUse = false;
			}finally{
				try{
					stmt.close();
					conn.close();
				}catch(Exception e){
					errormsg = e.getMessage();
				}
			}
		}
	}else{
		isCanUse = true;
	}
}catch(Exception e){
	errormsg = e.getMessage();
	isCanUse = false;
}
if(isCanUse){
	errormsg = "";
}else{
	if(errormsg.equals("null")){
		errormsg = "";
	}
}
if("1".equals(isFormMode)){
	jsonObject.put("isCanUse",isCanUse);
	jsonObject.put("errormsg",errormsg);
	response.getWriter().write(jsonObject.toString());
	return;
}

      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((isCanUse));
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("systeminfo/SqlCheckAjax.jsp"), -3816736900857603754L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  private final static char []_jsp_string3;
  private final static char []_jsp_string1;
  static {
    _jsp_string2 = "\r\n<information>\r\n<iscanuse>".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string3 = "</iscanuse>\r\n</information>".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
