/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._multiprint;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.general.BaseBean;
import java.util.*;
import net.sf.json.*;
import weaver.conn.RecordSet;
import weaver.hrm.*;

public class _multiprintgroups__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
      /**
      * \u6839\u636e\u6d41\u7a0bid\uff0c\u8282\u70b9id\u83b7\u53d6\u5f53\u524d\u9875\u9762\u7684\u6253\u5370\u65b9\u5f0f\uff0c\u4ec5\u9650\u4e8e\u6a21\u677f\u6a21\u5f0f
      */
  	private int getModeid(String workflowid,String nodeid){
  		int isbill = 0;
  		int modeid=0;
  		int printdes=0;
  		String formid = "";
  		String ismode="";
  		String sql = "select * from workflow_base where id="+workflowid;
  		RecordSet rs = new RecordSet();
  		rs.executeSql(sql);
  		if(rs.next()){
  			isbill = Util.getIntValue(rs.getString("isbill"), 0);
  			formid = Util.null2String(rs.getString("formid"));
  		}
  		
  		sql = "select ismode,printdes,toexcel from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid;
  		rs.executeSql(sql);
  		if(rs.next()){
  			ismode=Util.null2String(rs.getString("ismode"));
  			printdes=Util.getIntValue(Util.null2String(rs.getString("printdes")),0);
  		}
  		if(printdes != 1){
  			sql = "select id from workflow_nodemode where isprint='1' and workflowid="+workflowid+" and nodeid="+nodeid;
  			rs.executeSql(sql);
  			if(rs.next()){
  				modeid=rs.getInt("id");
  			}else{
  				sql = "select id from workflow_formmode where formid="+formid+" and isbill='"+isbill+"' order by isprint desc";
  				rs.executeSql(sql);
  				while(rs.next()){
  					if(modeid < 1){
  						modeid = rs.getInt("id");
  					}
  				}
  			}
  		}
  		return modeid;
  	}
  
  	private int getHtmlModeid(String workflowid,String nodeid){
  		String sql = " select id from workflow_nodehtmllayout "
  				   + " where isactive=1 and workflowid = " + workflowid + " and nodeid = " + nodeid + " and type = '1'";
  		RecordSet rs = new RecordSet();
  		int modeid = -1;
  		rs.executeSql(sql);
  		if(rs.next()){
  			modeid = rs.getInt("id");
  		}
  		return modeid;
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
      weaver.workflow.request.WFLinkInfo WFLinkInfo;
      WFLinkInfo = (weaver.workflow.request.WFLinkInfo) pageContext.getAttribute("WFLinkInfo");
      if (WFLinkInfo == null) {
        WFLinkInfo = new weaver.workflow.request.WFLinkInfo();
        pageContext.setAttribute("WFLinkInfo", WFLinkInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet recordSet;
      recordSet = (weaver.conn.RecordSet) pageContext.getAttribute("recordSet");
      if (recordSet == null) {
        recordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("recordSet", recordSet);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      

	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	User user = HrmUserVarify.getUser (request , response) ;
	String multirequestid = Util.null2String(request.getParameter("multirequestid"));
	List<String> modeList = new ArrayList<String>();  //\u6a21\u677f\u6a21\u5f0f
	//List<String> reqList = new ArrayList<String>();   //html\u6a21\u5f0f
	Map<String,String> reqMap = new HashMap<String,String>();  //html\u6a21\u5f0f
	
	Map result = new HashMap();
	if(!"".equals(multirequestid)){
		multirequestid = multirequestid + "0";
		String sql = "select requestid,workflowid from workflow_requestbase where requestid in (" + multirequestid + ")";
		recordSet.executeSql(sql);
		int userid = user.getUID();
		int logintype = Util.getIntValue(user.getLogintype(),1);
		
		while(recordSet.next()){
			String workflowid = recordSet.getString("workflowid");
			int reqid = recordSet.getInt("requestid");
			int nodeid = WFLinkInfo.getCurrentNodeid(reqid,userid,logintype);    //\u5f53\u524d\u4eba\u5458\u6700\u540e\u64cd\u4f5c\u7684\u8282\u70b9
			int modeid = getModeid(workflowid,nodeid+"");   //\u53d6\u6a21\u677f\u6a21\u5f0f\u7684\u6253\u5370\u6a21\u677fid
			if(modeid > 0){
				modeList.add(reqid + "");
			}else{
				modeid = getHtmlModeid(workflowid,nodeid+"");    //\u53d6html\u6a21\u5f0f\u7684\u6253\u5370\u6a21\u677fid
				if(modeid > 0){
					String groupid = workflowid + "-" + nodeid;
					if(reqMap.containsKey(groupid)){
						String reqids = reqMap.get(groupid);
						reqids += reqid + ",";
						reqMap.put(groupid,reqids);
					}else{
						reqMap.put(groupid,reqid+",");
					}
					//reqList.add(reqid + "");
				}
			}
		}	
		
		int msize = modeList.size();
		String htmlreqids = "";
		String modereqids = "";
		for(int i = 0; i < msize; i++){
			modereqids += modeList.get(i) + ",";
		}
		
		if(msize > 0){
			result.put("modereqids",modereqids);
		}
		
		if(!reqMap.isEmpty()){   //html\u6a21\u5f0f\u6253\u5370
			result.put("htmlreqids",reqMap);
		}
		JSONObject jsobject = JSONObject.fromObject(result);
		out.print(jsobject.toString());
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/multiprint/MultiPrintGroups.jsp"), -2905582376529564271L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string2 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}
