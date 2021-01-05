/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._setup;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import net.sf.json.JSONArray;
import weaver.general.Util;
import java.util.*;
import weaver.hrm.User;
import weaver.hrm.HrmUserVarify;
import weaver.formmode.service.RemindJobService;
import net.sf.json.JSONObject;
import weaver.formmode.task.RemindDataService;
import weaver.formmode.task.TaskService;
import weaver.systeminfo.systemright.CheckSubCompanyRight;
import weaver.formmode.virtualform.VirtualFormHandler;
import weaver.systeminfo.SystemEnv;
import org.jdom.Document;
import weaver.servicefiles.ResetXMLFileCache;
import com.weaver.formmodel.util.DateHelper;

public class _remindjobsettingsaction__jsp extends com.caucho.jsp.JavaPage
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
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.servicefiles.ScheduleXML ScheduleXML;
      ScheduleXML = (weaver.servicefiles.ScheduleXML) pageContext.getAttribute("ScheduleXML");
      if (ScheduleXML == null) {
        ScheduleXML = new weaver.servicefiles.ScheduleXML();
        pageContext.setAttribute("ScheduleXML", ScheduleXML);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
out.clear();
User user = HrmUserVarify.getUser (request , response) ;
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
String operation = Util.null2String(request.getParameter("operation"));

RemindJobService remindJobService = new RemindJobService();
TaskService taskService = new TaskService();
if(operation.equals("saveorupdate")) {
	String conditionssql = Util.null2String(request.getParameter("conditionssql"));
	request.setAttribute("conditionssql",conditionssql);
	String id = remindJobService.saveOrUpdate(request,user);
	request.setAttribute("id",id);
	taskService.doAction(request);
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshRemindJob("+id+");</script>");
} else if(operation.equals("delete")) {
  	int id = Util.getIntValue(request.getParameter("id"));
  	taskService.doAction(request);
  	remindJobService.delete(id);
  	String appid = request.getParameter("appid");
	List<Map<String,Object>> dataList = remindJobService.getRemindJobByModeIds(Util.getIntValue(appid));
	
	String firstId = "";
	if (dataList != null && dataList.size() > 0) 
		firstId = Util.null2String(((Map<String,Object>)dataList.get(0)).get("id"));
	response.getWriter().println("<script type=\"text/javascript\">parent.parent.refreshRemindJob("+firstId+");</script>");
}else if(operation.equals("getRemindJobByModeIdWithJSON")){
	int appId = Util.getIntValue(request.getParameter("appid"));
	int fmdetachable = Util.getIntValue(request.getParameter("fmdetachable"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));
	JSONArray remindJobArr = new JSONArray();
	if(fmdetachable==1){
		remindJobArr = remindJobService.getRemindJobByModeIdWithJSONDetach(appId,user.getLanguage(),subCompanyId);
	}else{
		remindJobArr = remindJobService.getRemindJobByModeIdWithJSON(appId,user.getLanguage());
	}
	out.print(remindJobArr.toString());
	out.flush();
	out.close();
	return;
}else if(operation.equals("getModesByFormId")){
	String fmdetachable = Util.null2String(request.getParameter("fmdetachable"));
	String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
	String formid = Util.null2String(request.getParameter("formid"));
	String remindtype = Util.null2String(request.getParameter("remindtype"));
	String formtype = Util.null2String(request.getParameter("formtype"));
	String sql = "select id,modename from modeinfo where isdelete=0 and formid="+formid;
	if(fmdetachable.equals("1")){
      	CheckSubCompanyRight mSubRight = new CheckSubCompanyRight();
		int[] mSubCom = mSubRight.getSubComByUserRightId(user.getUID(),"ModeSetting:All",0);
		String subCompanyIds = "";
		for(int i=0;i<mSubCom.length;i++){
			if(i==0){
				subCompanyIds += ""+mSubCom[i];
			}else{
				subCompanyIds += ","+mSubCom[i];
			}
		}
		if(subCompanyIds.equals("")){
			sql+= " and 1=2 ";
		}else{
			sql+= " and subCompanyId in ("+subCompanyIds+") ";
		}
  }
	rs.executeSql(sql);
	String datype = rs.getDBType();
	JSONObject resultObject = new JSONObject();
	JSONArray jsonArray = new JSONArray();
	while(rs.next()){
		JSONObject jsonObject = new JSONObject();
		String id = rs.getString("id");
		String modename = rs.getString("modename");
		jsonObject.put("value",id);
		jsonObject.put("text",modename);
		jsonArray.add(jsonObject);
	}	
	if(datype.equals("sqlserver")){
		sql = "select a.fieldname,a.detailtable,a.fieldlabel from workflow_billfield a where  a.billid="+formid+" and  a.fieldhtmltype not in (6,7)  order by detailtable ";
	}else{
		sql = "select a.fieldname,a.detailtable,a.fieldlabel from workflow_billfield a where  a.billid="+formid+" and  a.fieldhtmltype not in (6,7)  order by detailtable desc";
	}
	
	rs.executeSql(sql);
	JSONArray fieldArray = new JSONArray();
	while(rs.next()){
		JSONObject jsonObject = new JSONObject();
		String id = rs.getString("id");
		String fieldname = rs.getString("fieldname");
		String detailtable = rs.getString("detailtable");
		int fieldlabel = Util.getIntValue(rs.getString("fieldlabel"), 0);
	    String indexdesc = SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
		if(detailtable != null && !detailtable.equals("")){
			//String tempdetailtable = detailtable.substring(detailtable.length()-1,detailtable.length());
			String tempdetailtable = detailtable.substring(detailtable.lastIndexOf("dt")+2,detailtable.length());
			if(!formtype.equals(tempdetailtable)){
				continue;
			}
			indexdesc += "("+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+tempdetailtable+")";
			fieldname = detailtable+"."+fieldname;
		}
		jsonObject.put("value",fieldname);
		jsonObject.put("text",indexdesc);
		fieldArray.add(jsonObject);
	}
	resultObject.put("modedata",jsonArray);
	resultObject.put("fielddata",fieldArray);
	out.print(resultObject.toString());
	out.flush();
	out.close();
	return;
}else if(operation.equals("getHrmFieldByFormId")){
	String formid = Util.null2String(request.getParameter("formid"));
	String sql = "select a.id,a.fieldname,b.labelname from workflow_billfield a,HtmlLabelInfo b where a.billid="+formid+" and a.fieldlabel=b.indexid and b.languageid=7 and a.fieldhtmltype=3 and a.type=1 and a.detailtable='' order by a.id";
	rs.executeSql(sql);
	JSONArray jsonArray = new JSONArray();
	while(rs.next()){
		JSONObject jsonObject = new JSONObject();
		String id = rs.getString("id");
		String fieldname = rs.getString("fieldname");
		String labelname = rs.getString("labelname");
		jsonObject.put("id",id);
		jsonObject.put("fieldname",fieldname);
		jsonObject.put("labelname",labelname);
		jsonArray.add(jsonObject);
	}
	out.print(jsonArray.toString());
	out.flush();
	out.close();
	return;
}else if(operation.equals("initRemindData")){
	int id = Util.getIntValue(request.getParameter("id"));
	out.print(SystemEnv.getHtmlLabelName(82254,user.getLanguage()));//\u540e\u53f0\u6b63\u5728\u91cd\u6784\u6570\u636e......
	out.flush();
	out.close();
	return;
}else if(operation.equals("changeFormType")){
	String formid = Util.null2String(request.getParameter("formid"));
	String sql = "select detailtable from workflow_billfield where billid = "+formid+" group by detailtable";
	rs.executeSql(sql);
	JSONArray jsonArray = new JSONArray();
	while(rs.next()){
		JSONObject jsonObject = new JSONObject();
		String detailtable = rs.getString("detailtable");
		if(detailtable.length() > 0){
			//jsonObject.put("detailtable",detailtable.substring(detailtable.length()-1,detailtable.length()));
			jsonObject.put("detailtable",detailtable.substring(detailtable.lastIndexOf("dt")+2,detailtable.length()));
		}else{
			jsonObject.put("detailtable",detailtable);
		}
		jsonArray.add(jsonObject);
	}
	out.print(jsonArray.toString());
	out.flush();
	out.close();
	return;
}else if(operation.equals("getHrmField")){
	int formid = Util.getIntValue(request.getParameter("formid"), 0);
	String formtype = Util.null2String(request.getParameter("formtype"));
	String sql = "select a.id,a.fieldname,b.labelname,a.detailtable from workflow_billfield a,HtmlLabelInfo b where a.billid="+formid+" and a.fieldlabel=b.indexid and b.languageid=7 and a.fieldhtmltype=3 and a.type=1 order by a.id asc,detailtable asc";
	rs.executeSql(sql);
	JSONArray fieldArray = new JSONArray();
	while(rs.next()){
		JSONObject jsonObject = new JSONObject();
		String fieldid = rs.getString("id");
		String labelname = rs.getString("labelname");
		String detailtable = rs.getString("detailtable");
		if(detailtable != null && !detailtable.equals("")){
			if(detailtable.substring(detailtable.length()-1,detailtable.length()).equals(formtype)){
				labelname += "(" + SystemEnv.getHtmlLabelName(126218, user.getLanguage()) +formtype+")";
			}else{
				continue;
			}
		}
		jsonObject.put("value",fieldid);
		jsonObject.put("text",labelname);
		fieldArray.add(jsonObject);
	}
	out.print(fieldArray.toString());
	out.flush();
	out.close();
	return;
}else if(operation.equals("getSqlText")){
    int id = Util.getIntValue(request.getParameter("id"), 0);
    int type = Util.getIntValue(request.getParameter("type"), 0);
    String formid = Util.null2String(request.getParameter("formid"), "0");
    Map map = remindJobService.getRemindJobById(id);
    String fieldname = "";
    if(type==1){//\u77ed\u4fe1
        fieldname = "isRemindSMS";
    }else if(type==2){
        fieldname = "isRemindEmail";
    }else if(type==3){
        fieldname = "isRemindWorkflow";
    }else if(type==4){
        fieldname = "isRemindWeChat";
    }else if(type==5){
        fieldname = "isRemindEmobile";
    }
    String sql = taskService.getDqtxSqlwhere(map,fieldname);
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("sql",sql);
    boolean isvirtualform = VirtualFormHandler.isVirtualForm(formid);
    String vdatasource="";
    boolean f=false;
    if(isvirtualform){
        Map<String, Object> vFormInfo = new HashMap<String, Object>();
        vFormInfo = VirtualFormHandler.getVFormInfo(formid);
        vdatasource = Util.null2String(vFormInfo.get("vdatasource")); // \u865a\u62df\u8868\u5355\u6570\u636e\u6e90
        f = rs.executeSql(sql,vdatasource);
    }else{
        f = rs.executeSql(sql);
    }
    String errorMsg = "";
    int count = 0;
    int count1 = 0;
    if(f){
        count = rs.getCounts();
        String sql1 = "select 1 from mode_reminddata_all where lastdate='"+DateHelper.getCurrentDate()+"' and remindjobid="+id+" and "+fieldname+"=1";
        rs.execute(sql1);
        count1 = rs.getCounts();
    }else{
        errorMsg = SystemEnv.getHtmlLabelName(129564,user.getLanguage());
    }
    jsonObject.put("count",count);
    jsonObject.put("count1",count1);
    jsonObject.put("errorMsg",errorMsg);
    out.print(jsonObject.toString());
    out.flush();
    out.close();
    return;
}else if(operation.equals("checkCreater")){
    int formid = Util.getIntValue(request.getParameter("formid"), 0);
    //\u5224\u65ad\u662f\u5426\u6709\u6a21\u5757\u521b\u5efa\u4eba\u5b57\u6bb5
    Boolean haveCreater=false;
    boolean virtualform = VirtualFormHandler.isVirtualForm(formid);
    if(virtualform){
        rs.executeSql("select fieldname FROM workflow_billfield  WHERE  billid ="+formid);
        while(rs.next()){
            String fieldname=Util.null2String(rs.getString("fieldname"));
            if(fieldname.toLowerCase().equals("modedatacreater"))haveCreater=true;
        }
    }else{
        haveCreater=true;
    }
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("haveCreater",haveCreater);
    out.print(jsonObject.toString());
    out.flush();
    out.close();
    return;
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/setup/RemindJobSettingsAction.jsp"), -6451453319717175337L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  static {
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}
