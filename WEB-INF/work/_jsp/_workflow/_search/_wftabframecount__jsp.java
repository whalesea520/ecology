/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._search;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.general.*;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;

public class _wftabframecount__jsp extends com.caucho.jsp.JavaPage
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
      weaver.workflow.request.todo.RequestUtil requestutil;
      requestutil = (weaver.workflow.request.todo.RequestUtil) pageContext.getAttribute("requestutil");
      if (requestutil == null) {
        requestutil = new weaver.workflow.request.todo.RequestUtil();
        pageContext.setAttribute("requestutil", requestutil);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      

String workflowid = Util.null2String(request.getParameter("workflowid"));
String typeid = Util.null2String(request.getParameter("typeid"));
String offical = Util.null2String(request.getParameter("offical"));
int officalType = Util.getIntValue(request.getParameter("officalType"));

String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//\u9700\u8981\u589e\u52a0\u7684\u4ee3\u7801
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//\u9700\u8981\u589e\u52a0\u7684\u4ee3\u7801
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//\u9700\u8981\u589e\u52a0\u7684\u4ee3\u7801
if (user == null ) return ;
List countArr = new ArrayList();
countArr.add("flowAll");
countArr.add("flowNew");
countArr.add("flowResponse");
countArr.add("flowOut");
countArr.add("flowSup");

if(typeid.equals("")&&workflowid.equals("") && !offical.equals("1")){
	//\u5f00\u59cb\u8fdb\u5165
String userID = String.valueOf(user.getUID());
String userIDAll = String.valueOf(user.getUID());
int userid=user.getUID();
String belongtoshow = "";				
								RecordSet.executeSql("select * from HrmUserSetting where resourceId = "+userID);
								if(RecordSet.next()){
									belongtoshow = RecordSet.getString("belongtoshow");
								}
String Belongtoids =user.getBelongtoids();
int Belongtoid=0;
String[] arr2 = null;
ArrayList<String> userlist = new ArrayList();
userlist.add(userid + "");
if(!"".equals(Belongtoids)){
userIDAll = userID+","+Belongtoids;
arr2 = Belongtoids.split(",");
for(int i=0;i<arr2.length;i++){
Belongtoid = Util.getIntValue(arr2[i]);
userlist.add(Belongtoid + "");
}
}



	String logintype = ""+user.getLogintype();
	int usertype = 0;

	String resourceid= ""+Util.null2String((String) session.getAttribute("RequestViewResource"));
	//QC235172,\u5982\u679c\u4e0d\u662f\u67e5\u770b\u81ea\u5df1\u7684\u4ee3\u529e\uff0c\u4e3b\u4ece\u8d26\u53f7\u7edf\u4e00\u663e\u793a\u4e0d\u9700\u8981\u5224\u65ad
	if(!"".equals(resourceid) && !(""+user.getUID()).equals(resourceid)) belongtoshow = "";
	
	if(resourceid.equals("")) {
		resourceid = ""+user.getUID();
		if(logintype.equals("2")) usertype= 1;
			session.removeAttribute("RequestViewResource") ;
		}
	else {
		session.setAttribute("RequestViewResource",resourceid) ;
	}

	
	
	String CurrentUser = Util.null2String((String) request.getSession().getAttribute("RequestViewResource"));
	if (logintype.equals("2"))
		usertype = 1;
	if (CurrentUser.equals("")) {
		CurrentUser = "" + user.getUID();
	}
	boolean superior = false; //\u662f\u5426\u4e3a\u88ab\u67e5\u770b\u8005\u4e0a\u7ea7\u6216\u8005\u672c\u8eab
	if ((user.getUID() + "").equals(CurrentUser)) {
		superior = true;
	} else {
		RecordSet.executeSql("SELECT * FROM HrmResource WHERE ID = " + CurrentUser + " AND managerStr LIKE '%," + user.getUID() + ",%'");

		if (RecordSet.next()) {
			superior = true;
		}
	}
	
	if (superior)
		CurrentUser = user.getUID() + "";
	
	
	//System.out.println("superior=" + superior);
	
	int  flowNew = 0;
	int flowResponse = 0;
	int flowOut = 0;
	int flowSup = 0;
	int flowAll = 0;
	for(int a=0;a<countArr.size();a++)
	{
	    StringBuffer sqlsb = new StringBuffer();
		if("1".equals(belongtoshow)){
		sqlsb.append("select count(a.requestid) wfCount ");
		}else{
		sqlsb.append("select count(distinct a.requestid) wfCount ");
		}
		sqlsb.append("	  from workflow_currentoperator a, workflow_base wb ");
		if(countArr.get(a).equals("flowOut")){
			sqlsb.append("	  where (((isremark='0' and (takisremark is null or takisremark=0 )) and isprocessed <> '1' ) or isremark = '5') ");
		}else if(countArr.get(a).equals("flowNew")){
			sqlsb.append("	  where (((isremark='0' and (takisremark is null or takisremark=0 )) and (isprocessed is null or (isprocessed <> '2' and isprocessed <> '3'))) or isremark in('1','5','8','9','7')) ");
		}else if(countArr.get(a).equals("flowSup") || countArr.get(a).equals("flowResponse")){
			sqlsb.append("    where (((isremark='0' and (takisremark is null or takisremark=0 )) or isremark in('1','5','8','9','7'))  or (isremark = '0' and isprocessed is null))");
		}else{
			sqlsb.append("	  where ((isremark='0' and (takisremark is null or takisremark=0 )) or isremark in('1','5','8','9','7')) ");
		}
		sqlsb.append("	    and islasttimes = 1 ");
		if("1".equals(belongtoshow)){
		sqlsb.append("	    and a.userid in (").append(userIDAll);
		}else{
		sqlsb.append("	    and a.userid in (").append(resourceid);
		}
		sqlsb.append("	 )   and a.usertype = ").append(usertype);
		sqlsb.append("	    and exists (select c.requestid ");
		sqlsb.append("	           from workflow_requestbase c ");
		sqlsb.append("	          where (c.deleted <> 1 or c.deleted is null or c.deleted='') and c.requestid = a.requestid");
		
		
		sqlsb.append(" and a.workflowid=wb.id ");
		sqlsb.append(" and wb.isvalid in (1, 3) ");
		if(RecordSet.getDBType().equals("oracle"))
		{
			sqlsb.append(" and (nvl(c.currentstatus,-1) = -1 or (nvl(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
		else
		{
			sqlsb.append(" and (isnull(c.currentstatus,-1) = -1 or (isnull(c.currentstatus,-1)=0 and c.creater="+user.getUID()+")) ");
		}
		sqlsb.append(")");
	    //SQL = "select a.viewtype, count(distinct a.requestid) workflowcount from workflow_currentoperator a  where   ((isremark='0' and (isprocessed is null or (isprocessed<>'2' and isprocessed<>'3'))) or isremark='1' or isremark='8' or isremark='9' or isremark='7') and islasttimes=1 and userid=" +  resourceid  + " and usertype= " + usertype +" and a.workflowtype="+tworkflowtype+" and a.workflowid="+tworkflowid+" and exists (select c.requestid from workflow_requestbase c where c.requestid=a.requestid) ";
	    
	    if(!superior)
		{
	    	sqlsb.append(" AND EXISTS (SELECT NULL FROM workFlow_CurrentOperator b WHERE a.workflowid = b.workflowid AND a.requestid = b.requestid AND b.userid=" + user.getUID() + " and b.usertype= " + usertype +") ");
		}
		
		if(offical.equals("1")){//\u53d1\u6587/\u6536\u6587/\u7b7e\u62a5
			if(officalType==1){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType in (1,3) and (isvalid=1 or isvalid=3))");
			}else if(officalType==2){
				sqlsb.append(" and workflowid in (select id from workflow_base where isWorkflowDoc=1 and officalType=2 and (isvalid=1 or isvalid=3))");
			}
		}
	    
	    //sqlsb.append(" group by a.viewtype, a.workflowtype, a.workflowid");
		String sql=sqlsb.toString();
			if(countArr.get(a).equals("flowNew"))
				sql += " and a.viewtype = '0' and a.isremark != '5' and a.isprocessed is null ";
			else if(countArr.get(a).equals("flowResponse"))
				sql += " and a.viewtype = '-1' ";
			//else if(countArr.get(a).equals("flowOut"))
				//sql += " and a.isremark = '5' ";
			else if(countArr.get(a).equals("flowSup"))
				sql += " and a.requestid in (select requestid from workflow_requestlog where logtype='s') ";
			else 
				sql +="";
			
		//System.out.println("SLQ:::::::+++>>>>"+sql);
		RecordSet.executeSql(sql);
		
		if(RecordSet.first()){
			//System.out.println(Util.getIntValue(RecordSet.getString("wfCount")));
			if(countArr.get(a).equals("flowNew"))
				flowNew = Util.getIntValue(RecordSet.getString("wfCount"));
			else if(countArr.get(a).equals("flowResponse"))
				flowResponse = Util.getIntValue(RecordSet.getString("wfCount"));
			else if(countArr.get(a).equals("flowOut"))
				flowOut = Util.getIntValue(RecordSet.getString("wfCount"));
			else if(countArr.get(a).equals("flowSup"))
				flowSup = Util.getIntValue(RecordSet.getString("wfCount"));
			else 
				flowAll = Util.getIntValue(RecordSet.getString("wfCount"));
		}
		
	}
	
	//\u52a0\u4e0a\u5f02\u6784\u7cfb\u7edf\u6570\u636e\u7684\u6570\u91cf
    if(requestutil.getOfsSetting().getIsuse()==1) {
        //\u5168\u90e8\u5f85\u529e
        RecordSet.executeSql("select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" and isremark='0' and islasttimes=1");
        if (RecordSet.next()) {
            flowAll += Util.getIntValue(RecordSet.getString(1), 0);
        }

        //\u672a\u67e5\u770b\u7684\u5f85\u529e
        RecordSet.executeSql("select COUNT(requestid) from ofs_todo_data where userid="+user.getUID()+" and isremark='0' and islasttimes=1 and viewtype=0 ");
        if (RecordSet.next()) {
            flowNew += Util.getIntValue(RecordSet.getString(1), 0);
        }
    }
	
	String data="{\"flowNew\":\""+flowNew+"\",\"flowResponse\":\""+flowResponse+"\",\"flowOut\":\""+flowOut+"\",\"flowSup\":\""+flowSup+"\",\"flowAll\":\""+flowAll+"\"}";
	
	response.getWriter().write(data);
	
}

      out.write(_jsp_string3, 0, _jsp_string3.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/search/wfTabFrameCount.jsp"), 912242293839095896L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  private final static char []_jsp_string3;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string3 = "\r\n\r\n".toCharArray();
  }
}