/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._definedform;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;
import net.sf.json.JSONObject;
import net.sf.json.JSONArray;
import weaver.conn.RecordSetTrans;
import weaver.general.Util;

public class _hrmfieldgroupoperation__jsp extends com.caucho.jsp.JavaPage
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
      weaver.cpt.util.CptFieldManager CptFieldManager;
      CptFieldManager = (weaver.cpt.util.CptFieldManager) pageContext.getAttribute("CptFieldManager");
      if (CptFieldManager == null) {
        CptFieldManager = new weaver.cpt.util.CptFieldManager();
        pageContext.setAttribute("CptFieldManager", CptFieldManager);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.systeminfo.label.LabelComInfo LabelComInfo;
      LabelComInfo = (weaver.systeminfo.label.LabelComInfo) pageContext.getAttribute("LabelComInfo");
      if (LabelComInfo == null) {
        LabelComInfo = new weaver.systeminfo.label.LabelComInfo();
        pageContext.setAttribute("LabelComInfo", LabelComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.hrm.definedfield.HrmFieldGroupComInfo HrmFieldGroupComInfo;
      HrmFieldGroupComInfo = (weaver.hrm.definedfield.HrmFieldGroupComInfo) pageContext.getAttribute("HrmFieldGroupComInfo");
      if (HrmFieldGroupComInfo == null) {
        HrmFieldGroupComInfo = new weaver.hrm.definedfield.HrmFieldGroupComInfo();
        pageContext.setAttribute("HrmFieldGroupComInfo", HrmFieldGroupComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      


User user=HrmUserVarify.getUser(request, response);
if(user==null){
	out.print("[]");
	return;
}
int currentLanguageid=user.getLanguage();

	String grouptablename="hrm_fieldgroup";

  String src = Util.null2String(request.getParameter("src"));
  
  int groupid=0;
  String groupnamecn="";
  String groupnameen="";
  String groupnametw="";
  if(src.equals("editgroupbatch")){//\u6279\u91cf\u7f16\u8f91\u5206\u7ec4
   
	String dtinfo = Util.null2String(request.getParameter("dtinfo"));
	int grouptype = Util.getIntValue(request.getParameter("grouptype"),0);//\u6240\u5c5e\u9875\u9762 \u57fa\u672c\u4fe1\u606f\u9875\u9762 \u4e2a\u4eba\u4fe1\u606f\u9875\u9762 \u5de5\u4f5c\u4fe1\u606f\u9875\u9762
	String keepgroupids = Util.null2String(request.getParameter("keepgroupids")).replaceAll("on", "0");
	if(keepgroupids.endsWith(",")){
		keepgroupids=keepgroupids.substring(0,keepgroupids.length()-1);
	}
	//System.out.println("dtinfo:"+dtinfo);
	
	JSONArray dtJsonArray=JSONArray.fromObject(dtinfo);
	if(dtJsonArray!=null&&dtJsonArray.size()>0){
		RecordSet.executeSql("delete from "+grouptablename+" where id not in("+keepgroupids+") and grouptype = "+grouptype);
		for(int i=0;i<dtJsonArray.size();i++){
			JSONArray dtJsonArray2= JSONArray.fromObject( dtJsonArray.get(i));
			if(dtJsonArray2!=null&&dtJsonArray2.size()>=4){
				groupnamecn=Util.null2String( dtJsonArray2.getJSONObject(0).getString("groupnamecn"));
				groupnameen=Util.null2String( dtJsonArray2.getJSONObject(1).getString("groupnameen"));
				groupnametw=Util.null2String( dtJsonArray2.getJSONObject(2).getString("groupnametw"));
				groupid= Util.getIntValue( dtJsonArray2.getJSONObject(3).getString("groupid"),0);
				//\u8bbe\u7f6e\u9ed8\u8ba4\u503c
				if(groupnameen.length()==0)groupnameen=groupnamecn;
				if(groupnametw.length()==0)groupnametw=groupnamecn;
				
				int lableid = 0;
				boolean newlabel=false;
				RecordSetTrans RecordSetTrans = new RecordSetTrans();
				RecordSetTrans.setAutoCommit(false);
				String mysql=""+
						" select distinct t2.indexid from HtmlLabelInfo t2 where "+
						" exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+groupnamecn+"' and t1.languageid=7) "+
						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+groupnameen+"' and t1.languageid=8) "+ 
						" and exists (select 1 from HtmlLabelInfo t1 where t1.indexid=t2.indexid and t1.labelname='"+groupnametw+"' and t1.languageid=9) " ;
				RecordSetTrans.executeSql(mysql);
				if(newlabel=(!RecordSetTrans.next())){
				  	lableid = CptFieldManager.getNewIndexId(RecordSetTrans);
					  RecordSetTrans.executeSql("delete from HtmlLabelIndex where id="+lableid);
					  RecordSetTrans.executeSql("delete from HtmlLabelInfo where indexid="+lableid);
					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelIndex values("+lableid+",'"+groupnamecn+"')");
					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+groupnamecn+"',7)");//\u4e2d\u6587
					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+groupnameen+"',8)");//\u82f1\u6587
					  RecordSetTrans.executeSql("INSERT INTO HtmlLabelInfo values("+lableid+",'"+groupnametw+"',9)");//\u7e41\u4f53
					  
				  }else{
				  	lableid=RecordSetTrans.getInt("indexid");
				  }
				  RecordSetTrans.commit();
				  if(newlabel)LabelComInfo.addLabeInfoCache(""+lableid);//\u66f4\u65b0\u7f13\u5b58
				String sql="";
				if(groupid>0){
					sql="update "+grouptablename+" set grouplabel="+lableid+",grouporder="+(i+1)+" where id="+groupid;
				}else{
					sql="insert into "+grouptablename+"(grouplabel,grouporder,grouptype) values('"+lableid+"','"+(i+1)+"',"+grouptype+") ";
				}
				RecordSet.executeSql(sql);
				
			}
		}	
	}
	
	HrmFieldGroupComInfo.removeCache();
	out.print("[]");
}else if("loadgroupdata".equalsIgnoreCase(src)){//\u8bfb\u53d6\u4fdd\u5b58\u7684\u4fe1\u606f
	JSONArray arr=new JSONArray();
	String grouptype = Util.null2String(request.getParameter("grouptype"));
	HrmFieldGroupComInfo.setTofirstRow();
	while(HrmFieldGroupComInfo.next()){;
		if(!grouptype.equals(HrmFieldGroupComInfo.getType()))continue;
		JSONArray jsonArray=new JSONArray();
		
		JSONObject jsonObject=new JSONObject();
		jsonObject.put("name", "groupnamecn");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( HrmFieldGroupComInfo.getLabel(),0),7));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupnameen");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( HrmFieldGroupComInfo.getLabel(),0),8));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupnametw");
		jsonObject.put("value", SystemEnv.getHtmlLabelName(Util.getIntValue( HrmFieldGroupComInfo.getLabel(),0),9));
		jsonObject.put("iseditable", true);
		jsonObject.put("type", "input");
		jsonArray.add(jsonObject);
		
		jsonObject=new JSONObject();
		jsonObject.put("name", "groupid");
		jsonObject.put("value", HrmFieldGroupComInfo.getid());
		if(grouptype.equals("4")||grouptype.equals("5")){
			if(HrmFieldGroupComInfo.existsHrmFields(HrmFieldGroupComInfo.getid())){
				jsonObject.put("display", "none");
			}
		}else{
			if(HrmFieldGroupComInfo.existsFields(HrmFieldGroupComInfo.getid())){
				jsonObject.put("display", "none");
			}
		}
		
		jsonObject.put("type", "checkbox");
		jsonArray.add(jsonObject);
		
		arr.add(jsonArray);
	}
	
	out.print(arr.toString());
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/definedform/HrmFieldGroupOperation.jsp"), -3735737870673829728L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string2 = "	\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
  }
}