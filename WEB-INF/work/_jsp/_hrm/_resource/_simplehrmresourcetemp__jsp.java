/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._resource;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.*;
import weaver.systeminfo.SystemEnv;

public class _simplehrmresourcetemp__jsp extends com.caucho.jsp.JavaPage
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
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.company.DepartmentComInfo DepartmentComInfo;
      DepartmentComInfo = (weaver.hrm.company.DepartmentComInfo) pageContext.getAttribute("DepartmentComInfo");
      if (DepartmentComInfo == null) {
        DepartmentComInfo = new weaver.hrm.company.DepartmentComInfo();
        pageContext.setAttribute("DepartmentComInfo", DepartmentComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.company.SubCompanyComInfo SubCompanyComInfo;
      SubCompanyComInfo = (weaver.hrm.company.SubCompanyComInfo) pageContext.getAttribute("SubCompanyComInfo");
      if (SubCompanyComInfo == null) {
        SubCompanyComInfo = new weaver.hrm.company.SubCompanyComInfo();
        pageContext.setAttribute("SubCompanyComInfo", SubCompanyComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.job.JobTitlesComInfo JobTitlesComInfo;
      JobTitlesComInfo = (weaver.hrm.job.JobTitlesComInfo) pageContext.getAttribute("JobTitlesComInfo");
      if (JobTitlesComInfo == null) {
        JobTitlesComInfo = new weaver.hrm.job.JobTitlesComInfo();
        pageContext.setAttribute("JobTitlesComInfo", JobTitlesComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.location.LocationComInfo LocationComInfo;
      LocationComInfo = (weaver.hrm.location.LocationComInfo) pageContext.getAttribute("LocationComInfo");
      if (LocationComInfo == null) {
        LocationComInfo = new weaver.hrm.location.LocationComInfo();
        pageContext.setAttribute("LocationComInfo", LocationComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.appdetach.AppDetachComInfo AppDetachComInfo;
      AppDetachComInfo = (weaver.hrm.appdetach.AppDetachComInfo) pageContext.getAttribute("AppDetachComInfo");
      if (AppDetachComInfo == null) {
        AppDetachComInfo = new weaver.hrm.appdetach.AppDetachComInfo();
        pageContext.setAttribute("AppDetachComInfo", AppDetachComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.license.PluginUserCheck PluginUserCheck;
      PluginUserCheck = (weaver.license.PluginUserCheck) pageContext.getAttribute("PluginUserCheck");
      if (PluginUserCheck == null) {
        PluginUserCheck = new weaver.license.PluginUserCheck();
        pageContext.setAttribute("PluginUserCheck", PluginUserCheck);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
User user = (User)request.getSession(true).getAttribute("weaver_user@bean") ;

if(user==null) return;
String id = request.getParameter("userid");
String ip = HrmUserVarify.getOnlineUserIp(id);

if(AppDetachComInfo.checkUserAppDetach(id, "1", user)==0) {
	out.print("$$$noright");
	return;
}

if("".equals(ip)) 
{
	ip = ",";
}

RecordSet.executeProc("HrmResource_SelectByID",id);
RecordSet.next();
String workcode = Util.toScreen(RecordSet.getString("workcode"),user.getLanguage()) ;			/*\u59d3\u540d*/
String lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;			/*\u59d3\u540d*/
String sex = Util.toScreen(RecordSet.getString("sex"),user.getLanguage()) ;
String departmentid = Util.toScreen(RecordSet.getString("departmentid"),user.getLanguage()) ;		/*\u6240\u5c5e\u90e8\u95e8*/
String subcompanyid1 = Util.toScreen(RecordSet.getString("subcompanyid1"),user.getLanguage()) ;		/*\u6240\u5c5e\u5206\u90e8*/
String jobtitle = Util.toScreen(RecordSet.getString("jobtitle"),user.getLanguage()) ;		/*\u6240\u5c5e\u5206\u90e8*/
String status = Util.toScreen(RecordSet.getString("status"),user.getLanguage()) ;		/*\u6240\u5c5e\u5206\u90e8*/
String locationid = Util.toScreen(RecordSet.getString("locationid"),user.getLanguage()) ;		/*\u529e\u516c\u5730\u70b9*/
locationid = Util.toScreen(LocationComInfo.getLocationname(locationid),user.getLanguage());
departmentid=Util.toScreen(DepartmentComInfo.getDepartmentname(departmentid),user.getLanguage());
subcompanyid1=Util.toScreen(SubCompanyComInfo.getSubCompanyname(subcompanyid1),user.getLanguage());
if(jobtitle.length()>0)jobtitle=Util.toScreen(JobTitlesComInfo.getJobTitlesname(jobtitle),user.getLanguage());
if(status.equals("0")){
	status = SystemEnv.getHtmlLabelName(15710,user.getLanguage());
}else if(status.equals("1")){
	status = SystemEnv.getHtmlLabelName(15711,user.getLanguage());
}else if(status.equals("2")){
	status = SystemEnv.getHtmlLabelName(480,user.getLanguage());
}else if(status.equals("3")){
	status = SystemEnv.getHtmlLabelName(15844,user.getLanguage());
}else if(status.equals("4")){
	status = SystemEnv.getHtmlLabelName(6094,user.getLanguage());
}else if(status.equals("5")){
	status = SystemEnv.getHtmlLabelName(6091,user.getLanguage());
}else if(status.equals("6")){
	status = SystemEnv.getHtmlLabelName(6092,user.getLanguage());
}else if(status.equals("7")){
	status = SystemEnv.getHtmlLabelName(2245,user.getLanguage());
}else if(status.equals("10")){
	status = SystemEnv.getHtmlLabelName(1831,user.getLanguage());
}

if("0".equals(sex))
{
	sex = "Mr.";
}
else if("1".equals(sex))
{
	sex="Ms.";	
}
String jobactivitydesc = Util.toScreen(RecordSet.getString("jobactivitydesc"),user.getLanguage()) ;	/*\u804c\u8d23\u63cf\u8ff0*/
String telephone = Util.toScreen(RecordSet.getString("telephone"),user.getLanguage()) ;			/*\u529e\u516c\u7535\u8bdd*/
//String mobile = Util.toScreen(RecordSet.getString("mobile"),user.getLanguage()) ;			/*\u79fb\u52a8\u7535\u8bdd*/
String mobile = ResourceComInfo.getMobileShow(id, user) ;			/*\u79fb\u52a8\u7535\u8bdd*/

String email = Util.toScreen(RecordSet.getString("email"),user.getLanguage()) ;				/*\u7535\u90ae*/

String resourceimageid = Util.getFileidOut(RecordSet.getString("resourceimageid")) ;	/*\u7167\u7247id \u7531SequenceIndex\u8868\u5f97\u5230\uff0c\u548c\u4f7f\u7528\u5b83\u7684\u8868\u76f8\u5173\u8054*/
String managerid = Util.toScreen(RecordSet.getString("managerid"),user.getLanguage()) ;			/*\u76f4\u63a5\u4e0a\u7ea7*/
managerid=Util.toScreen(ResourceComInfo.getResourcename(managerid),user.getLanguage());
if("".equals(lastname)||null==lastname)
{
	String sql = "select * from HrmResourceManager where id="+id;	
	RecordSet.execute(sql);
	RecordSet.next();
	lastname = Util.toScreen(RecordSet.getString("lastname"),user.getLanguage()) ;
	sex = "Mr.";
}
if("".equals(workcode))
{
	workcode = ",";
}
if("".equals(lastname))
{
	lastname = ",";
}
if("".equals(sex))
{
	sex = ",";
}
if("".equals(mobile))
{
	mobile = ",";
}
if("".equals(telephone))
{
	telephone = ",";
}
if("".equals(email))
{
	email = ",";
}
if("".equals(departmentid))
{
	departmentid = ",";
}
if("".equals(subcompanyid1))
{
	subcompanyid1 = ",";
}
if("".equals(jobtitle))
{
	jobtitle = ",";
}
if("".equals(status))
{
	status = ",";
}
if("".equals(locationid))
{
	locationid = ",";
}
if("".equals(jobactivitydesc))
{
	jobactivitydesc = ",";
}

String messager = "";
if((PluginUserCheck.getPluginAllUserId("messager").indexOf(id)!=-1)&&Util.getIntValue(id)!=user.getUID()){
	//messager = "messager";
}

if(managerid.length()==0){
	managerid = ",";
}

if(resourceimageid.length()==0) {
	resourceimageid = ",";
}

//System.out.println("resourceimageid : "+resourceimageid);
out.print("$$$ip="+ip+"$$$"+lastname+"$$$"+sex+"$$$"+mobile+"$$$"+telephone+"$$$"+email+"$$$"+departmentid+"$$$"+managerid+"$$$imageid="+resourceimageid+"$$$"+subcompanyid1+"$$$"+jobtitle+"$$$"+status+"$$$"+locationid+"$$$"+workcode);

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/resource/simpleHrmResourceTemp.jsp"), -2335071812416095242L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}