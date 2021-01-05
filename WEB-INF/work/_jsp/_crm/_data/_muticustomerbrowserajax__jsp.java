/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._crm._data;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.*;
import weaver.hrm.*;
import java.util.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class _muticustomerbrowserajax__jsp extends com.caucho.jsp.JavaPage
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
      weaver.crm.Maint.CustomerTypeComInfo CustomerTypeComInfo;
      CustomerTypeComInfo = (weaver.crm.Maint.CustomerTypeComInfo) pageContext.getAttribute("CustomerTypeComInfo");
      if (CustomerTypeComInfo == null) {
        CustomerTypeComInfo = new weaver.crm.Maint.CustomerTypeComInfo();
        pageContext.setAttribute("CustomerTypeComInfo", CustomerTypeComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.city.CityComInfo CityComInfo;
      CityComInfo = (weaver.hrm.city.CityComInfo) pageContext.getAttribute("CityComInfo");
      if (CityComInfo == null) {
        CityComInfo = new weaver.hrm.city.CityComInfo();
        pageContext.setAttribute("CityComInfo", CityComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.crm.CrmShareBase CrmShareBase;
      CrmShareBase = (weaver.crm.CrmShareBase) pageContext.getAttribute("CrmShareBase");
      if (CrmShareBase == null) {
        CrmShareBase = new weaver.crm.CrmShareBase();
        pageContext.setAttribute("CrmShareBase", CrmShareBase);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
User user = HrmUserVarify.getUser (request , response) ;
String src = Util.null2String(request.getParameter("src"));
String check_per = Util.null2String(request.getParameter("resourceids"));
if(check_per.equals("")){
	check_per = Util.null2String(request.getParameter("systemIds"));
	if(check_per.equals(""))
		check_per="''";
}

if("dest".equals(src)){
	
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	if(!"".equals(check_per)){
		JSONArray array = new JSONArray();
		JSONObject json = new JSONObject();
		rs.execute("select * from CRM_CustomerInfo where id in ("+check_per+")");
		while(rs.next()){
			JSONObject child = new JSONObject();
			child.put("id", rs.getString("id"));
			child.put("name", rs.getString("name"));
			child.put("type", CustomerTypeComInfo.getCustomerTypename(rs.getString("type")));
			child.put("city", CityComInfo.getCityname(rs.getString("city")));
			array.add(child);
		}
		/*
		int RecordSetCounts = rs.getCounts();
		int totalPage = RecordSetCounts/perpage;
		if(totalPage%perpage>0||totalPage==0){
			totalPage++;
		}
		*/
		json.put("currentPage", 1);
		//json.put("totalPage", totalPage);
		json.put("mapList",array.toString());
		out.println(json.toString());
		
	}else{
		JSONObject json = new JSONObject();
		json.put("currentPage", 1);
		json.put("totalPage", 0);
		json.put("mapList",null);
		out.println(json.toString());
		
	}
}else{
	int perpage = Util.getIntValue(request.getParameter("pageSize"),10) ;
	int pagenum = Util.getIntValue(request.getParameter("currentPage") , 1) ;
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	
	String name = Util.null2String(request.getParameter("name"));
	String crmcode = Util.null2String(request.getParameter("crmcode"));
	String type = Util.null2String(request.getParameter("type"));
	String city = Util.null2String(request.getParameter("City"));
	String country1 = Util.null2String(request.getParameter("country1"));
	String departmentid = Util.null2String(request.getParameter("departmentid"));
	String crmManager = Util.null2String(request.getParameter("crmManager"));
	String sectorInfo = Util.null2String(request.getParameter("sectorInfo"));
	String customerStatus = Util.null2String(request.getParameter("customerStatus"));
	String customerDesc = Util.null2String(request.getParameter("customerDesc"));
	String customerSize = Util.null2String(request.getParameter("customerSize"));
	
	if(sqlwhere.equals("")){
		sqlwhere = " where t1.deleted<>1";
	}else{
		sqlwhere += " and t1.deleted<>1 " ;
	}
	
	if(user.getLogintype().equals("1")){
		sqlwhere +=" and t1.id = t2.relateditemid";
	}else{
		sqlwhere +=" and t1.deleted<>1 and t1.agent="+user.getUID();
	}
	
	if(!name.equals("")){
			sqlwhere += " and t1.name like '%" + Util.fromScreen2(name,user.getLanguage()) +"%' ";
	}
	if(!crmcode.equals("")){
			sqlwhere += " and t1.crmcode like '%" + Util.fromScreen2(crmcode,user.getLanguage()) +"%' ";
	}
	if(!type.equals("")){
			sqlwhere += " and t1.type = "+ type;
	}
	if(!city.equals("")){
			sqlwhere += " and t1.city = " + city ;
	}
	if(!country1.equals("")){
			sqlwhere += " and t1.country = "+ country1;
	}
	if(!departmentid.equals("")){
			sqlwhere += " and t1.department =" + departmentid +" " ;
	}
	if(!crmManager.equals("")){
			sqlwhere += " and t1.manager =" + crmManager +" " ;
	}
	if(!sectorInfo.equals("")){
			sqlwhere += " and t1.sector = "+ sectorInfo;
	}
	if(!customerStatus.equals("")){
			sqlwhere += " and t1.status = "+ customerStatus;
	}else{
			//sqlwhere += " and t1.status <> 1 ";   
	}
	if(!customerDesc.equals("")){
			sqlwhere += " and t1.description = "+ customerDesc;
	}
	if(!customerSize.equals("")){
			sqlwhere += " and t1.size_n = "+ customerSize;
	}

	String leftjointable = CrmShareBase.getTempTable(""+user.getUID());

	//\u6dfb\u52a0\u5224\u65ad\u6743\u9650\u7684\u5185\u5bb9--new*/
	String sqlfrom = "";
	if(user.getLogintype().equals("1")){
		sqlfrom = "CRM_CustomerInfo t1 left join "+leftjointable+" t2 on t1.id = t2.relateditemid";
	}else{
		sqlfrom = "CRM_CustomerInfo t1";
	}
	
	if (check_per.equals("")) {
		check_per = Util.null2String(request.getParameter("excludeId"));
	}
	if (!check_per.equals("")) {
		/*
		if(check_per.indexOf(',')==0){
			check_per=check_per.substring(1);
		}
		if(!check_per.equals(""))
			sqlwhere += " and t1.id not in ("+check_per+")";
		*/
	}
	
	SplitPageParaBean spp = new SplitPageParaBean();
	spp.setBackFields(" t1.id,t1.name,t1.crmcode,t1.type,t1.city,t1.country,t1.department ");
	spp.setSqlFrom(sqlfrom);
	spp.setSqlWhere(sqlwhere);
	spp.setPrimaryKey("t1.id");
	spp.setDistinct(true);
	spp.setSortWay(spp.DESC);
	SplitPageUtil spu = new SplitPageUtil();
	spu.setSpp(spp);
	spu.setRecordCount(perpage);

	rs = spu.getCurrentPageRs(pagenum, perpage);
	
	JSONArray array = new JSONArray();
	JSONObject json = new JSONObject();
	while(rs.next()){
		JSONObject child = new JSONObject();
		child.put("id", rs.getString("id"));
		child.put("name", rs.getString("name"));
		child.put("type", CustomerTypeComInfo.getCustomerTypename(rs.getString("type")));
		child.put("city", CityComInfo.getCityname(rs.getString("city")));
		array.add(child);
	}
	json.put("currentPage", pagenum);
	json.put("mapList",array.toString());
	out.println(json.toString());
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("CRM/data/MutiCustomerBrowserAjax.jsp"), 4013883637223335524L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n \r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
