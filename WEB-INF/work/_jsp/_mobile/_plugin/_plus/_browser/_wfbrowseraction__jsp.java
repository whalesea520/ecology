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
import weaver.general.*;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import weaver.conn.RecordSet;
import java.lang.reflect.Method;
import weaver.wxinterface.FormatMultiLang;
import weaver.wxinterface.WxInterfaceInit;

public class _wfbrowseraction__jsp extends com.caucho.jsp.JavaPage
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

      out.write(_jsp_string1, 0, _jsp_string1.length);
      
//\u5224\u65ad\u7f16\u7801
if(WxInterfaceInit.isIsutf8()){
	response.setContentType("application/json;charset=UTF-8");
}
String action = Util.null2String(request.getParameter("action"));
JSONObject json = new JSONObject();
int status = 1;String msg = "";
try{
	BaseBean bb = new BaseBean();
	if("getTreeData".equals(action)){
		RecordSet rs = new RecordSet();
		int type = Util.getIntValue(request.getParameter("type"),1);//1.\u67e5\u8be2\u6d41\u7a0b\u7c7b\u578b 2.\u67e5\u8be2\u7c7b\u578b\u4e0b\u7684\u6d41\u7a0b
		String setting = Util.null2String(request.getParameter("setting"));
		String listtypes = Util.null2String(request.getParameter("listtypes"));
		JSONArray js = new JSONArray();
		if(type==1){
			List<Integer> ftypeList = new ArrayList<Integer>();
			if(!"".equals(setting)||!"".equals(listtypes)){//\u83b7\u53d6\u6a21\u5757\u8bbe\u7f6e\u4e2d\u9009\u62e9\u7684\u5de5\u4f5c\u6d41\u7684\u6240\u6709\u7c7b\u578b
				String sql = "select workflowtype from workflow_base where 1=1 ";
				if(!"".equals(setting)){
					String settings = "";
					try{			
						Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
						Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
						settings = (String)m.invoke(WorkflowVersion, setting);
					}catch (Exception e){
						settings = setting;
					}
					if(!"".equals(settings)){
						sql+=" and id in ("+settings+")";
					}
				}
				if(!"".equals(listtypes)){
					String listtypess = "";
					try{			
						Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
						Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
						listtypess = (String)m.invoke(WorkflowVersion, listtypes);
					}catch (Exception e){
						listtypess = listtypes;
					}
					if(!"".equals(listtypess)){
						sql+=" and id in ("+listtypess+")";
					}
				}
				rs.executeSql(sql);
				while(rs.next()){
					int workflowtype = Util.getIntValue(rs.getString("workflowtype"),0);
					if(!ftypeList.contains(workflowtype)){
						ftypeList.add(workflowtype);
					}
				}
			}
			rs.executeSql("select id,typename from workflow_type order by dsporder");
			while(rs.next()){
				int id = Util.getIntValue(rs.getString("id"),0);
				if(ftypeList.size()<=0||ftypeList.contains(id)){
					String name = Util.null2String(rs.getString("typename"));
					JSONObject j = new JSONObject();
					j.put("id", id);
			        j.put("name", FormatMultiLang.formatByUserid(name,user.getUID()+""));
			        j.put("hasChild", true);
			        j.put("type", "2");
			        js.add(j);
				}
			}
		}else{
			String pid = Util.null2String(request.getParameter("pid"));
			String sql = "select id,workflowname from workflow_base where (isvalid='1' or isvalid='2') and workflowtype = "+pid;
			if(!"".equals(setting)){
				String settings = "";
				try{			
					Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
					Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
					settings = (String)m.invoke(WorkflowVersion, setting);
				}catch (Exception e){
					settings = setting;
				}
				if(!"".equals(settings)){
					sql+=" and id in ("+settings+")";
				}
			}
			if(!"".equals(listtypes)){
				String listtypess = "";
				try{			
					Class WorkflowVersion = Class.forName("weaver.workflow.workflow.WorkflowVersion");
					Method m = WorkflowVersion.getMethod("getAllVersionStringByWFIDs", String.class); 
					listtypess = (String)m.invoke(WorkflowVersion, listtypes);
				}catch (Exception e){
					listtypess = listtypes;
				}
				if(!"".equals(listtypess)){
					sql+=" and id in ("+listtypess+")";
				}
			}
			sql+=" order by workflowname";
			//System.out.println(sql);
			//bb.writeLog("\n\n\n==============="+sql+"==============\n\n\n");
			rs.executeSql(sql);
			while(rs.next()){
				JSONObject j = new JSONObject();
				j.put("id", rs.getString("id"));	//id
				j.put("name", FormatMultiLang.formatByUserid(rs.getString("workflowname"),user.getUID()+""));//\u540d\u79f0
				j.put("hasChild", false);
			    j.put("type", "3");
			    js.add(j);
			}
		}
		json.put("datas", js);
		status = 0;
	}else if("getSelectedDatas".equals(action)){
		String selectedIds = Util.null2String(request.getParameter("selectedIds"));
		JSONArray selectedArr = new JSONArray();
		if(!selectedIds.trim().equals("")){
			RecordSet rs = new RecordSet();
			rs.executeSql("select id,workflowname from workflow_base where id in ("+selectedIds+") order by workflowname");
			while(rs.next()){
				JSONObject selectedObj = new JSONObject();
				selectedObj.put("id", rs.getString("id"));	//id
				selectedObj.put("name", FormatMultiLang.formatByUserid(rs.getString("workflowname"),user.getUID()+""));//\u540d\u79f0
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("mobile/plugin/plus/browser/wfBrowserAction.jsp"), 397930191412170770L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}
