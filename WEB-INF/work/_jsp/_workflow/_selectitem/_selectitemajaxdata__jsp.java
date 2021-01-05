/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._selectitem;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.hrm.*;
import weaver.conn.RecordSet;
import java.util.*;
import org.json.JSONArray;
import org.json.JSONObject;

public class _selectitemajaxdata__jsp extends com.caucho.jsp.JavaPage
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
    response.setContentType("text/html; charset=utf-8");
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
      weaver.workflow.selectItem.SelectItemManager SelectItemManager;
      SelectItemManager = (weaver.workflow.selectItem.SelectItemManager) pageContext.getAttribute("SelectItemManager");
      if (SelectItemManager == null) {
        SelectItemManager = new weaver.workflow.selectItem.SelectItemManager();
        pageContext.setAttribute("SelectItemManager", SelectItemManager);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      

User user = HrmUserVarify.getUser (request , response) ;
int id = Util.getIntValue(request.getParameter("id"));
String src = Util.null2String(request.getParameter("src"));

if(src.equals("pubchoiceback")){
	String sql="SELECT id,name FROM mode_selectitempagedetail WHERE mainid="+id+" and pid=0 AND statelev=1 and (cancel IS NULL OR cancel='0' OR cancel='') ORDER BY disorder";
	//System.out.println(sql);
	rs.executeSql(sql);
	JSONArray jsonArray=new JSONArray();
	JSONObject jsonObject=new JSONObject();
	while(rs.next()){
	    int _id = Util.getIntValue(rs.getString("id"),0);
	    String _name = Util.null2String(rs.getString("name"));
	    jsonObject=new JSONObject();
		jsonObject.put("id", _id);
		jsonObject.put("name", _name);
		jsonArray.put(jsonObject);
	}
	out.println(jsonArray.toString());
	
	//System.out.println(jsonArray.toString());
}else if(src.equals("notcancel")){//\u89e3\u5c01
	int detailid = Util.getIntValue(request.getParameter("detailid"));
	ArrayList<String> arrayList = new ArrayList<String>();
	arrayList = SelectItemManager.getAllSubSelectItemId(arrayList, ""+detailid, -1);
	String allSubIds = "";//\u6240\u6709\u5b50\u9879id
	for(int j=0;j<arrayList.size();j++){
		allSubIds += ","+arrayList.get(j);
	}
	String allids = detailid + allSubIds;
	String sql = "update mode_selectitempagedetail set cancel=0 where id in ("+allids+")";
	rs.executeSql(sql);
	JSONObject jsonObject = new JSONObject();
	jsonObject.put("detailid",detailid);
	
	SelectItemManager.syncPubSelectOp(id,user.getLanguage());
	
	response.getWriter().write(jsonObject.toString());
	return;
}else if(src.equals("selectItemback")){
	JSONArray jsonArray=new JSONArray();
	JSONObject jsonObject=new JSONObject();
	Map<String,String> selectItemOptionMap = SelectItemManager.getSelectItemOption(id+"");
	for(Map.Entry<String, String> entry: selectItemOptionMap.entrySet()){
		jsonObject=new JSONObject();
		jsonObject.put("id", entry.getKey());
		jsonObject.put("name", entry.getValue());
		jsonArray.put(jsonObject);
	}
	out.println(jsonArray.toString());
}else if(src.equals("hasPubChoice")){
	int formid = Util.getIntValue(request.getParameter("formid"));
	int isdetail = Util.getIntValue(request.getParameter("isdetail"));
    String detailtable = Util.null2String(request.getParameter("detailtable"));
    boolean flag = SelectItemManager.hasPubChoice(formid,isdetail,detailtable);
	if(flag){
		out.println("true");	
	}else{
		out.println("false");
	}
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/selectItem/selectItemAjaxData.jsp"), 9062807473527492495L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  static {
    _jsp_string1 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
  }
}