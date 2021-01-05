/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._matrixmanage._pages;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.*;
import weaver.hrm.*;
import weaver.conn.*;
import org.json.*;
import java.math.*;
import java.text.*;
import weaver.matrix.*;
import java.sql.Timestamp;
import weaver.general.Util;
import weaver.docs.docs.CustomFieldManager;
import weaver.docs.docs.FieldParam;
import java.util.*;

public class _savetablerecords__jsp extends com.caucho.jsp.JavaPage
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
    response.setContentType("application/json;charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.conn.RecordSetTrans RecordSetTrans;
      RecordSetTrans = (weaver.conn.RecordSetTrans) pageContext.getAttribute("RecordSetTrans");
      if (RecordSetTrans == null) {
        RecordSetTrans = new weaver.conn.RecordSetTrans();
        pageContext.setAttribute("RecordSetTrans", RecordSetTrans);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rs3;
      rs3 = (weaver.conn.RecordSet) pageContext.getAttribute("rs3");
      if (rs3 == null) {
        rs3 = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs3", rs3);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.outinterface.HrmOutInterface HrmOutInterface;
      HrmOutInterface = (weaver.hrm.outinterface.HrmOutInterface) pageContext.getAttribute("HrmOutInterface");
      if (HrmOutInterface == null) {
        HrmOutInterface = new weaver.hrm.outinterface.HrmOutInterface();
        pageContext.setAttribute("HrmOutInterface", HrmOutInterface);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;

char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
//\u6570\u636e\u5e93\u7c7b\u578b
List<String>  sqls=new ArrayList<String>();
//\u4e3b\u8981\u5206\u66f4\u65b0\uff0c\u65b0\u589e\u90e8\u5206
List<Map<String,String>>  updaterecords=new ArrayList<Map<String,String>>();
List<Map<String,String>>  addrecords=new ArrayList<Map<String,String>>();
//\u7f16\u8f91\u6761\u6570
int  recordnum=Integer.valueOf(request.getParameter("recordnum"));
String matrixid=request.getParameter("matrixid");
//\u77e9\u9635\u5bf9\u5e94\u7684\u8868\u540d
String matrixtablename=MatrixUtil.MATRIXPREFIX+matrixid;
//\u77e9\u9635\u5b57\u6bb5\u96c6\u5408
List<String>  matrixfields=MatrixUtil.getMatrixFieldsArray(matrixid);
Map<String,String>  record;
String uuid;
String dataorder;
float maxMatrixDataOrder = 0;
String dbType = rs3.getDBType();
String dataorderStr = "dataorder";
if("oracle".equalsIgnoreCase(dbType)){
	dataorderStr = "dataorder+0";
}else if("sqlserver".equalsIgnoreCase(dbType)){
	dataorderStr = "cast(dataorder as float)";
}
rs3.executeSql("select max("+dataorderStr+") from "+MatrixUtil.MATRIXPREFIX+matrixid);
if(rs3.next()){
	maxMatrixDataOrder = rs3.getFloat(1);
	if(maxMatrixDataOrder == -1){
		maxMatrixDataOrder = 0;
	}
}

//\u63d2\u5165\u6570\u636e
for(int i=0;i<recordnum;i++){
	 record=new HashMap<String,String>();
	 uuid=Util.null2String(request.getParameter("uuid_"+i));
	 dataorder=request.getParameter("dataorder_"+i);
	 if(!"".equals(dataorder.trim())){
		try{
			 float dataorderf = 0;
			 dataorderf = Float.parseFloat(dataorder);
			 dataorder = String.valueOf(dataorderf);
		 }catch(Exception e){
			 out.println("{\"success\":\"2\"}");
			 return;
		 }
	 }
	 for(String field:matrixfields){
     	 record.put(field,Util.null2String(request.getParameter((field+"_"+i).toLowerCase())));
	 }
	 //\u65b0\u589e
	 if("".equals(uuid)){
		 if("".equals(dataorder.trim())){
			 maxMatrixDataOrder++;
			 dataorder=maxMatrixDataOrder+"";
		 }
		 record.put("dataorder",dataorder);
		 addrecords.add(record);
		 record.put("uuid",UUID.randomUUID().toString());
     //\u66f4\u65b0		 
	 }else{
		 record.put("dataorder",String.valueOf(dataorder));
		 updaterecords.add(record); 
		 record.put("uuid",uuid);
	 }
}


try{//\u4fee\u6539\u5ba2\u6237\u5361\u7247\u5ba2\u6237\u7ecf\u7406\u65f6\uff0c\u540c\u6b65\u4fee\u6539 \u5ba2\u6237\u7eac\u5ea6 \u5ba2\u6237\u7ecf\u7406\u90e8\u95e8\u4e0b\u9762\u7684\u4eba\u5458\uff0c\u66f4\u65b0\u77e9\u9635\u4e0b\u9762\u7684\u4eba\u5458
	String name = "";
	String sql = "select name from MatrixInfo where id="+matrixid;
	rs3.executeSql(sql);
	if(rs3.next()){
		name= rs3.getString("name");
	}
	if(name.equals("\u5916\u90e8\u7528\u6237")){
		for(int i=0;i<recordnum;i++){
			String subcompanyid = Util.null2String(request.getParameter("subcompany_"+i));
			String crmmanager = Util.null2String(request.getParameter("crmmanager_"+i));
			String outmanager = Util.null2String(request.getParameter("outmanager_"+i));
			if(subcompanyid.length()>0){
				rs3.executeSql("select customid from customresourceout where subcompanyid= "+subcompanyid);
				if(rs3.next()){
					String customerid = Util.null2String(rs3.getString("customid"));
					if(customerid.length()>0){
						HrmOutInterface.changeCustomManager(customerid,crmmanager,"MatrixInfo");
						HrmOutInterface.changeOutManager(customerid,outmanager);
					}
				}
			}
		}
	}
}catch(Exception e){
 new BaseBean().writeLog(e);
}

//\u6dfb\u52a0\u6279\u91cf\u811a\u672c
MatrixUtil.getAddSql(matrixtablename,sqls,matrixfields,addrecords);
//\u66f4\u65b0\u6279\u91cf\u811a\u672c
MatrixUtil.getUpdateSql(matrixtablename,sqls,matrixfields,updaterecords);



try{
	RecordSetTrans.setAutoCommit(false);
	for(String sqlitem:sqls){
		//System.out.println(sqlitem);
		RecordSetTrans.execute(sqlitem);
	}	
	//\u63d0\u4ea4\u4e8b\u52a1
	RecordSetTrans.commit();
	//\u540c\u6b65\u77e9\u9635\u6570\u636e\u5230 \u90e8\u95e8\u6216\u5206\u90e8\uff0c\u53ea\u66f4\u65b0\u6570\u636e
	RecordSet.executeSql("select issystem from MatrixInfo where id = " +matrixid +" and issystem is not null");
	if(RecordSet.next()){
		int isSystem = RecordSet.getInt(1);
		if(isSystem != -1){
			MatrixUtil.sysMatrixDataToSubOrDep(matrixid,isSystem);
		}
	}
	out.println("{\"success\":\"1\"}");
}catch(Exception e){
	//e.printStackTrace();
	out.println("{\"success\":\"0\"}");
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("matrixmanage/pages/savetablerecords.jsp"), 6584041454594992107L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}