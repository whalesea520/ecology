/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._interfaces;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.net.*;
import weaver.file.FileUploadToPath;
import weaver.formmode.excel.ImpExcelServer;
import weaver.hrm.User;
import weaver.hrm.HrmUserVarify;

public class _modedatabatchimportoperation__jsp extends com.caucho.jsp.JavaPage
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
      weaver.formmode.interfaces.ModeDataBatchImport ModeDataBatchImport;
      ModeDataBatchImport = (weaver.formmode.interfaces.ModeDataBatchImport) pageContext.getAttribute("ModeDataBatchImport");
      if (ModeDataBatchImport == null) {
        ModeDataBatchImport = new weaver.formmode.interfaces.ModeDataBatchImport();
        pageContext.setAttribute("ModeDataBatchImport", ModeDataBatchImport);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.formmode.setup.ModeRightInfo ModeRightInfo;
      ModeRightInfo = (weaver.formmode.setup.ModeRightInfo) pageContext.getAttribute("ModeRightInfo");
      if (ModeRightInfo == null) {
        ModeRightInfo = new weaver.formmode.setup.ModeRightInfo();
        pageContext.setAttribute("ModeRightInfo", ModeRightInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
out.clear();
User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
    FileUploadToPath fu = new FileUploadToPath(request);
	String clientaddress = request.getRemoteAddr();
	int modeid = Util.getIntValue(fu.getParameter("modeid"),0);
	int pageexpandid = Util.getIntValue(fu.getParameter("pageexpandid"));
	String method = Util.null2String(fu.getParameter("method"));
	int sourcetype = Util.getIntValue(fu.getParameter("sourcetype"),0);
	String flag = "";
	if ("import".equals(method)) {
		int type = 4;//\u6279\u91cf\u5bfc\u5165\u6743\u9650
		if(type == 4){//\u76d1\u63a7\u6743\u9650\u5224\u65ad
			ModeRightInfo.setModeId(modeid);
			ModeRightInfo.setType(type);
			ModeRightInfo.setUser(user);
			boolean isRight = false;
			isRight = ModeRightInfo.checkUserRight(type);
			if(!isRight){
				if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
					response.sendRedirect("/notice/noright.jsp");
					return;
				}
			}
		}
		ImpExcelServer impExcelServer = new ImpExcelServer();
		impExcelServer.setClientaddress(clientaddress);
		impExcelServer.setUser(user);
		
		ModeDataBatchImport.setClientaddress(clientaddress);
		ModeDataBatchImport.setUser(user);
		
		int isnew = Util.getIntValue(fu.getParameter("isnew"),0);
		String msg = "";
		if(isnew==1){
		    msg=impExcelServer.ImportData(fu,user,request);
		}else{
		    msg=ModeDataBatchImport.ImportData(fu,user);
		    flag = System.currentTimeMillis() + "_DataBatchImport";
		    session.setAttribute(flag,msg);
		    response.sendRedirect("/formmode/interfaces/ModeDataBatchImport.jsp?modeid="+modeid+"&flag="+flag+"&pageexpandid="+pageexpandid+"&sourcetype="+sourcetype);
		    return;
		}
	} else if ("save".equals(method)) {
		String interfacePath = Util.null2String(fu.getParameter("interfacePath"));
		String formId = Util.null2String(fu.getParameter("formId"));
		int importorder = Util.getIntValue(fu.getParameter("importorder"),0);
		String isUse = Util.null2String(fu.getParameter("isUse"));
		String validateid = Util.null2String(fu.getParameter("importValidationId"));
		rs.executeSql("delete mode_DataBatchImport where modeid="+modeid);
		rs.executeSql("insert into mode_DataBatchImport(modeid,interfacepath,isuse,validateid,importorder) values("+modeid+",'"+interfacePath+"','"+isUse+"','"+validateid+"',"+importorder+")");
		String url = "/formmode/interfaces/ModeDataBatchImport.jsp?modeid="+modeid+"&sourcetype="+sourcetype;
		out.println("<script>window.parent.location.href ='"+url+"'+'&t='+new Date().getTime();</script>");
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/interfaces/ModeDataBatchImportOperation.jsp"), 7079571615306351459L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
