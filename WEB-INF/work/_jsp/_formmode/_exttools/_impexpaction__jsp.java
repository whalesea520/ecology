/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._exttools;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.formmode.exttools.impexp.common.StringUtils;
import weaver.formmode.exttools.impexp.exp.service.ExpDataService;
import weaver.formmode.exttools.impexp.exp.service.ImpDataService;
import weaver.file.FileUpload;
import weaver.file.FileManage;
import weaver.conn.RecordSet;
import weaver.general.GCONST;
import java.io.File;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;
import net.sf.json.JSONObject;
import weaver.formmode.exttools.impexp.exp.service.ProgressStatus;
import java.util.Map;
import weaver.formmode.exttools.impexp.exp.service.OperateThread;
import weaver.formmode.exttools.impexp.common.FileUtils;

public class _impexpaction__jsp extends com.caucho.jsp.JavaPage
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
    response.setContentType("text/html;charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
String type = StringUtils.null2String(request.getParameter("type"));
String id = StringUtils.null2String(request.getParameter("id"));
String subCompanyId = StringUtils.null2String(request.getParameter("subCompanyId"));
User user = HrmUserVarify.getUser(request, response);
String sessionid = session.getId();
int userid = user.getUID();
String pageid = StringUtils.null2String(request.getParameter("pageid"));
JSONObject jsonObject = new JSONObject();
if("0".equals(type)){//\u5bfc\u51fa
	ProgressStatus.create(sessionid,pageid,userid,0);
	int ptype = StringUtils.getIntValue(StringUtils.null2String(request.getParameter("ptype")));
	OperateThread operateThread = new OperateThread(id,userid,sessionid,ptype,pageid);
	Thread thread = new Thread(operateThread);
	OperateThread.putThread(sessionid, pageid, operateThread);
	thread.start();
	out.print(jsonObject.toString());
	return;
}else if("1".equals(type)){//\u5bfc\u5165
	ProgressStatus.create(sessionid,pageid,userid,1);
	String isadd = StringUtils.null2String(request.getParameter("isadd"));
	String version = StringUtils.null2String(request.getParameter("version"));
	RecordSet rs = new RecordSet();
	FileUpload fu = new FileUpload(request,false);
	FileManage fm = new FileManage();
	String xmlfilepath="";
	int fileid = 0 ;
	fileid = StringUtils.getIntValue(fu.uploadFiles("filename"),0);
	String filename = "data.zip";
	String sql = "select * from imagefile where imagefileid = "+fileid;
	rs.executeSql(sql);
	String uploadfilepath="",isaesencrypt="",aescode="";
	if(rs.next()){
		uploadfilepath =  rs.getString("filerealpath");
		isaesencrypt = rs.getString("isaesencrypt");
		aescode = rs.getString("aescode");
	}
	String exceptionMsg ="";
	if(!uploadfilepath.equals("")){
		try{
			xmlfilepath = GCONST.getRootPath()+"formmode"+File.separatorChar+"import"+File.separatorChar+filename ;
			File oldfile = new File(xmlfilepath);
			if(oldfile.exists()){
				oldfile.delete();
			}
			if("1".equals(isaesencrypt)){
				uploadfilepath = FileUtils.aesDesEncrypt(uploadfilepath,aescode);
			}
			fm.copy(uploadfilepath,xmlfilepath);
		}catch(Exception e){
			exceptionMsg = "\u8bfb\u53d6\u6587\u4ef6\u5931\u8d25!";//\u8bfb\u53d6\u6587\u4ef6\u5931\u8d25!
			ProgressStatus.finish(sessionid,pageid);
		}
	}
	boolean add = "1".equals(isadd)?true:false;
	Thread thread = new Thread(new OperateThread(id,userid,xmlfilepath,fileid,sessionid,add,version,pageid,subCompanyId));
	thread.start();
	out.print(jsonObject.toString());
}else if("2".equals(type)){//\u67e5\u770b\u5bfc\u5165/\u5bfc\u51fa\u65e5\u5fd7\u660e\u7ec6
	int logid = StringUtils.getIntValue(request.getParameter("logid"));
	String sql = "select * from mode_impexp_logdetail where logid='"+logid+"' order by id";
	RecordSet rs = new RecordSet();
	rs.executeSql(sql);
	String str = "";
	int i = 1;
	while(rs.next()){
		String message = StringUtils.null2String(rs.getString("message"));
		str += (i++)+":"+message+"\n";
	}
	out.clear();
	out.print(str);
	return;
}else if("3".equals(type)){//\u83b7\u53d6\u5bfc\u5165\u5bfc\u51fa\u8fdb\u5ea6
	jsonObject.put("inprocess",false);
	Map<String,Object> progressStatus = ProgressStatus.get(sessionid,pageid);
	//System.out.println(progressStatus);
	if(progressStatus!=null){
		int persent = ProgressStatus.getCurrentProgressPersent(sessionid,pageid);
		int ptype = ProgressStatus.getPtype(sessionid,pageid);
		String logid = ProgressStatus.getLogid(sessionid,pageid);
		jsonObject.put("inprocess",true);
		jsonObject.put("process",persent);
		jsonObject.put("ptype",ptype);
		jsonObject.put("logid",logid);
		jsonObject.put("error",progressStatus.get("error"));
		if(progressStatus.containsKey("datatype")){
			if("app".equals(StringUtils.null2String(progressStatus.get("datatype")))){
				jsonObject.put("datatype","\u5e94\u7528");
			}else if("mode".equals(StringUtils.null2String(progressStatus.get("datatype")))){
				jsonObject.put("datatype","\u6a21\u5757");
			}
		}
		String fileid = StringUtils.null2String(progressStatus.get("fileid"));
		if(!"".equals(fileid)){
			jsonObject.put("fileid",fileid);
		}
	}
	out.print(jsonObject.toString());
}else if("4".equals(type)){
	ProgressStatus.finish(sessionid,pageid);
	return;
} else if("5".equals(type)) {
	OperateThread.removeThread(sessionid, pageid);
	ProgressStatus.finish(sessionid,pageid);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/exttools/impexpAction.jsp"), -3810565685052773092L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  static {
    _jsp_string0 = " \r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}
