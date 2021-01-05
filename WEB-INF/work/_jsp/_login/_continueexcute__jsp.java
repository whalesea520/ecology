/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._login;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.InitServer;
import weaver.general.BaseBean;
import weaver.general.Util;
import weaver.general.GCONST;
import weaver.system.SystemUpgrade;
import weaver.file.FileManage;
import weaver.system.SysUpgradeCominfo;
import java.io.*;
import weaver.conn.RecordSet;

public class _continueexcute__jsp extends com.caucho.jsp.JavaPage
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
      



String skipall = Util.null2String(request.getParameter("skipall"));
if("1".equals(skipall)) {

	Thread threadSysUpgrade = null;
	threadSysUpgrade = (Thread)weaver.general.InitServer.getThreadPool().get(0);
	BaseBean baseBean = new BaseBean();
	if(!threadSysUpgrade.isAlive()){
		SysUpgradeCominfo suc=new SysUpgradeCominfo();
		int pagestatus = suc.getPagestatus();
		String sqlname = suc.getErrorFile();
		//\u91cd\u65b0\u8ba1\u7b97\u8fd0\u884c\u6bd4\u4f8b
		String sqlpath = GCONST.getRootPath() + "sqlupgrade" + File.separatorChar;
		String datapath = GCONST.getRootPath()+"data" + File.separatorChar;
	   	RecordSet rs1 = new RecordSet();
	    boolean isoracle = (rs1.getDBType()).equals("oracle") ;
	    boolean isdb2 = (rs1.getDBType()).equals("db2") ;
	    boolean ismysql = (rs1.getDBType()).equals("mysql") ;
	    if(isoracle) {
	    	sqlpath = sqlpath + "Oracle";
	    	datapath = datapath + "Oracle";
	    } else if(isdb2) {
	    	sqlpath = sqlpath + "DB2" ;
	    	datapath = datapath + "DB2";
	    } else if(ismysql){
	    	sqlpath = sqlpath + "MySQL" ;
	    	datapath = datapath + "MySQL";
	    } else {
	    	sqlpath = sqlpath + "SQLServer";
	    	datapath = datapath + "SQLServer";
	    }
	   
	    
	    try {
	    	//\u62f7\u8d1d\u6574\u6761\u8bed\u53e5
			FileManage.moveFileTo(sqlpath+File.separatorChar+sqlname,datapath+File.separatorChar+sqlname);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    File sqls = new File(sqlpath);
		SystemUpgrade.setRunFileCount(sqls.list().length);
		SystemUpgrade.setRunFile(0);
		
		if(pagestatus == 3) {
			suc.ChangeProp("0","",0,0,"","");
		} else {
			suc.ChangeProp("0","",1,0,"","");
			baseBean.writeLog("SystemUpgrade Stop.....");
		    //System.out.println("SystemUpgrade Stop.....");
		    InitServer.getThreadPool().remove(0);
		    SystemUpgrade systemupgrade = new SystemUpgrade();
			Thread u = new Thread(systemupgrade);
			InitServer.getThreadPool().add(0,u);
			u.start();
			baseBean.writeLog("SystemUpgrade Restart.....");
		    //System.out.println("SystemUpgrade Restart.....");
		}
		
	}
	
} else {
	Thread threadSysUpgrade = null;
	threadSysUpgrade = (Thread)weaver.general.InitServer.getThreadPool().get(0);
	BaseBean baseBean = new BaseBean();
	if(!threadSysUpgrade.isAlive()){
		SysUpgradeCominfo suc=new SysUpgradeCominfo();
		int errorline = suc.getErrorLine();
		String errorfile = suc.getErrorFile();
		int pagestatus = suc.getPagestatus();
		//\u91cd\u65b0\u8ba1\u7b97\u8fd0\u884c\u6bd4\u4f8b
		String sqlpath = GCONST.getRootPath() + "sqlupgrade" + File.separatorChar;
	   	RecordSet rs1 = new RecordSet();
	    boolean isoracle = (rs1.getDBType()).equals("oracle") ;
	    boolean isdb2 = (rs1.getDBType()).equals("db2") ;
	    boolean ismysql = (rs1.getDBType()).equals("mysql") ;
	    if(isoracle) {
	    	sqlpath = sqlpath + "Oracle";
	    } else if(isdb2) {
	    	sqlpath = sqlpath + "DB2" ;
	    } else if(ismysql){
	    	sqlpath = sqlpath + "MySQL" ;
	    } else {
	    	sqlpath = sqlpath + "SQLServer";
	    }
	    File sqls = new File(sqlpath);
	    
	    //System.out.println("sqls.list().length:"+sqls.list().length);
	    if(sqls.list()==null) {
	    	SystemUpgrade.setRunFileCount(0);
	    } else {
	    	SystemUpgrade.setRunFileCount(sqls.list().length);
	    }
		
		SystemUpgrade.setRunFile(0);
		
		if(pagestatus == 3) {
			suc.ChangeProp("0","",0,0,"","");
		} else {
			suc.ChangeProp("0","",1,errorline,errorfile,"");
			baseBean.writeLog("SystemUpgrade Stop.....");
		    //System.out.println("SystemUpgrade Stop.....");
		    InitServer.getThreadPool().remove(0);
		    SystemUpgrade systemupgrade = new SystemUpgrade();
			Thread u = new Thread(systemupgrade);
			InitServer.getThreadPool().add(0,u);
			u.start();
			SysUpgradeCominfo.continueFlag = true;
			baseBean.writeLog("SystemUpgrade Restart.....");
		    //System.out.println("SystemUpgrade Restart.....");
		}
		
	}
}

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("login/continueExcute.jsp"), -3842630949211494341L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n<html>\r\n<head>\r\n<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\r\n<title>continueExcute</title>\r\n<style>\r\n\r\n\r\n.btnclass {\r\n	margin-top:50px;\r\n	margin-left:50px;\r\n	widht:300px;\r\n	height:30px;\r\n}\r\n</style>\r\n</head>\r\n<body>\r\n".toCharArray();
    _jsp_string1 = "\r\n</body>\r\n</html>".toCharArray();
  }
}
