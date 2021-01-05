/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._cpt._maintenance;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.cpt.util.CommonShareManager;
import java.util.Map.Entry;
import weaver.common.util.xtree.TreeNode;
import org.json.JSONObject;
import org.json.JSONArray;
import weaver.general.Util;
import weaver.general.TimeUtil;
import java.util.*;
import weaver.systeminfo.*;
import java.sql.Timestamp;
import weaver.hrm.*;

public class _cptassortmenttree2data__jsp extends com.caucho.jsp.JavaPage
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
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.company.DepartmentComInfo DepartmentComInfo;
      DepartmentComInfo = (weaver.hrm.company.DepartmentComInfo) pageContext.getAttribute("DepartmentComInfo");
      if (DepartmentComInfo == null) {
        DepartmentComInfo = new weaver.hrm.company.DepartmentComInfo();
        pageContext.setAttribute("DepartmentComInfo", DepartmentComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.systeminfo.systemright.CheckUserRight CheckUserRight;
      CheckUserRight = (weaver.systeminfo.systemright.CheckUserRight) pageContext.getAttribute("CheckUserRight");
      if (CheckUserRight == null) {
        CheckUserRight = new weaver.systeminfo.systemright.CheckUserRight();
        pageContext.setAttribute("CheckUserRight", CheckUserRight);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.cpt.maintenance.CapitalAssortmentComInfo cptgroup;
      cptgroup = (weaver.cpt.maintenance.CapitalAssortmentComInfo) pageContext.getAttribute("cptgroup");
      if (cptgroup == null) {
        cptgroup = new weaver.cpt.maintenance.CapitalAssortmentComInfo();
        pageContext.setAttribute("cptgroup", cptgroup);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.cpt.capital.CapitalComInfo CapitalComInfo;
      CapitalComInfo = (weaver.cpt.capital.CapitalComInfo) pageContext.getAttribute("CapitalComInfo");
      if (CapitalComInfo == null) {
        CapitalComInfo = new weaver.cpt.capital.CapitalComInfo();
        pageContext.setAttribute("CapitalComInfo", CapitalComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.systeminfo.systemright.CheckSubCompanyRight CheckSubCompanyRight;
      CheckSubCompanyRight = (weaver.systeminfo.systemright.CheckSubCompanyRight) pageContext.getAttribute("CheckSubCompanyRight");
      if (CheckSubCompanyRight == null) {
        CheckSubCompanyRight = new weaver.systeminfo.systemright.CheckSubCompanyRight();
        pageContext.setAttribute("CheckSubCompanyRight", CheckSubCompanyRight);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.cpt.util.CommonShareManager CommonShareManager;
      CommonShareManager = (weaver.cpt.util.CommonShareManager) pageContext.getAttribute("CommonShareManager");
      if (CommonShareManager == null) {
        CommonShareManager = new weaver.cpt.util.CommonShareManager();
        pageContext.setAttribute("CommonShareManager", CommonShareManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs2;
      rs2 = (weaver.conn.RecordSet) pageContext.getAttribute("rs2");
      if (rs2 == null) {
        rs2 = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs2", rs2);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
User user = HrmUserVarify.getUser (request , response) ;

if(user==null){
	out.print("[]");
}
String sqlwhere="";
String cpt_mycapital=Util.null2String(request.getParameter("cpt_mycapital"));
String from=Util.null2String(request.getParameter("from"));
int subcompanyid1=Util.getIntValue (request.getParameter("subcompanyid1"),0);
String isdata=Util.null2String(request.getParameter("isdata"));
if("1".equals(cpt_mycapital)&&!"1".equals(isdata)){
	sqlwhere=" and t1.stateid <> 1 and t1.resourceid in("+CommonShareManager.getContainsSubuserids(""+user.getUID())+") ";
}

//\u5206\u6743start==========
int detachable=0;
RecordSet.executeSql("select cptdetachable from SystemSet");
if(RecordSet.next()){
    detachable=RecordSet.getInt("cptdetachable");
}
if(detachable==1&& user.getUID()!=1){
	int belid = user.getUserSubCompany1();
	int userId = user.getUID();
	char flag=Util.getSeparator();
	String rightStr = "";
	String allsubid = "";
	String blonsubcomid = "";
	if(HrmUserVarify.checkUserRight("Capital:Maintenance",user)){
		rightStr = "Capital:Maintenance";
	}
	 if("1".equals(isdata)){
		 int allsubids[] = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),rightStr);
			for(int i=0;i<allsubids.length;i++){
				if(allsubids[i]>0){
					allsubid += (allsubid.equals("")?"":",") + allsubids[i];
				}	
			}
	}else{
		String sqltmp = "";
		rs2.executeProc("HrmRoleSR_SeByURId", ""+userId+flag+rightStr);
		while(rs2.next()){
		    blonsubcomid=rs2.getString("subcompanyid");
			sqltmp += (", "+blonsubcomid);
		}
		if(!"".equals(sqltmp)){//\u89d2\u8272\u8bbe\u7f6e\u7684\u6743\u9650
			sqltmp = sqltmp.substring(1);
				sqlwhere += " and t1.blongsubcompany in ("+sqltmp+") ";
		}else{
				sqlwhere += " and t1.blongsubcompany in ("+belid+") ";
		}
	}
}
//\u5206\u6743end==========

JSONArray arr=new JSONArray();
JSONObject obj=new JSONObject();

TreeMap<String,JSONObject> map=new  TreeMap<String,JSONObject>();

cptgroup.setTofirstRow();
while(cptgroup.next()){
	obj=new JSONObject();
	String id=cptgroup.getAssortmentId();
	int subcomid=Util.getIntValue( cptgroup.getSubcompanyid1(),0);
	if(subcompanyid1>0&&subcomid!=subcompanyid1){
		continue;
	}
	JSONObject attr=new JSONObject();
	attr.put("groupid", id);
	
	JSONObject numbers=new JSONObject();
	//numbers.put("data1count", cptgroup.getCapitalCount());
	if(!"cptassortment".equalsIgnoreCase(from)){//\u975e\u4e2d\u53f0\u8d44\u4ea7\u7ec4\u8bbe\u7f6e\u9875\u9762,\u6709\u6570\u5b57
		if("1".equals(isdata)){
			numbers.put("data2count", cptgroup.getCapitalData1Count(id));
		}else{
			numbers.put("data2count", cptgroup.getCapitaldata2Count(id,user,sqlwhere));
		}
	}else{
		numbers.put("data2count", "");
	}
	
	obj.put("id",id);
	obj.put("name", cptgroup.getAssortmentName());
	obj.put("pid", cptgroup.getSupAssortmentId());
	obj.put("attr", attr);
	obj.put("numbers", numbers);
	obj.put("submenus", new JSONArray());
	
	if(Util.getIntValue( cptgroup.getSubAssortmentCount(),0)<=0){
		obj.put("hasChildren", false);
	}
	
	map.put(id, obj);
}

Iterator it=map.entrySet().iterator();
while(it.hasNext()){
	Entry<String,JSONObject> entry=(Entry<String,JSONObject>)it.next();
	String k= entry.getKey();
	JSONObject v= entry.getValue();
	
	int pid=Util.getIntValue( v.getString("pid"),0);
	JSONObject p=map.get(""+pid);
	if(pid>0){
		if(p!=null){
			((JSONArray)p.get("submenus")).put(v);
		}
	}else{
		arr.put(v);
	}
	
	
	if(p!=null){//\u8d44\u4ea7(\u8d44\u4ea7\u8d44\u6599)\u8ba1\u6570
		JSONObject pObj= ((JSONObject)p.get("numbers"));
		JSONObject sObj= ((JSONObject)v.get("numbers"));
		int cnt= Util.getIntValue((String)sObj.get("data2count"),0)+Util.getIntValue((String)pObj.get("data2count"),0);
		pObj.put("data2count", ""+cnt);
	}
	
}


if("1".equals(cpt_mycapital)||"quick".equalsIgnoreCase(from)){//\u6211\u7684\u8d44\u4ea7\u5254\u9664\u6ca1\u6709\u8d44\u4ea7\u7684\u8d44\u4ea7\u7ec4
	JSONArray arr2=new JSONArray();
	for(int i=0;i<arr.length();i++){
		JSONObject o=(JSONObject) arr.get(i);
		JSONObject o2=o.getJSONObject("numbers");
		if(o2.getInt("data2count")>0){
			arr2.put(o);
		}
	}
	out.println(arr2.toString());
	//System.out.println(arr2.toString());
}else{
	out.print(arr.toString());
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("cpt/maintenance/CptAssortmentTree2Data.jsp"), 6430638616925019954L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string2 = "\r\n\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}