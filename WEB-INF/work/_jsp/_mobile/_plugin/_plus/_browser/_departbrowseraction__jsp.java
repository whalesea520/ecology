/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._mobile._plugin._plus._browser;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.general.Util;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import java.lang.reflect.Method;
import java.lang.reflect.Constructor;
import weaver.hrm.company.DepartmentComInfo;
import weaver.hrm.company.SubCompanyComInfo;
import weaver.wxinterface.WxInterfaceInit;
import weaver.wxinterface.FormatMultiLang;

public class _departbrowseraction__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  private List<Map<String, Object>> getSubCompanyByTree(String pid,int selectType,User user,String alllowsubcompanystr,String alllowdepartmentstr,
  		String alllowsubcompanyviewstr,String alllowdepartmentviewstr) throws Exception{
  	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
  	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
  	subCompanyComInfo.setTofirstRow();
  	while(subCompanyComInfo.next()){
  		String supsubcomid = subCompanyComInfo.getSupsubcomid();
  		if(supsubcomid==null||supsubcomid==""){
  			supsubcomid = "0";
  		}
  		String canceled = subCompanyComInfo.getCompanyiscanceled();
  		if(!supsubcomid.equals(pid) || "1".equals(canceled)){
  			continue;
  		}
  		String id = subCompanyComInfo.getSubCompanyid();
  		if((alllowsubcompanystr.length()>0 || alllowsubcompanyviewstr.length()>0)){
  			if((","+alllowsubcompanystr+",").indexOf(","+id+",")==-1&&
  				(","+alllowsubcompanyviewstr+",").indexOf(","+id+",")==-1) continue;
  		}
          String name = subCompanyComInfo.getSubCompanyname();
          
          Map<String, Object> map = new HashMap<String, Object>();
          map.put("id", id);
          map.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));
          boolean hasChild = hasChildSubCompany(id,user,alllowsubcompanystr,alllowsubcompanyviewstr);
          if(selectType==1){//\u9700\u8981\u5c55\u793a\u90e8\u95e8\u7684\u8bdd
          	hasChild = hasChild||hasChildDepartment("0", id,user,alllowdepartmentstr,alllowdepartmentviewstr);
          }
          map.put("hasChild", hasChild);
          map.put("type", "2");
          result.add(map);
  	}
  	return result;
  }
  private List<Map<String, Object>> getDepartmentByTree(String pid, String _subcompanyid1,User user,String alllowdepartmentstr,String alllowdepartmentviewstr) throws Exception{
  	List<Map<String, Object>> result = new ArrayList<Map<String,Object>>();
  	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
  	departmentComInfo.setTofirstRow();
  	while(departmentComInfo.next()){
  		String supdepid = departmentComInfo.getDepartmentsupdepid();	//\u4e0a\u7ea7\u90e8\u95e8id
  		if(supdepid==null||supdepid.equals("")){
  			supdepid = "0";
  		}
  		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//\u5206\u90e8id
  		String canceled = departmentComInfo.getDeparmentcanceled();
  		if(!(supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
  				|| "1".equals(canceled)){
  			continue;
  		}
  		String id = departmentComInfo.getDepartmentid();
  		if((alllowdepartmentstr.length()>0||alllowdepartmentviewstr.length()>0) ){
  			if((","+alllowdepartmentstr+",").indexOf(","+id+",")==-1&&
  					(","+alllowdepartmentviewstr+",").indexOf(","+id+",")==-1) continue;
  		}
          String name = departmentComInfo.getDepartmentname();
          Map<String, Object> map = new HashMap<String, Object>();
          map.put("id", id);
          map.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));
          boolean hasChild = hasChildDepartment(id, _subcompanyid1,user,alllowdepartmentstr,alllowdepartmentviewstr);
          map.put("hasChild", hasChild);
          map.put("type", "3");
          result.add(map);
  	}
  	return result;
  }
  private boolean hasChildSubCompany(String pid,User user,String alllowsubcompanystr,String alllowsubcompanyviewstr) throws Exception{
  	SubCompanyComInfo subCompanyComInfo = new SubCompanyComInfo();
  	subCompanyComInfo.setTofirstRow();
  	while(subCompanyComInfo.next()){
  		String id = subCompanyComInfo.getSubCompanyid();
  		if((alllowsubcompanystr.length()>0 || alllowsubcompanyviewstr.length()>0)){
  			if((","+alllowsubcompanystr+",").indexOf(","+id+",")==-1&&
  				(","+alllowsubcompanyviewstr+",").indexOf(","+id+",")==-1) continue;
  		}
  		String supsubcomid = subCompanyComInfo.getSupsubcomid();
  		if(supsubcomid==null||supsubcomid==""){
  			supsubcomid = "0";
  		}
  		String canceled = subCompanyComInfo.getCompanyiscanceled();
  		if(supsubcomid.equals(pid) && (!"1".equals(canceled))){
  			return true;
  		}
  	}
  	return false;
  }
  private boolean hasChildDepartment(String pid, String _subcompanyid1,User user,String alllowdepartmentstr,String alllowdepartmentviewstr) throws Exception{
  	DepartmentComInfo departmentComInfo = new DepartmentComInfo();
  	departmentComInfo.setTofirstRow();
  	while(departmentComInfo.next()){
  		String id = departmentComInfo.getDepartmentid();
  		if((alllowdepartmentstr.length()>0||alllowdepartmentviewstr.length()>0) ){
  			if((","+alllowdepartmentstr+",").indexOf(","+id+",")==-1&&
  					(","+alllowdepartmentviewstr+",").indexOf(","+id+",")==-1) continue;
  		}
  		String supdepid = departmentComInfo.getDepartmentsupdepid();	//\u4e0a\u7ea7\u90e8\u95e8id
  		if(supdepid==null||supdepid.equals("")){
  			supdepid = "0";
  		}
  		String subcompanyid1 = departmentComInfo.getSubcompanyid1();	//\u5206\u90e8id
  		String canceled = departmentComInfo.getDeparmentcanceled();
  		if((supdepid.equals(pid) && (_subcompanyid1 == null || subcompanyid1.equals(_subcompanyid1)))
  				&& (!"1".equals(canceled))){
  			return true;
  		}
  	}
  	return false;
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
    response.setContentType("text/html;charset=GBK");
    request.setCharacterEncoding("GBK");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");

      out.write(_jsp_string0, 0, _jsp_string0.length);
      
//\u5224\u65ad\u7f16\u7801
if(WxInterfaceInit.isIsutf8()){
	response.setContentType("application/json;charset=UTF-8");
}
String action = Util.null2String(request.getParameter("action"));
JSONObject json = new JSONObject();
int status = 1;String msg = "";
try{
	if("getTreeData".equals(action)){
		int type = Util.getIntValue(request.getParameter("type"),1);//1.\u516c\u53f8 , 2\u5206\u90e8, 3.\u90e8\u95e8, 4.\u4eba\u5458
		int selectType = Util.getIntValue(request.getParameter("selectType"),1);//1.\u90e8\u95e8  2\u5206\u90e8
		String pid = Util.null2String(request.getParameter("pid"));
		List<Map<String, Object>> datas = new ArrayList<Map<String,Object>>();
		//\u5982\u679c\u542f\u7528\u4e86\u5206\u6743 \u6709\u6743\u9650\u7684\u5206\u90e8\u548c\u53ef\u4ee5\u67e5\u770b\u7684\u5206\u90e8  \u6709\u6743\u9650\u7684\u90e8\u95e8\u548c\u53ef\u4ee5\u67e5\u770b\u7684\u90e8\u95e8 \u5b57\u7b26\u4e32\u7528\u9017\u53f7\u5206\u9694
		String alllowsubcompanystr = "",alllowsubcompanyviewstr = "",alllowdepartmentstr = "",alllowdepartmentviewstr = "";
		boolean useAppDetach = false;//\u662f\u5426\u542f\u7528\u5206\u6743
		try{
			Class pvm = Class.forName("weaver.hrm.appdetach.AppDetachComInfo");
			Constructor constructor = pvm.getConstructor(User.class);
			Object AppDetachComInfo = constructor.newInstance(user);
			Method m = pvm.getDeclaredMethod("isUseAppDetach");
			useAppDetach = (Boolean)m.invoke(AppDetachComInfo);
			if(useAppDetach){
				Method m1 = pvm.getDeclaredMethod("getAlllowsubcompanyviewstr");
				alllowsubcompanyviewstr = (String)m1.invoke(AppDetachComInfo);
				Method m2 = pvm.getDeclaredMethod("getAlllowdepartmentviewstr");
				alllowdepartmentviewstr = (String)m2.invoke(AppDetachComInfo);
				Method m3 = pvm.getDeclaredMethod("getAlllowsubcompanystr");
				alllowsubcompanystr = (String)m3.invoke(AppDetachComInfo);
				Method m4 = pvm.getDeclaredMethod("getAlllowdepartmentstr");
				alllowdepartmentstr = (String)m4.invoke(AppDetachComInfo);
			}
		}catch(Exception e){
			//e.printStackTrace();
		}
		if(type==1){
			pid = "0";
			datas.addAll(getSubCompanyByTree(pid,selectType,user,alllowsubcompanystr,alllowdepartmentstr,alllowsubcompanyviewstr,alllowdepartmentviewstr));
		}else if(type==2){
			if(selectType==1){
				datas.addAll(getDepartmentByTree("0", pid,user,alllowdepartmentstr,alllowdepartmentviewstr));
			}
			datas.addAll(getSubCompanyByTree(pid,selectType,user,alllowsubcompanystr,alllowdepartmentstr,alllowsubcompanyviewstr,alllowdepartmentviewstr));
		}else if(type==3&&selectType==1){
			datas.addAll(getDepartmentByTree(pid, null,user,alllowdepartmentstr,alllowdepartmentviewstr));
		}
		json.put("datas", JSONArray.fromObject(datas));
		status = 0;
	}else if("getSelectedDatas".equals(action)){
		String selectedIds = Util.null2String(request.getParameter("selectedIds"));
		int selectType = Util.getIntValue(request.getParameter("selectType"),1);//1.\u90e8\u95e8  2\u5206\u90e8
		DepartmentComInfo departmentComInfo = new DepartmentComInfo();
		SubCompanyComInfo sci = new SubCompanyComInfo();
		JSONArray selectedArr = new JSONArray();
		String[] selectedIdArr = selectedIds.split(",");
		for(String selectedId : selectedIdArr){
			if(!selectedId.trim().equals("")){
				String name = "";
				if(selectType==1){
					name = departmentComInfo.getDepartmentname(selectedId);//\u540d\u79f0
				}else{
					name = sci.getSubCompanyname(selectedId);
				}
				JSONObject selectedObj = new JSONObject();
				selectedObj.put("id", selectedId);	//id
				selectedObj.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));//\u540d\u79f0
				selectedArr.add(selectedObj);
			}
		}
		json.put("datas", selectedArr);
		status = 0;
	}
}catch(Exception e){
	msg = "\u64cd\u4f5c\u5931\u8d25:"+e.getMessage();
}
json.put("status", status);
json.put("msg", msg);
//System.out.println(json.toString());
out.print(json.toString());

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("mobile/plugin/plus/browser/departBrowserAction.jsp"), -7832322833477237299L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}