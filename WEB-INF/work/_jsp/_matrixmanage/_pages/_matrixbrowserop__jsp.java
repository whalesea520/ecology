/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._matrixmanage._pages;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.workflow.datainput.DynamicDataInput;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Hashtable;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import weaver.general.Util;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.User;
import weaver.hrm.HrmUserVarify;

public class _matrixbrowserop__jsp extends com.caucho.jsp.JavaPage
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
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet rsObj;
      rsObj = (weaver.conn.RecordSet) pageContext.getAttribute("rsObj");
      if (rsObj == null) {
        rsObj = new weaver.conn.RecordSet();
        pageContext.setAttribute("rsObj", rsObj);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      

/*\u7528\u6237\u9a8c\u8bc1*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
    String returnValues = "";
    String id = "";
    String name = "";
    String descr = "";
    String matrixTmp = Util.null2s(request.getParameter("matrixTmp"), "-100");
    String matrixCfield = Util.null2String(request.getParameter("matrixCfield"));
    String operator = Util.null2String(request.getParameter("operator"));
    String isbill = Util.null2String(request.getParameter("isbill"));
    String formid = Util.null2String(request.getParameter("formid"));
    String j = Util.null2String(request.getParameter("j"));
    String sqlstr = "";
    String sql = "";
    String issystem = "";
    String browsertypeid = "";
    if ("1".equals(operator)) {
        sqlstr = "select id,fieldname as name,displayname as descr from MatrixFieldInfo where fieldtype='1'  and matrixid=" + matrixTmp;
    } else if ("2".equals(operator)) {
        sql = "select * from MatrixInfo where id = " + matrixTmp;
        rsObj.executeSql(sql);
        if (rsObj.next()) {
            issystem = rsObj.getString("issystem");
        }
    } else if ("0".equals(operator)) {
        sqlstr = "select id,fieldname as name,displayname as descr from MatrixFieldInfo where fieldtype='0'  and matrixid=" + matrixTmp;
        sql = "select * from MatrixInfo where id = " + matrixTmp;
        rsObj.executeSql(sql);
        if (rsObj.next()) {
            issystem = rsObj.getString("issystem");
        }
    } else if ("3".equals(operator)) {
        if (isbill.equals("0")) {
            sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="
                    + formid;
        }
        if (isbill.equals("1")) {
            sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "
                    + formid + " and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.fieldhtmltype=3 ";
        }

    } else if ("5".equals(operator)) {
        sqlstr = "select * from MatrixFieldInfo where fieldtype='0'  and id=" + matrixCfield;

        rsObj.executeSql(sqlstr);
        if (rsObj.next()) {
            browsertypeid = rsObj.getString("browsertypeid");
        }
    } else if ("6".equals(operator)) {
        sqlstr = "select * from MatrixFieldInfo where fieldtype='0'  and id=" + matrixCfield;

        rsObj.executeSql(sqlstr);
        if (rsObj.next()) {
            browsertypeid = rsObj.getString("browsertypeid");
        }
    } else if ("4".equals(operator)) {
        sqlstr = "select * from MatrixFieldInfo where fieldtype='0'  and id=" + matrixCfield;

        rsObj.executeSql(sqlstr);
        if (rsObj.next()) {
            browsertypeid = rsObj.getString("browsertypeid");
        }
        
        String typestr = "";
        if ("1".equals(browsertypeid) || "17".equals(browsertypeid)) {
            typestr = "1,17,165,166";
        }
        if ("4".equals(browsertypeid) || "57".equals(browsertypeid)) {
            typestr = "4,57,167,168";
        }
        if ("8".equals(browsertypeid) || "135".equals(browsertypeid)) {
            typestr = "8,135";
        }
        if ("7".equals(browsertypeid) || "18".equals(browsertypeid)) {
            typestr = "7,18";
        }

        if ("164".equals(browsertypeid) || "194".equals(browsertypeid)) {
            typestr = "164,194,169,170";
        }
        if ("24".equals(browsertypeid) || "278".equals(browsertypeid)) {
            typestr = "24,278";
        }

        if ("161".equals(browsertypeid)) {
            typestr = "161,162";
        }

        if ("162".equals(browsertypeid)) {
            typestr = "161";
        }
        
        if (typestr.equals("")) {
            typestr = "-789";
        }
        if (isbill.equals("0")) {
            sqlstr = "  select distinct(workflow_formfield.fieldid) as id,fieldname as name,workflow_fieldlable.fieldlable as label,workflow_formdict.fieldhtmltype as htmltype,workflow_formdict.type as type,workflow_formdict.fielddbtype as dbtype,workflow_formfield.isdetail as isdetail,workflow_formfield.groupid,workflow_formfield.fieldorder from workflow_formfield,workflow_formdict,workflow_fieldlable where workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.isdefault = '1' and workflow_formdict.fieldhtmltype!=6 and not(workflow_formdict.fieldhtmltype=2 and workflow_formdict.type=2) and workflow_formdict.fieldhtmltype=3 and workflow_fieldlable.fieldid =workflow_formfield.fieldid and workflow_formdict.id = workflow_formfield.fieldid and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formdict.type in (" + typestr + ") and workflow_formfield.formid="
                    + formid;
        }
        if (isbill.equals("1")) {
            sqlstr = "select distinct(t1.id) as id,t1.fieldname as name,t1.fieldlabel as label,t1.fieldhtmltype as htmltype,t1.type as type, t1.fielddbtype as dbtype,t1.viewtype as isdetail,t1.detailtable,t1.dsporder from workflow_billfield t1 where (t1.viewtype is null or t1.viewtype!=1) and t1.billid = "
                    + formid + " and t1.fieldhtmltype!=6 and not(t1.fieldhtmltype=2 and t1.type=2) and t1.type in (" + typestr + ") and t1.fieldhtmltype=3 ";
        }

    }
    
    if (!"2".equals(operator) && !"5".equals(operator)) {
        //System.out.println("-23----22-"+SystemEnv.getHtmlLabelName("-815",user.getLanguage()));
        if ("0".equals(operator) || "3".equals(operator)) {
            if (("1".equals(issystem) || "2".equals(issystem))) {
                returnValues = "";
            } else {
                returnValues = "<option value='0'> </option>";
            }
        }
        rs.executeSql(sqlstr);
        while (rs.next()) {
            id = Util.null2String(rs.getString("id"));
            name = Util.null2String(rs.getString("name"));
            if ("3".equals(operator) || "4".equals(operator)) {
                if (isbill.equals("1")) {
                    descr = Util.null2String(SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("label")), 7));
                } else {
                    descr = Util.null2String(rs.getString("label"));
                }
            } else {
                descr = Util.null2String(rs.getString("descr"));
            }
            //System.out.println("-55----id-"+id);
            //System.out.println("-55----descr-"+descr);

            returnValues += "<option value=\"" + id + "\">" + descr + "</option>";

        }
        
      //\u5206\u90e8
        if ("164".equals(browsertypeid) || "194".equals(browsertypeid)) {
            id = "-13";
            //descr = "\u521b\u5efa\u4eba\u5206\u90e8";
            //\u521b\u5efa\u4eba\u5206\u90e8\uff08\u7cfb\u7edf\u5b57\u6bb5\uff09
            descr = SystemEnv.getHtmlLabelName(22788, user.getLanguage()) + SystemEnv.getHtmlLabelName(81913, user.getLanguage()) +  SystemEnv.getHtmlLabelName(28415, user.getLanguage()) + SystemEnv.getHtmlLabelName(82174, user.getLanguage());
            returnValues += "<option value=\"" + id + "\">" + descr + "</option>";
        }
      
        //\u90e8\u95e8
        if ("4".equals(browsertypeid) || "57".equals(browsertypeid)) {
            id = "-12";
            //descr = "\u521b\u5efa\u4eba\u90e8\u95e8";
            //\u521b\u5efa\u4eba\u90e8\u95e8\uff08\u7cfb\u7edf\u5b57\u6bb5\uff09
            descr = SystemEnv.getHtmlLabelName(19225, user.getLanguage()) + SystemEnv.getHtmlLabelName(81913, user.getLanguage()) +  SystemEnv.getHtmlLabelName(28415, user.getLanguage()) + SystemEnv.getHtmlLabelName(82174, user.getLanguage());
            returnValues += "<option value=\"" + id + "\">" + descr + "</option>";
        }
    }
    if ("2".equals(operator) && ("1".equals(issystem) || "2".equals(issystem))) {
        returnValues = issystem;
    }
    if ("5".equals(operator)) {
        returnValues = browsertypeid;

    }
    if ("6".equals(operator)) {
        returnValues = j + "," + browsertypeid;

    }

    out.print(returnValues);

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("matrixmanage/pages/matrixbrowserOp.jsp"), -1622242319729896224L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  static {
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n	\r\n".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}
