/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._search;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.io.Writer;

public class _workflowunoperatorpersons__jsp extends com.caucho.jsp.JavaPage
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
      weaver.hrm.resource.ResourceComInfo rc;
      rc = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("rc");
      if (rc == null) {
        rc = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("rc", rc);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.crm.Maint.CustomerInfoComInfo cci;
      cci = (weaver.crm.Maint.CustomerInfoComInfo) pageContext.getAttribute("cci");
      if (cci == null) {
        cci = new weaver.crm.Maint.CustomerInfoComInfo();
        pageContext.setAttribute("cci", cci);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
String requestid=Util.null2String(request.getParameter("requestid"));
String returntdid=Util.null2String(request.getParameter("returntdid"));
String returnStr="";
if(requestid.indexOf("-")==-1) {
//\u589e\u52a0isremark\u5b57\u6bb5\uff0c\u7528\u6765\u5224\u65ad\u662f\u5426\u5f52\u6863\u8282\u70b9
//rs.executeSql("select distinct userid,usertype,agenttype,agentorbyagentid from workflow_currentoperator where (isremark in ('0','1','5','7','8','9') or (isremark='4' and viewtype=0))  and requestid = " + requestid);
rs.executeSql("select distinct userid,usertype,agenttype,agentorbyagentid,isremark from workflow_currentoperator where (isremark in ('0','1','5','7','8','9') or (isremark='4' and viewtype=0))  and requestid = " + requestid);
     
        while(rs.next()){
        	if(returnStr.equals("")){
        		if(rs.getInt("usertype")==0){
	        		//if(rs.getInt("agenttype")==2)
	        		//	returnStr +=  rc.getResourcename(rs.getString("agentorbyagentid"))+"->"+rc.getResourcename(rs.getString("userid"));
	        		//else
	        		//	returnStr +=  rc.getResourcename(rs.getString("userid"));
                    if(rs.getInt("agenttype")==2){
                        returnStr +=  rc.getResourcename(rs.getString("agentorbyagentid"))+"->"+rc.getResourcename(rs.getString("userid"));
                    //\u5224\u65ad\u662f\u5426\u88ab\u4ee3\u7406\u8005,\u5982\u679c\u662f\uff0c\u5219\u4e0d\u663e\u793a\u8be5\u8bb0\u5f55
                    }else if(rs.getInt("agenttype")==1 && rs.getInt("isremark") == 4){
                        continue;
                    }else{
                        returnStr +=  rc.getResourcename(rs.getString("userid"));
                    }
        		}else{
        			returnStr +=  cci.getCustomerInfoname(rs.getString("userid"));
        		}
        	}
        	else{
        		if(rs.getInt("usertype")==0){        		
	        		//if(rs.getInt("agenttype")==2)
	        		//	returnStr +=  ","+rc.getResourcename(rs.getString("agentorbyagentid"))+"->"+rc.getResourcename(rs.getString("userid"));
	        		//else
	        		//	returnStr +=  ","+rc.getResourcename(rs.getString("userid"));
	        		if(rs.getInt("agenttype")==2){
                        returnStr +=  ","+rc.getResourcename(rs.getString("agentorbyagentid"))+"->"+rc.getResourcename(rs.getString("userid"));
                    //\u5224\u65ad\u662f\u5426\u88ab\u4ee3\u7406\u8005,\u5982\u679c\u662f\uff0c\u5219\u4e0d\u663e\u793a\u8be5\u8bb0\u5f55
                    }else if(rs.getInt("agenttype")==1 && rs.getInt("isremark") == 4){
                        continue;
	        		}else{
                        returnStr +=  ","+rc.getResourcename(rs.getString("userid"));
	        		}
	    		}else{
	    			//TD11591(\u4eba\u529b\u8d44\u6e90\u4e0e\u5ba2\u6237\u540c\u65f6\u5b58\u5728\u65f6\u3001\u52a0','\u5904\u7406)
	    			returnStr +=  ","+cci.getCustomerInfoname(rs.getString("userid"));
	    		}
        	}
        }
		out.print(returnStr);
		return;
}else{
    rs.executeSql("select distinct userid from ofs_todo_data where requestid="+requestid+" and isremark='0' and islasttimes=1");
    while(rs.next()){
        returnStr += rc.getResourcename(rs.getString("userid"))+",";
    }
	if(returnStr.endsWith(",")){
		returnStr = returnStr.substring(0,returnStr.length()-1);
	}
    out.print(returnStr);
    return;
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/search/WorkflowUnoperatorPersons.jsp"), -4817960627451370070L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}