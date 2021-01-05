/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._homepage._element._setting;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.conn.RecordSet;
import weaver.conn.RecordSetTrans;
import oracle.sql.CLOB;
import java.io.Writer;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class _workflowcenteropration__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

   
  	public void submitTabInfo(Hashtable hasParam,RecordSet rs){
  		int eid = Util.getIntValue((String)hasParam.get("eid"));
  		int viewType =Util.getIntValue((String)hasParam.get("viewType"));
  		String typeids = (String)hasParam.get("typeids");
  		String flowids = (String)hasParam.get("flowids");
  		String nodeids = (String)hasParam.get("nodeids"); 
  		int isExclude = Util.getIntValue((String)hasParam.get("isExclude")); 
  		String tabTitle = (String)hasParam.get("tabTitle");
  		String tabId = (String)hasParam.get("tabId");
  		String showCopy = (String)hasParam.get("showCopy");
  		String countFlag = Util.null2o((String)hasParam.get("countFlag"));
  		int completeflag = Util.getIntValue((String)hasParam.get("completeflag"),0);
  		rs.executeSql("select count(*) from hpsetting_wfcenter where eid="+eid+" and tabId='"+tabId+"'");
  		rs.next();
  		
  		RecordSetTrans recordSetTrans = new RecordSetTrans();
  	
  		recordSetTrans.setAutoCommit(false);
  		try{
  		
  			if(rs.getInt(1)==0){
  				String strSqlIn = "insert into hpsetting_wfcenter (eid,viewType,isExclude,tabId,tabTitle,showCopy,countflag,completeflag) values(?,?,?,?,?,?,?,?) ";
  				//System.out.println("strSqlIn==="+strSqlIn);
  				recordSetTrans.executeUpdate(strSqlIn,new Object[]{eid,viewType,isExclude,tabId,tabTitle,showCopy,countFlag,completeflag});
  				recordSetTrans.executeSql("select id from hpsetting_wfcenter where eid="+eid+" and tabId='"+tabId+"'");
  				recordSetTrans.next();
  				String maxid = recordSetTrans.getString("id");
  				insertWorkflowCenterSettingDetail(eid,tabId,"typeid",Util.TokenizerString(typeids,","),maxid,recordSetTrans);
  				weaver.workflow.workflow.WorkflowVersion WorkflowVersion = new weaver.workflow.workflow.WorkflowVersion();
  				flowids = WorkflowVersion.getAllVersionStringByWFIDs(flowids);
  				insertWorkflowCenterSettingDetail(eid,tabId,"flowid",Util.TokenizerString(flowids,","),maxid,recordSetTrans);
  				nodeids = WorkflowVersion.getAllRelationNodeStringByNodeIDs(nodeids);
  				insertWorkflowCenterSettingDetail(eid,tabId,"nodeid",Util.TokenizerString(nodeids,","),maxid,recordSetTrans);
  				recordSetTrans.commit();
  				
  			}else{
  				
  				String strSql="update hpsetting_wfcenter set viewType=?,isExclude=?, tabTitle=?, showCopy=?,countflag=?,completeflag=? where eid=? and tabId =?";
  				//System.out.println("strSql==="+strSql);
  				recordSetTrans.executeUpdate(strSql,new Object[]{viewType,isExclude,tabTitle,showCopy,countFlag,completeflag,eid,tabId});
  				recordSetTrans.executeSql("select id from hpsetting_wfcenter  where eid="+eid+" and tabId='"+tabId+"'");
  				recordSetTrans.next();
  				String maxid = recordSetTrans.getString("id");
  				
  				strSql = "delete from workflowcentersettingdetail where eid='"+eid+"' and tabid='"+tabId+"'";
  				recordSetTrans.executeSql(strSql);
  				
  				insertWorkflowCenterSettingDetail(eid,tabId,"typeid",Util.TokenizerString(typeids,","),maxid,recordSetTrans);
  				weaver.workflow.workflow.WorkflowVersion WorkflowVersion = new weaver.workflow.workflow.WorkflowVersion();
  				flowids = WorkflowVersion.getAllVersionStringByWFIDs(flowids);
  				insertWorkflowCenterSettingDetail(eid,tabId,"flowid",Util.TokenizerString(flowids,","),maxid,recordSetTrans);
  				nodeids = WorkflowVersion.getAllRelationNodeStringByNodeIDs(nodeids);
  				insertWorkflowCenterSettingDetail(eid,tabId,"nodeid",Util.TokenizerString(nodeids,","),maxid,recordSetTrans);
  				recordSetTrans.commit();
  			}
  			insertSywfexinfo(eid,tabId,rs);
  		}catch(Exception ex){
  			ex.printStackTrace();
  			recordSetTrans.rollback();
  		}
  		
  	}
  
  	public void insertWorkflowCenterSettingDetail(int eid,String tabid,String type,ArrayList contentList,String srcfrom,RecordSetTrans recordSetTrans) throws Exception{
  		
  		for(int i=0;i<contentList.size();i++){
  			String content = (String)contentList.get(i);
  			
  			String sql = "insert into workflowcentersettingdetail (eid,tabid,type,content,srcfrom) values('"+eid+"','"+tabid+"','"+type+"','"+content+"','"+srcfrom+"')";
  			recordSetTrans.executeSql(sql);
  		}
  	}
  	
  	public void insertSywfexinfo(int eid,String tabid,RecordSet rs){
  		rs.executeSql("select id from hpsetting_wfcenter where eid = '"+eid+"' and tabid = '"+tabid+"'");
  		if(rs.next()){
  		   RecordSet res = new RecordSet();
  		   //System.out.println("update sywfexinfo set  sourceid = '"+rs.getString("id")+"' where wfexid like '"+eid+"-"+tabid+"-"+"%'");
  		   res.executeSql("update sywfexinfo set  sourceid = '"+rs.getString("id")+"' where wfexid like '"+eid+"-"+tabid+"-"+"%'");
  		}
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
      
	
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
int eid=Util.getIntValue(request.getParameter("eid"));
int viewType=Util.getIntValue(request.getParameter("viewType"));
String typeids=Util.null2String(request.getParameter("typeids"));
String flowids=Util.null2String(request.getParameter("flowids"));
String nodeids=Util.null2String(request.getParameter("nodeids"));
String tabTitle = Util.null2String(request.getParameter("tabTitle"));
String wfids=Util.null2String(request.getParameter("wfids"));
String tabId = Util.null2String(request.getParameter("tabId"));
String method = Util.null2String(request.getParameter("method"));
int isExclude=Util.getIntValue(request.getParameter("isExclude"),0);
String showCopy = Util.null2String(request.getParameter("showCopy"));
String countFlag = Util.null2o(request.getParameter("countFlag"));
String completeflag = Util.null2String(request.getParameter("completeflag"));
String orders = Util.null2String(request.getParameter("orders"));

if(showCopy.equals("")){
	showCopy = "0";
}
Hashtable tabAddList =null;
ArrayList tabRemoveList = null;


if(session.getAttribute(eid+"_Add")!=null){
	tabAddList = (Hashtable)session.getAttribute(eid+"_Add");
}else{
	tabAddList = new Hashtable();
	
}


if(session.getAttribute(eid+"_Remove")!=null){
	
	tabRemoveList = (ArrayList)session.getAttribute(eid+"_Remove");
}else{
	tabRemoveList = new ArrayList();
}

if(method.equals("add")||method.equals("edit")){
	Hashtable hasTabParam = new Hashtable();	
	hasTabParam.put("eid",eid+"");
	hasTabParam.put("viewType",viewType+"");
	hasTabParam.put("typeids",typeids);
	weaver.workflow.workflow.WorkflowVersion WorkflowVersion = new weaver.workflow.workflow.WorkflowVersion();
	flowids = WorkflowVersion.getAllVersionStringByWFIDs(flowids);
	hasTabParam.put("flowids",flowids);
	hasTabParam.put("nodeids",nodeids);
	hasTabParam.put("isExclude",isExclude+"");
	hasTabParam.put("tabTitle",tabTitle);
	hasTabParam.put("tabId",tabId);
	hasTabParam.put("showCopy",showCopy);
	hasTabParam.put("countFlag",countFlag);
	hasTabParam.put("completeflag",completeflag);
	hasTabParam.put("wfids",wfids);
	tabAddList.put(tabId,hasTabParam);
	session.setAttribute(eid+"_Add",tabAddList);
}else if(method.equals("delete")){
	String[] tabArr = tabId.split(";");
	for(String tmpS : tabArr){
		if(tabAddList.containsKey(tmpS)){
			tabAddList.remove(tmpS);	
		}
		tabRemoveList.add(tmpS);
		session.setAttribute(eid+"_Remove",tabRemoveList);
	}
}else if(method.equals("submit")){
	Enumeration e = tabAddList.elements();
	
//	Hashtable orderMap = new Hashtable();
	while(e.hasMoreElements()){ 
		Hashtable hasParam = (Hashtable)e.nextElement();
	//	hasParam.put("orderNum",orderMap.get(hasParam.get("tabId")));
		submitTabInfo(hasParam,rs);
	} 
	//\u66f4\u65b0\u9875\u7b7e\u5e8f\u53f7\uff0c\u5982\u679c\u9875\u9762\u9875\u7b7e\u4ec5\u6709\u62d6\u62fd\u66f4\u6539\uff0c\u5219\u9700\u4e13\u95e8\u66f4\u65b0\uff0c\u6b64\u5904\u4e13\u95e8\u66f4\u65b0\u884c\u5e8f
	if(orders != null && !"".equals(orders)){
		String strSql="update hpsetting_wfcenter set orderNum=? where eid=? and tabId =?";
		RecordSetTrans recordSetTrans = new RecordSetTrans();
		String[] arr = orders.split(";");
		for(String str : arr){
			String[] tmp = str.split("_");
			recordSetTrans.executeUpdate(strSql,new Object[]{tmp[1],eid,tmp[0]});
		}
		recordSetTrans.commit();
	}
	
	for(int i=0;i<tabRemoveList.size();i++){

		rs.execute("delete from hpsetting_wfcenter where eid="+eid+" and tabId='"+tabRemoveList.get(i)+"'");
		rs.execute("delete from workflowcentersettingdetail where eid="+eid+" and tabId='"+tabRemoveList.get(i)+"'");
	}
	session.removeAttribute(eid+"_Add");
	session.removeAttribute(eid+"_Remove");
	session.removeAttribute(eid+"_Edit");
}else if(method.equals("cancel")){
	session.removeAttribute(eid+"_Add");
	session.removeAttribute(eid+"_Remove");
}




      out.write(_jsp_string1, 0, _jsp_string1.length);
      


//strSql="update hpelement set strsqlwhere='"+viewType+"' where id="+eid;
//rs.executeSql(strSql);

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("homepage/element/setting/WorkflowCenterOpration.jsp"), -7660398381318649041L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string2 = "\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n\r\n".toCharArray();
  }
}