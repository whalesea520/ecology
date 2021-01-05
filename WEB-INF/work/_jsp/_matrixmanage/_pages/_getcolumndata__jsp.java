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
import weaver.matrix.*;
import weaver.workflow.workflow.*;
import java.sql.Timestamp;
import weaver.general.Util;
import weaver.docs.docs.CustomFieldManager;
import weaver.docs.docs.FieldParam;
import java.util.*;

public class _getcolumndata__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
     private void checkMatrixTable(String matrixid){
  	 String tableName = MatrixUtil.MATRIXPREFIX+matrixid;
  	 
  	  RecordSet matrixRs = new RecordSet();
  	  List<String> fieldnamelist= new ArrayList<String>();
  	 String sql = "select fieldname  from MatrixFieldInfo where matrixid='"
  			+ matrixid + "' order by fieldtype asc, priority";
  	  matrixRs.execute(sql);
  	  while(matrixRs.next()){
  		  fieldnamelist.add(matrixRs.getString(1));
  	  }
  	  matrixRs.executeSql("select * from "+tableName);
  	  String[] columnNames = matrixRs.getColumnName();
  	  
  	  List<String> needAddColumn = new ArrayList<String>();
  	  for(int i =0;i<fieldnamelist.size();i++){
  		  String fieldname= fieldnamelist.get(i);
  		  boolean ishave = false;
  		  for(int j = 0;j<columnNames.length;j++){
  			  if(fieldname.toUpperCase().equals(columnNames[j].toUpperCase())){
  				  ishave = true;
  			  }
  		  }
  		  if(!ishave){
  			  needAddColumn.add(fieldname);
  		  }
  	  }
  	  
  	  for(int i =0;i<needAddColumn.size();i++){
  		  matrixRs.executeSql("alter table "+tableName+" add "+needAddColumn.get(i)+" varchar(1000)");
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
    response.setContentType("application/json;charset=UTF-8");
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
      weaver.conn.RecordSet rs2;
      rs2 = (weaver.conn.RecordSet) pageContext.getAttribute("rs2");
      if (rs2 == null) {
        rs2 = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs2", rs2);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
out.clearBuffer();
User user = HrmUserVarify.getUser (request , response) ;
char flag=Util.getSeparator();
int userid=user.getUID();
request.setCharacterEncoding("UTF-8");
int pageindex=Util.getIntValue(request.getParameter("pageindex"));
int pagesize=Util.getIntValue(request.getParameter("pagesize"));
//\u67e5\u8be2\u5b57\u6bb5\u540d
String qfieldname=Util.null2String(request.getParameter("qfieldname"));
//\u67e5\u8be2\u5b57\u6bb5\u503c
String qfieldvalue=Util.null2String(request.getParameter("qfieldvalue"));

String matrixid=request.getParameter("matrixid");
checkMatrixTable(matrixid);
StringBuffer sqlwhereinfo=new StringBuffer(" 1=1 ");

if(!"".equals(qfieldname)  &&  !"".equals(qfieldvalue)){
	String[] qvalues=qfieldvalue.split(",");
	StringBuffer sb=new StringBuffer();
    String qvstr="";
    int num = 0;
	sqlwhereinfo.append(" and(");
	for(String qvalue:qvalues){
		if(num >0 ){
			sqlwhereinfo.append(" or ");
		}
		sqlwhereinfo.append("").append(qfieldname).append(" like '%,"+qvalue+",%' or "+qfieldname+" like '"+qvalue+",%' or "+qfieldname+"='"+qvalue+"' or "+qfieldname+" like '%,"+qvalue+"'") ;
		num++;
	}
	sqlwhereinfo.append(")");
	//System.out.println(sqlwhereinfo.toString());
}

//\u6839\u636eid\u503c\u83b7\u53d6\u5177\u4f53\u7684\u540d\u79f0
GetShowCondition conditions=new GetShowCondition();

SplitPageParaBean bean=new  SplitPageParaBean();
bean.setSortWay(0);
bean.setBackFields(" * ");
String dbType = rs2.getDBType();
String dataorder = "dataorder";
if("oracle".equalsIgnoreCase(dbType)){
	dataorder = "dataorder-1";
}else if("sqlserver".equalsIgnoreCase(dbType)){
	dataorder = "cast(dataorder as float)";
}
bean.setSqlOrderBy(" "+dataorder+"  ");
//\u77e9\u9635\u8868\u540d
bean.setSqlFrom(" "+MatrixUtil.MATRIXPREFIX+matrixid+" ");
bean.setSqlWhere(sqlwhereinfo.toString());
bean.setPrimaryKey("uuid");
SplitPageUtil util=new SplitPageUtil();
util.setSpp(bean);
List<Map<String,String>>  items=new ArrayList<Map<String,String>>();
Map<String,String> item;
RecordSet   rs=util.getCurrentPageRs(pageindex,pagesize);
int pageRecord=util.getRecordCount();
int columncount;
Map<String, Map<String, String>>  fieldinfos=MatrixUtil.getFieldDetail(matrixid);

int isSystem = -1;
rs2.executeSql("select issystem from MatrixInfo where id = " +matrixid +" and issystem is not null");
if(rs2.next()){
	isSystem = rs2.getInt("issystem");
}

if(pageRecord==0)
{
	item=new HashMap<String,String>();
	item.put("pagecount",pageRecord+"");
	items.add(item);
}
else{
	double f;
	while(rs.next())
	{  
		  columncount=rs.getColCounts();
		  item=new HashMap<String,String>();
		  item.put("pagecount",pageRecord+"");
		  //\u6dfb\u52a0\u5217\u503c
		  for(int i=0;i<columncount;i++){
			String tempstr = rs.getColumnName(i+1);
			if(!"".equals(tempstr)) tempstr = tempstr.toLowerCase();
			//System.out.println("tempstr==="+tempstr);
			if("uuid".equals(tempstr) || "dataorder".equals(tempstr)){
				String tmValue = rs.getString(tempstr);
			   if("dataorder".equals(tempstr)){
				   if(tmValue.endsWith(".0")){
					   tmValue = tmValue.substring(0,tmValue.lastIndexOf(".0"));
				   }
			   }
   	           item.put(tempstr,tmValue);		  
			//\u6d4f\u89c8\u6846
			}else{
			   item.put(tempstr,rs.getString(tempstr));	
			   String value = "";
			   if(!"".equals(rs.getString(tempstr).trim())){
			       try{
				   	value = MatrixUtil.getSpanValueByIds(fieldinfos.get(tempstr),conditions,rs.getString(tempstr));
			       }catch(Exception e){
						
				   }
			   }
			   item.put(tempstr+"_name",value);		  
			}
			//\u589e\u52a0\u7cfb\u7edf\u77e9\u9635\u4e2d\uff0c\u5206\u90e8\u3001\u90e8\u95e8\u9f20\u6807\u60ac\u6d6e\u4e0a\u4e4b\u540e\uff0c\u663e\u793a\u5168\u8def\u5f84
			if("id".equalsIgnoreCase(tempstr)){
				String titleValue = "";
				if(isSystem != -1){
					try{
					    MatrixManager matrixManager = new MatrixManager();
						if(isSystem == 1){ //\u5206\u90e8
							titleValue =matrixManager.getSubcompany(rs.getString(tempstr));
						}else if(isSystem ==2){ //\u90e8\u95e8
							titleValue =matrixManager.getDepartment(rs.getString(tempstr));
						}
					}catch(Exception e){
						
					}
				}
				item.put("title", titleValue);
			}
		  }
		  items.add(item);
	}
}
JSONArray  jsonarray=new JSONArray(items);
out.print(jsonarray.toString());

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("matrixmanage/pages/getcolumndata.jsp"), -8847177416440982250L, false);
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
