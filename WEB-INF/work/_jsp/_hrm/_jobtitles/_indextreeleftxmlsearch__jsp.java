/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._jobtitles;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;
import weaver.general.Util;
import net.sf.json.*;
import weaver.common.util.xtree.TreeNode;
import java.util.Map;
import java.util.HashMap;
import java.net.URLDecoder;
import weaver.common.util.string.StringUtil;
import weaver.docs.category.MultiCategoryTree;
import weaver.docs.category.security.MultiAclManager;

public class _indextreeleftxmlsearch__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  private boolean hasChild(String id, String cmd) throws Exception {
  	boolean hasChild = false;
  	if(cmd.equals("jobgroup")){
  		weaver.hrm.job.JobActivitiesComInfo JobActivitiesComInfo = new weaver.hrm.job.JobActivitiesComInfo();
  		JobActivitiesComInfo.setTofirstRow();
  		while(JobActivitiesComInfo.next()){
  			if(JobActivitiesComInfo.getJobgroupid().equals(id)){
  				hasChild = true;
  				break;
  			}
  		}
  	}else if(cmd.equals("jobactivites")){
  		weaver.hrm.job.JobTitlesComInfo JobTitlesComInfo = new weaver.hrm.job.JobTitlesComInfo();
  		JobTitlesComInfo.setTofirstRow();
  		while(JobTitlesComInfo.next()){
  			if(JobTitlesComInfo.getJobactivityid().equals(id)){
  				hasChild = true;
  				break;
  			}
  		}
  	}
  	return hasChild;
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
      weaver.hrm.job.JobGroupsComInfo JobGroupsComInfo;
      JobGroupsComInfo = (weaver.hrm.job.JobGroupsComInfo) pageContext.getAttribute("JobGroupsComInfo");
      if (JobGroupsComInfo == null) {
        JobGroupsComInfo = new weaver.hrm.job.JobGroupsComInfo();
        pageContext.setAttribute("JobGroupsComInfo", JobGroupsComInfo);
      }
      weaver.hrm.job.JobActivitiesComInfo JobActivitiesComInfo;
      JobActivitiesComInfo = (weaver.hrm.job.JobActivitiesComInfo) pageContext.getAttribute("JobActivitiesComInfo");
      if (JobActivitiesComInfo == null) {
        JobActivitiesComInfo = new weaver.hrm.job.JobActivitiesComInfo();
        pageContext.setAttribute("JobActivitiesComInfo", JobActivitiesComInfo);
      }
      weaver.hrm.job.JobTitlesComInfo JobTitlesComInfo;
      JobTitlesComInfo = (weaver.hrm.job.JobTitlesComInfo) pageContext.getAttribute("JobTitlesComInfo");
      if (JobTitlesComInfo == null) {
        JobTitlesComInfo = new weaver.hrm.job.JobTitlesComInfo();
        pageContext.setAttribute("JobTitlesComInfo", JobTitlesComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;

String condition=Util.null2String(request.getParameter("condition"));

condition = condition==null?"":URLDecoder.decode(condition,"UTF-8");


      out.write(_jsp_string2, 0, _jsp_string2.length);
      
TreeNode envelope=new TreeNode();
envelope.setTitle("envelope");

StringBuffer treeStr = new StringBuffer();
JSONArray jObject = null;

//\u7b2c\u4e09\u7ea7
Map tree3 = new HashMap();
JobTitlesComInfo.setTofirstRow();
while(JobTitlesComInfo.next()){
	treeStr = new StringBuffer();
	
	String name=JobTitlesComInfo.getJobTitlesmark();
	String id = JobTitlesComInfo.getJobTitlesid();
	String jobactivityid = JobTitlesComInfo.getJobactivityid();
	
	if(!name.contains(condition)){
		continue;
	}
	
	tree3.put(jobactivityid,jobactivityid);
	TreeNode node=new TreeNode();
	node.setTitle(name);
	node.setValue(id);
	node.setNodeId("jobtitlestemplet_"+id);
	node.setHref("javascript:onClickJobGroup(" + id + ")");
	node.setTarget("_self");
	//envelope.addTreeNode(node);
}

//\u7b2c\u4e8c\u7ea7
Map tree2 = new HashMap();
JobActivitiesComInfo.setTofirstRow();

while(JobActivitiesComInfo.next()){
	treeStr = new StringBuffer();
		
   String curgroupid = JobActivitiesComInfo.getJobgroupid();
       
	String name=JobActivitiesComInfo.getJobActivitiesname();
	String id = JobActivitiesComInfo.getJobActivitiesid();
	String jobgroupid = JobActivitiesComInfo.getJobgroupid();
	
	if(!name.contains(condition)){
		if(tree3.get(id) == null){
				continue;
		}
	}
	
	tree2.put(jobgroupid,jobgroupid);
	TreeNode node=new TreeNode();
	node.setTitle(name);
	node.setValue(id);
	node.setNodeId("jobactivities_"+id);
	node.setHref("javascript:onClickJobGroup(" + id + ")");
	node.setTarget("_self");
  	if (hasChild(id, "jobactivites")) {
  		node.setNodeXmlSrc("indexTreeLeftXML.jsp?jobactivite=" + id);
   }
	//envelope.addTreeNode(node);
}

Map tree1 = new HashMap();
JobGroupsComInfo.setTofirstRow();
while(JobGroupsComInfo.next()){
	String name=JobGroupsComInfo.getJobGroupsname();
	String id = JobGroupsComInfo.getJobGroupsid();
	
	if(!name.contains(condition)){
		if(tree2.get(id) == null){
				continue;
		}
	}
	
	tree1.put(id,id);
	TreeNode node=new TreeNode();
	node.setTitle(name);
	node.setValue(id);
	node.setNodeId("jobgroup_"+id);
	node.setHref("javascript:onClickJobGroup(" + id + ")");
	node.setTarget("_self");
	 	if (hasChild(id, "jobgroup")) {
	 		node.setNodeXmlSrc("indexTreeLeftXML.jsp?jobgroup=" + id);
	  }
	envelope.addTreeNode(node);
}

weaver.common.util.string.StringUtil.parseXml(out, envelope);

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/jobtitles/indexTreeLeftXMLSearch.jsp"), -416278973796754226L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n".toCharArray();
  }
}