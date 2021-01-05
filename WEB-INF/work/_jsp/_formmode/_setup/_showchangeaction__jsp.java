/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._setup;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import net.sf.json.JSONArray;
import java.net.URLDecoder;
import net.sf.json.JSONObject;
import weaver.formmode.service.FormInfoService;
import weaver.formmode.dao.BaseDao;
import java.net.URLEncoder;
import weaver.conn.RecordSet;
import java.util.*;
import weaver.general.Util;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;
import weaver.systeminfo.SystemEnv;
import weaver.formmode.ThreadLocalUser;
import weaver.systeminfo.systemright.CheckSubCompanyRight;
import java.io.IOException;

public class _showchangeaction__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  private Map getCheckRightSubCompanyParam(String userRightStr,User user,String fmdetachable,int subCompanyId,String subCompanyIdName,
  	HttpServletRequest request,HttpServletResponse response,HttpSession session){
  	int operatelevel=0;
  	Map map = new HashMap();
  	if(subCompanyIdName.equals("")){
  		subCompanyIdName = "subCompanyId";
  	}
  	
  	if(fmdetachable.equals("1")){  
  		if(subCompanyId==-1){
  		    if(request.getParameter(subCompanyIdName)==null){
  		        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
  		    }else{
  		        subCompanyId=Util.getIntValue(request.getParameter(subCompanyIdName),-1);
  		    }
  		    if(subCompanyId == -1){
  		        subCompanyId = user.getUserSubCompany1();
  		    }
  		}
  	    CheckSubCompanyRight CheckSubCompanyRight = new CheckSubCompanyRight();
  	    operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),userRightStr,subCompanyId);
  	    if(operatelevel>=0){
  		    session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
  	    }
  	}else{
  	    if(HrmUserVarify.checkUserRight(userRightStr, user)){
  	        operatelevel=2;
  	    }
  	}
  	String currentSubCompanyId = ""+session.getAttribute("defaultSubCompanyId");
  	map.put("currentSubCompanyId",currentSubCompanyId);
  	map.put("subCompanyId",subCompanyId);
  	map.put("operatelevel",operatelevel);
  	return map;
  }

  
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
      
int isIncludeToptitle = 0;
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
ThreadLocalUser.setUser(user);

      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.moduledetach.ManageDetachComInfo ManageDetachComInfo;
      ManageDetachComInfo = (weaver.hrm.moduledetach.ManageDetachComInfo) pageContext.getAttribute("ManageDetachComInfo");
      if (ManageDetachComInfo == null) {
        ManageDetachComInfo = new weaver.hrm.moduledetach.ManageDetachComInfo();
        pageContext.setAttribute("ManageDetachComInfo", ManageDetachComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.systeminfo.systemright.CheckSubCompanyRight CheckSubCompanyRight;
      CheckSubCompanyRight = (weaver.systeminfo.systemright.CheckSubCompanyRight) pageContext.getAttribute("CheckSubCompanyRight");
      if (CheckSubCompanyRight == null) {
        CheckSubCompanyRight = new weaver.systeminfo.systemright.CheckSubCompanyRight();
        pageContext.setAttribute("CheckSubCompanyRight", CheckSubCompanyRight);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.hrm.company.SubCompanyComInfo SubCompanyComInfo;
      SubCompanyComInfo = (weaver.hrm.company.SubCompanyComInfo) pageContext.getAttribute("SubCompanyComInfo");
      if (SubCompanyComInfo == null) {
        SubCompanyComInfo = new weaver.hrm.company.SubCompanyComInfo();
        pageContext.setAttribute("SubCompanyComInfo", SubCompanyComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
boolean isUseFmManageDetach=ManageDetachComInfo.isUseFmManageDetach();
String fmdetachable="0";
if(isUseFmManageDetach){
   fmdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("fmdetachable",fmdetachable);
   session.setAttribute("fmdftsubcomid",ManageDetachComInfo.getFmdftsubcomid());
}else{
   fmdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("fmdetachable",fmdetachable);
   session.setAttribute("fmdftsubcomid","0");
}

      out.write(_jsp_string3, 0, _jsp_string3.length);
      
response.reset();
out.clear();
String action = Util.null2String(request.getParameter("action"));
RecordSet rs = new RecordSet();
if(action.equalsIgnoreCase("saveForm")){
	try{
		int customid = Util.getIntValue(request.getParameter("customid"));
		int fieldid = Util.getIntValue(request.getParameter("fieldid"));
		String data = Util.null2String(request.getParameter("data"));
		rs.executeSql("delete from customfieldshowchange where customid="+customid+" and fieldid="+fieldid);
		data = URLDecoder.decode(data, "UTF-8");
		JSONArray dataArr = JSONArray.fromObject(data);
		for(int i = 0; i < dataArr.size(); i++){
			JSONObject jsonObject = (JSONObject)dataArr.get(i);
			int field_opt = Util.getIntValue(Util.null2String(jsonObject.get("field_opt")), 0);
			int field_opt2 = Util.getIntValue(Util.null2String(jsonObject.get("field_opt2")), 0);
			String field_optvalue =Util.null2String(jsonObject.get("field_optvalue"));
			String field_optvalue2 =Util.null2String(jsonObject.get("field_optvalue2"));
			String field_showvalue =Util.null2String(jsonObject.get("field_showvalue"));
			String field_backvalue =Util.null2String(jsonObject.get("field_backvalue"));
			String field_fontvalue =Util.null2String(jsonObject.get("field_fontvalue"));
			
			/* rs.executeSql("insert into customfieldshowchange(customid,fieldid,fieldopt,fieldopt2,fieldoptvalue,fieldoptvalue2,fieldshowvalue,fieldbackvalue,fieldfontvalue)"+
				" values("+customid+","+fieldid+","+field_opt+","+field_opt2+",'"+field_optvalue+"','"+field_optvalue2+"','"+field_showvalue+"','"+field_backvalue+"','"+field_fontvalue+"')"); */
			String sql = "insert into customfieldshowchange(customid,fieldid,fieldopt,fieldopt2,fieldoptvalue,fieldoptvalue2,fieldshowvalue,fieldbackvalue,fieldfontvalue)"
				+" values(?,?,?,?,?,?,?,?,?)";
			Object[] params = new Object[9];
			params[0] = customid;
			params[1] = fieldid;
			params[2] = field_opt;
			params[3] = field_opt2;
			params[4] = field_optvalue;
			params[5] = field_optvalue2;
			params[6] = field_showvalue;
			params[7] = field_backvalue;
			params[8] = field_fontvalue;
			rs.executeUpdate(sql, params);
		}
		if(dataArr.size()>0){
			out.print("1");
		}else{
			out.print("0");
		}
	}catch(Exception ep){
		ep.printStackTrace();
		out.print("error");		
	}
}else if(action.equalsIgnoreCase("clearForm")){
	try{
		int customid = Util.getIntValue(request.getParameter("customid"));
		int fieldid = Util.getIntValue(request.getParameter("fieldid"));
		String data = Util.null2String(request.getParameter("data"));
		//rs.executeSql("delete from customfieldshowchange where customid="+customid+" and fieldid="+fieldid);
		out.print("0");
	}catch(Exception ep){
		ep.printStackTrace();
		out.print("error");	
	}
}
out.flush();
out.close();

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/setup/showChangeAction.jsp"), -5439635096479990016L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/pub_init.jsp"), -4246916824298514572L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/pub_function.jsp"), 5446055981984630656L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string3;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  static {
    _jsp_string3 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
  }
}
