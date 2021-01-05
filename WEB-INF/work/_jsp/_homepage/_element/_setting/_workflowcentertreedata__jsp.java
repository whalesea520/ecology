/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._homepage._element._setting;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import org.json.*;
import weaver.general.Util;
import java.util.*;
import weaver.workflow.workflow.WorkTypeComInfo;

public class _workflowcentertreedata__jsp extends com.caucho.jsp.JavaPage
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
    response.setContentType("application/x-json;charset=UTF-8");
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
      weaver.conn.RecordSet rsIn;
      rsIn = (weaver.conn.RecordSet) pageContext.getAttribute("rsIn");
      if (rsIn == null) {
        rsIn = new weaver.conn.RecordSet();
        pageContext.setAttribute("rsIn", rsIn);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rsOfs;
      rsOfs = (weaver.conn.RecordSet) pageContext.getAttribute("rsOfs");
      if (rsOfs == null) {
        rsOfs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rsOfs", rsOfs);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
	int viewType = Util.getIntValue(request.getParameter("viewType")); //1:\u4e3a\u5f85\u529e\u4e8b\u5b9c
	int eid = Util.getIntValue(request.getParameter("eid"));
	String node = Util.null2String(request.getParameter("node"));
	String tabId = Util.null2String(request.getParameter("tabId"));
	if (tabId.equals("")) {
		tabId = "1";
	}
	String arrNode[] = Util.TokenizerString2(node, "_");
	String type = arrNode[0];
	String value = arrNode[1];

	//System.out.println(type);
	//System.out.println(value);

	String typeids = "";
	String flowids = "";
	String nodeids = "";
	ArrayList typeidList = new ArrayList();
	ArrayList flowidList = new ArrayList();
	ArrayList nodeidList = new ArrayList();
boolean isCurrentTab = true;//\u5224\u65ad\u5f53\u524d\u64cd\u4f5c\u7684Tab\u9875
if (session.getAttribute(eid + "_Add") != null) {
			Hashtable tabAddList = (Hashtable) session.getAttribute(eid+ "_Add");
			if (tabAddList.containsKey(tabId)) {
				Hashtable tabInfo = (Hashtable) tabAddList.get(tabId);
				typeids = Util.null2String((String) tabInfo.get("typeids"));
				flowids = Util.null2String((String) tabInfo.get("flowids"));
				nodeids = Util.null2String((String) tabInfo.get("nodeids"));
		
				typeidList = Util.TokenizerString(typeids, ",");
				flowidList = Util.TokenizerString(flowids, ",");
				nodeidList = Util.TokenizerString(nodeids, ",");
				isCurrentTab = false;
			}
}
if(isCurrentTab){
	Map tabEditMap = null;
	List tabEditList = null;
	if(session.getAttribute(eid +"_Edit") != null){
		if(((Map) session.getAttribute(eid +"_Edit")).get(tabId) != null){
			tabEditList = (List) ((Map) session.getAttribute(eid +"_Edit")).get(tabId);
		}else{
			tabEditMap = (Map) session.getAttribute(eid +"_Edit");
			tabEditList = new ArrayList();
			rs.executeSql("select type, content from workflowcentersettingdetail where eid=" + eid+ " and tabId='" + tabId + "'");
			while (rs.next()) {
				Map<String,Object> item = new HashMap<String,Object>();
				item.put("type", Util.null2String(rs.getString("type")));
				item.put("content", Util.null2String(rs.getString("content")));
				tabEditList.add(item);
			}
			tabEditMap.put(tabId,tabEditList);
			session.setAttribute(eid+ "_Edit",tabEditMap);
		}
	}else{
		tabEditMap = new HashMap();
		tabEditList = new ArrayList();
		rs.executeSql("select type, content from workflowcentersettingdetail where eid=" + eid+ " and tabId='" + tabId + "'");
		while (rs.next()) {
			Map<String,Object> item = new HashMap<String,Object>();
			item.put("type", Util.null2String(rs.getString("type")));
			item.put("content", Util.null2String(rs.getString("content")));
			tabEditList.add(item);
		}
		tabEditMap.put(tabId,tabEditList);
		session.setAttribute(eid+ "_Edit",tabEditMap);
	}
	if(tabEditList != null){
		String content="";
		String sType="";
		for(int i=0; i < tabEditList.size(); i++){
			Map<String,Object> item = (Map<String,Object>) tabEditList.get(i);
			sType = Util.null2String(item.get("type"));
			content = Util.null2String(item.get("content"));
			if("typeid".equals(sType)){
				typeidList.add(content);
			}
			if("flowid".equals(sType)){
				flowidList.add(content);
				flowids+=","+content;
			}
			if("nodeid".equals(sType)){
				nodeidList.add(content);
				nodeids+=","+content;
			}
		}
	}
	if(flowids.startsWith(",")){
		flowids = flowids.replaceFirst(",","");
	}
	if(nodeids.startsWith(",")){
		nodeids = nodeids.replaceFirst(",","");
	}
}

	
	
	
	
	
	JSONArray jsonArrayReturn = new JSONArray();
	
	if ("root".equals(type)) { //\u4e3b\u76ee\u5f55\u4e0b\u7684\u6570\u636e
		ArrayList rootExpandList=new ArrayList();
		if(!"".equals(nodeids)){
			rs.execute("select distinct t3.id from workflow_flownode t1, workflow_base t2,workflow_type t3 where t3.id=t2.workflowtype and t2.id = t1.workflowid and t1.nodeid in ("+nodeids+")");
			while(rs.next()){
				rootExpandList.add(rs.getString("id"));
			}
		}else if(!"".equals(flowids)){
			rs.execute("select distinct t3.id from  workflow_base t2,workflow_type t3 where t3.id=t2.workflowtype and t2.id  in ("+flowids+")");
			while(rs.next()){
				rootExpandList.add(rs.getString("id"));
			}
		}
		
		WorkTypeComInfo wftc = new WorkTypeComInfo();
		while (wftc.next()) {
			JSONObject jsonTypeObj = new JSONObject();
			String wfTypeId = wftc.getWorkTypeid();
			String wfTypeName = wftc.getWorkTypename();
			//if("1".equals(wfTypeId)) continue; 
			jsonTypeObj.put("id", "wftype_" + wfTypeId);
			jsonTypeObj.put("text", wfTypeName);
			if (!typeidList.contains(wfTypeId)) {
				jsonTypeObj.put("checked", false);
			} else {
				jsonTypeObj.put("checked", true);
				jsonTypeObj.put("expanded", true);
			}
			if(rootExpandList.contains(wfTypeId)){
				jsonTypeObj.put("expanded", true);
			}
			jsonTypeObj.put("draggable", false);
			jsonTypeObj.put("leaf", false);
			jsonArrayReturn.put(jsonTypeObj);
		}
		
		//\u7edf\u4e00\u5f85\u529e\u5f02\u6784\u7cfb\u7edf\u96c6\u6210\u53c2\u6570
		int isUse = 0;
		int showDone = 0;
		rsOfs.execute("select IsUse,ShowDone from ofs_setting");
		if(rsOfs.next()) {
			isUse = rsOfs.getInt("IsUse");
			showDone = rsOfs.getInt("ShowDone");
		}
		//\u662f\u5426\u663e\u793a\u5f02\u6784\u7cfb\u7edf
		boolean isShowOfs = false;
		if (1 == isUse) {
			if (1 == showDone && (viewType == 1 || viewType == 2 || viewType == 3 || viewType == 4)) {
			 	isShowOfs = true;
		 	} else if (viewType == 1 || viewType == 4) {
			 	isShowOfs = true;
		 	}
		}
		if (isShowOfs) {
			//\u7edf\u4e00\u5f85\u529e\u5f02\u6784\u7cfb\u7edf\u6d41\u7a0b\u7c7b\u578b
			rsOfs.execute("select sysid, SysShortName from Ofs_sysinfo");
			while(rsOfs.next()){
				JSONObject jsonTypeObj = new JSONObject();
				jsonTypeObj.put("id", "wftype_" + rsOfs.getString("sysid"));
				jsonTypeObj.put("text", rsOfs.getString("SysShortName"));
				if (!typeidList.contains(rsOfs.getString("sysid"))) {
					jsonTypeObj.put("checked", false);
				} else {
					jsonTypeObj.put("checked", true);
					jsonTypeObj.put("expanded", true);
				}
				if(rootExpandList.contains(rsOfs.getString("sysid"))){
					jsonTypeObj.put("expanded", true);
				}
				jsonTypeObj.put("draggable", false);
				jsonTypeObj.put("leaf", false);
				jsonArrayReturn.put(jsonTypeObj);
			}
		}
	} else if ("wftype".equals(type)) {
		ArrayList typeExpandList=new ArrayList();
		if(!"".equals(nodeids)){
			rs.execute("select distinct t2.id from workflow_flownode t1, workflow_base t2,workflow_type t3 where t2.workflowtype="+value+" and t2.id = t1.workflowid and t1.nodeid in ("+nodeids+")");
			while(rs.next()){
				typeExpandList.add(rs.getString("id"));
			}
		}
		rs.executeSql("select id,workflowname from workflow_base where isvalid='1' and workflowtype="+ value);

		while (rs.next()) {

			JSONObject jsonWfObj = new JSONObject();
			String wfId = Util.null2String(rs.getString("id"));
			String wfName = Util.null2String(rs.getString("workflowname"));
			jsonWfObj.put("id", "wf_" + wfId);
			jsonWfObj.put("text", wfName);
			jsonWfObj.put("draggable", false);

			if (!flowidList.contains(wfId)) {
				jsonWfObj.put("checked", false);
			} else {
				jsonWfObj.put("checked", true);
				jsonWfObj.put("expanded", true);
			}
			if(typeExpandList.contains(wfId)){
				jsonWfObj.put("expanded", true);
			}
			if (viewType == 1 || viewType == 2 || viewType == 4) {
				jsonWfObj.put("leaf", false);
			} else {
				jsonWfObj.put("leaf", true);
			}
			jsonArrayReturn.put(jsonWfObj);
		}
		
		//\u7edf\u4e00\u5f85\u529e\u5f02\u6784\u7cfb\u7edf\u96c6\u6210\u53c2\u6570
		int isUse = 0;
		int showDone = 0;
		rsOfs.execute("select IsUse,ShowDone from ofs_setting");
		if(rsOfs.next()) {
			isUse = rsOfs.getInt("IsUse");
			showDone = rsOfs.getInt("ShowDone");
		}
		//\u662f\u5426\u663e\u793a\u5f02\u6784\u7cfb\u7edf
		boolean isShowOfs = false;
		if (1 == isUse) {
			if (1 == showDone && (viewType == 1 || viewType == 2 || viewType == 3 || viewType == 4)) {
			 	isShowOfs = true;
		 	} else if (viewType == 1 || viewType == 4) {
			 	isShowOfs = true;
		 	}
		}
		if (isShowOfs) {
			//\u7edf\u4e00\u5f85\u529e\u5f02\u6784\u7cfb\u7edf\u6d41\u7a0b\u7c7b\u578b
			rsOfs.execute("select workflowid, workflowname from Ofs_workflow where sysid = " + value);
			while(rsOfs.next()){
				JSONObject jsonWfObj = new JSONObject();
				jsonWfObj.put("id", "wf_" + rsOfs.getString("workflowid"));
				jsonWfObj.put("text", rsOfs.getString("workflowname"));
				jsonWfObj.put("draggable", false);
				if (!flowidList.contains(rsOfs.getString("workflowid"))) {
					jsonWfObj.put("checked", false);
				} else {
					jsonWfObj.put("checked", true);
					jsonWfObj.put("expanded", true);
				}
				if(typeExpandList.contains(rsOfs.getString("workflowid"))){
					jsonWfObj.put("expanded", true);
				}
				jsonWfObj.put("leaf", true);
				jsonArrayReturn.put(jsonWfObj);
			}
		}
	} else {
		rsIn.executeSql("select a.nodeId,b.nodeName,a.nodeType from  workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id  and a.workflowId="+ value + " order by nodetype");

		JSONArray jsonNodeArrayObj = new JSONArray();
		while (rsIn.next()) {
			int nodeType = Util.getIntValue(rsIn.getString("nodeType"));
			if (viewType == 2 && nodeType == 3)
		continue; //\u5982\u679c\u662f\u529e\u7ed3\u4e8b\u5b9c\u5e76\u4e14\u8282\u70b9\u662f process\u7684\u5c06\u4e0d\u4f1a\u663e\u793a\u51fa\u6765

			JSONObject jsonNodeObj = new JSONObject();
			String nodeId = Util.null2String(rsIn.getString("nodeId"));
			String nodeName = Util.null2String(rsIn
			.getString("nodeName"));
			jsonNodeObj.put("id", "node_" + nodeId);
			jsonNodeObj.put("text", nodeName);
			jsonNodeObj.put("leaf", true);
			jsonNodeObj.put("draggable", false);

			if (!nodeidList.contains(nodeId)) {
				jsonNodeObj.put("checked", false);
			} else {
				jsonNodeObj.put("checked", true);
				jsonNodeObj.put("expanded", true);
			}
			jsonNodeObj.put("leaf", true);

			jsonArrayReturn.put(jsonNodeObj);
		}
	}
	out.println(jsonArrayReturn.toString());

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("homepage/element/setting/WorkflowCenterTreeData.jsp"), 3646281888969144309L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}
