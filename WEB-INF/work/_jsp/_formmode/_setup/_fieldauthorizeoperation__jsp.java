/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._setup;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.conn.RecordSetTrans;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import net.sf.json.JSONArray;
import weaver.interfaces.workflow.browser.Browser;
import com.weaver.formmodel.util.StringHelper;
import weaver.general.*;
import weaver.formmode.service.LogService;
import weaver.formmode.Module;
import weaver.formmode.log.LogType;

public class _fieldauthorizeoperation__jsp extends com.caucho.jsp.JavaPage
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
      
  String operate = Util.null2String(request.getParameter("operate"));
  if(operate.equals("Addfieldauthorize")){	//\u65b0\u589e\u6a21\u677f
	  int modeId = Util.getIntValue(StringHelper.null2String(request.getParameter("modeId")),0);
	  int formId = Util.getIntValue(StringHelper.null2String(request.getParameter("formId")),0);
	  String[] fieldauthorize_ids = request.getParameterValues("fieldauthorize_id");
	  String[] fieldids = request.getParameterValues("fieldid");
	  String[] isopens = request.getParameterValues("isopen");
	  String[] opttypes = request.getParameterValues("opttype");
	  String[] layoutids = request.getParameterValues("layoutid");
	  String[] layoutlevels = request.getParameterValues("layoutlevel");
	  RecordSetTrans rst1 = new RecordSetTrans();
	  rst1.setAutoCommit(false);//\u8bbe\u7f6e\u4e3a\u4e0d\u81ea\u52a8\u63d0\u4ea4
	  try{
		  for(int i=0;i<fieldids.length;i++){
			 int fieldauthorize_id = Util.getIntValue(fieldauthorize_ids[i],0);
			 int fieldid = Util.getIntValue(fieldids[i],0);
			 int isopen = Util.getIntValue(isopens[i],0);
			 int opttype = Util.getIntValue(opttypes[i],0);
			 int layoutid = Util.getIntValue(layoutids[i],0);
			 String layoutlevel = layoutlevels[i];
			 String sql = "";
			 if(fieldauthorize_id==0&&isopen==1){
				 sql="insert into ModeFieldAuthorize(modeid,formid,fieldid,opttype,layoutid,layoutlevel) values("+
						 modeId+","+formId+","+fieldid+","+opttype+","+layoutid+","+Util.getIntValue(layoutlevel)+")";
			 }else if(fieldauthorize_id!=0&&isopen==1){
				 sql="update ModeFieldAuthorize set modeid="+modeId+",formid="+formId+",fieldid="+fieldid+",opttype="+opttype
						 +",layoutid="+layoutid+",layoutlevel="+Util.getIntValue(layoutlevel)+" where id="+fieldauthorize_id;
			 }else if(fieldauthorize_id!=0&&isopen==0){
				 sql="delete from ModeFieldAuthorize where id="+fieldauthorize_id;
			 }
			 if(!StringHelper.isEmpty(sql))
				 rst1.executeSql(sql);//\u6267\u884csql
		  }
		  rst1.commit();//\u63d0\u4ea4
	  }catch(Exception e){
		  rst1.rollback();//\u56de\u6eda
		  e.printStackTrace();
	  }
	  response.sendRedirect("/formmode/setup/fieldauthorize.jsp?id="+modeId+"&formId="+formId);	  
  }else if("getBrowserLayout".equals(operate)){
	  String browserid = StringHelper.null2String(request.getParameter("browserid"));
	  int opttype = Util.getIntValue(StringHelper.null2String(request.getParameter("opttype")),0);
	  if(browserid.indexOf("browser")==-1)
		  return;
	  try{
	  Browser browser=(Browser)StaticObj.getServiceByFullname(browserid, Browser.class);
	  String customid = browser.getCustomid();
	  if(StringHelper.isEmpty(customid))
		  return;
	  rs.executeSql("select * from mode_custombrowser where id="+customid);
	  List<Map<String,String>> array = new ArrayList<Map<String,String>>();
	  if(rs.next()){
		  String tmpmodeid = rs.getString("modeid");
		  if(StringHelper.isEmpty(tmpmodeid))
			  return;
		  String sql="select * from modehtmllayout where type="+opttype+" and modeid="+tmpmodeid;
		  rs.executeSql(sql);
		  while(rs.next()){
			  Map<String,String> map = new HashMap<String,String>();
			  String layoutid = StringHelper.null2String(rs.getString("id"));
			  String layoutname = StringHelper.null2String(rs.getString("layoutname"));
			  map.put("layoutid", layoutid);
			  map.put("layoutname", layoutname);
			  array.add(map);
		  }
	  }
	  JSONArray data = JSONArray.fromObject(array);
	  out.print(data.toString());
	  }catch(org.apache.hivemind.ApplicationRuntimeException e){
	  }catch(Exception e){
		  e.printStackTrace();
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/setup/fieldauthorizeOperation.jsp"), -4044991412065932504L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}