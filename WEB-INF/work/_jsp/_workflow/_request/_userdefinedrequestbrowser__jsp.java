/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._workflow._request;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.util.*;
import weaver.workflow.request.Browsedatadefinition;
import weaver.workflow.browserdatadefinition.Condition;
import weaver.workflow.browserdatadefinition.ConditionField;
import weaver.workflow.browserdatadefinition.ConditionFieldConfig;

public class _userdefinedrequestbrowser__jsp extends com.caucho.jsp.JavaPage
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
      List<Browsedatadefinition> datas = Browsedatadefinition.readAll(Util.null2String(request.getParameter("workflowid")));
	for (Browsedatadefinition data : datas) {
      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((data.getFieldid()));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      if ("3".equals(data.getCreatetype()) && !"".equals(data.getCreatetypeid())) {
      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((data.getFieldid()));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((data.getCreatetypeid()));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      }
      out.write(_jsp_string5, 0, _jsp_string5.length);
      if ("3".equals(data.getCreatedepttype()) && !"".equals(data.getDepartment())) {
      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((data.getFieldid()));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((data.getDepartment()));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      }
      out.write(_jsp_string5, 0, _jsp_string5.length);
      if ("3".equals(data.getCreatesubtype()) && !"".equals(data.getCreatesubid())) {
      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((data.getFieldid()));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((data.getCreatesubid()));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      }
      out.write(_jsp_string5, 0, _jsp_string5.length);
      if ("8".equals(data.getCreatedatetype()) && !"".equals(data.getCreatedatefieldid())) {
      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((data.getFieldid()));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((data.getCreatedatefieldid()));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      }
      out.write(_jsp_string5, 0, _jsp_string5.length);
      if ("3".equals(data.getXgxmtype()) && !"".equals(data.getXgxmid())) {
      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((data.getFieldid()));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((data.getXgxmid()));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      }
      out.write(_jsp_string5, 0, _jsp_string5.length);
      if ("3".equals(data.getXgkhtype()) && !"".equals(data.getXgkhid())) {
      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((data.getFieldid()));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((data.getXgkhid()));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      }
      out.write(_jsp_string11, 0, _jsp_string11.length);
      }
      out.write(_jsp_string12, 0, _jsp_string12.length);
      List<Condition> conditions = Condition.readAll(Util.null2String(request.getParameter("workflowid")));
	for (Condition condition : conditions) {
		String key = condition.getFieldId() + "_" + ("1".equals(condition.getViewType()) ? "1" : "0");
	
      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((key));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      for (ConditionField field : condition.getFields()) {
		if (field.isGetValueFromFormField()) {
      out.write(_jsp_string5, 0, _jsp_string5.length);
      if (!"".equals(field.getValue())) {
      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((key));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((field.getFieldName()));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((field.getValue()));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      }
      out.write(_jsp_string11, 0, _jsp_string11.length);
      }}}
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((Condition.getConfigFieldTypes()));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((Util.null2String(request.getParameter("workflowid"))));
      out.write(_jsp_string18, 0, _jsp_string18.length);
      out.print((Util.null2String(request.getParameter("workflowid"))));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      //\u5c1d\u8bd5\u53d6\u5f97\u4e3b\u8868\u5b57\u6bb5
      out.write(_jsp_string20, 0, _jsp_string20.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("workflow/request/UserDefinedRequestBrowser.jsp"), -8602786303224555316L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string18;
  private final static char []_jsp_string17;
  private final static char []_jsp_string14;
  private final static char []_jsp_string7;
  private final static char []_jsp_string19;
  private final static char []_jsp_string4;
  private final static char []_jsp_string6;
  private final static char []_jsp_string2;
  private final static char []_jsp_string9;
  private final static char []_jsp_string3;
  private final static char []_jsp_string15;
  private final static char []_jsp_string10;
  private final static char []_jsp_string1;
  private final static char []_jsp_string13;
  private final static char []_jsp_string8;
  private final static char []_jsp_string5;
  private final static char []_jsp_string11;
  private final static char []_jsp_string16;
  private final static char []_jsp_string0;
  private final static char []_jsp_string20;
  private final static char []_jsp_string12;
  static {
    _jsp_string18 = "&fieldid=' + fieldId;\r\n\r\n		if (!!fieldId) {\r\n			var config = _CACHE[fieldId];\r\n			if (!config) {\r\n				var viewType = getViewType(inputIdOrName);\r\n				var fieldIdAndViewType = fieldId + '_' + viewType;\r\n				config = _CACHE[fieldIdAndViewType];\r\n				param = 'bdf_wfid=".toCharArray();
    _jsp_string17 = ",'.indexOf(',' + type + ',') >= 0;\r\n	}\r\n\r\n	function getUserDefinedRequestParam(inputIdOrName) {\r\n		var fieldId = getFieldId(inputIdOrName);\r\n		var param = 'currworkflowid=".toCharArray();
    _jsp_string14 = "']['bdf_".toCharArray();
    _jsp_string7 = "'].sub = '".toCharArray();
    _jsp_string19 = "&bdf_fieldid=' + fieldId + '&bdf_viewtype=' + viewType;\r\n			}\r\n			if (!!config) {\r\n				for (var ele in config) {\r\n					var targetFieldId = config[ele];\r\n					var targetInputIdOrName = inputIdOrName.replace(fieldId, targetFieldId);\r\n					var targetObj = $G(targetInputIdOrName);\r\n					if (!targetObj) {\r\n						".toCharArray();
    _jsp_string4 = "';\r\n		".toCharArray();
    _jsp_string6 = "'].dep = '".toCharArray();
    _jsp_string2 = "'] = {};\r\n		".toCharArray();
    _jsp_string9 = "'].xgxm = '".toCharArray();
    _jsp_string3 = "'].cre = '".toCharArray();
    _jsp_string15 = "'] = '".toCharArray();
    _jsp_string10 = "'].xgkh = '".toCharArray();
    _jsp_string1 = "\r\n		_CACHE['".toCharArray();
    _jsp_string13 = "'] = {};\r\n	".toCharArray();
    _jsp_string8 = "'].date = '".toCharArray();
    _jsp_string5 = "\r\n		".toCharArray();
    _jsp_string11 = "\r\n".toCharArray();
    _jsp_string16 = "\r\n	function getFieldId(inputIdOrName) {\r\n		var reg = /^field([0-9]+)(_[0-9]+)?$/gi;\r\n		if (reg.test(inputIdOrName)) {\r\n			fieldId = inputIdOrName.replace(reg, '$1');\r\n		}\r\n		return fieldId;\r\n	}\r\n\r\n	function getViewType(inputIdOrName) {\r\n		var reg = /^field[0-9]+_[0-9]+?$/gi;\r\n		if (reg.test(inputIdOrName)) {\r\n			return '1';\r\n		} else {\r\n			return '0';\r\n		}\r\n	}\r\n\r\n	function isCanConfigType(type) {\r\n		return ',".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n<script type=\"text/javascript\">\r\n	var _CACHE = new Object();\r\n".toCharArray();
    _jsp_string20 = "\r\n						targetObj = $G('field' + targetFieldId);\r\n					}\r\n					if (!!targetObj) {\r\n						var val = jQuery(targetObj).val();\r\n						if (!!val) {\r\n							param += '&' + ele + '=' + val;\r\n						}\r\n					}\r\n				}\r\n			}\r\n		}\r\n		try{\r\n			if(window._____guid1 && window.__requestid){\r\n				if(param!=\"\"){\r\n					param += \"&\";\r\n				}\r\n				param += \"__requestid=\"+window.__requestid;\r\n			}\r\n		}catch(ex1){}\r\n		return param;\r\n	}\r\n\r\n</script>".toCharArray();
    _jsp_string12 = "\r\n\r\n".toCharArray();
  }
}