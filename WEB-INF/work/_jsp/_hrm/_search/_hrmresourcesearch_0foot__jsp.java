/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._search;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;

public class _hrmresourcesearch_0foot__jsp extends com.caucho.jsp.JavaPage
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
      
User user = HrmUserVarify.getUser (request , response) ;

      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((SystemEnv.getHtmlLabelName(683, user.getLanguage())));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((SystemEnv.getHtmlLabelName(18941, user.getLanguage())));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((SystemEnv.getHtmlLabelName(683, user.getLanguage())));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((SystemEnv.getHtmlLabelName(18942, user.getLanguage())));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(3005, user.getLanguage())));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((SystemEnv.getHtmlLabelName(683, user.getLanguage())));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((SystemEnv.getHtmlLabelName(18945, user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((SystemEnv.getHtmlLabelName(683, user.getLanguage())));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((SystemEnv.getHtmlLabelName(18943, user.getLanguage())));
      out.write(_jsp_string7, 0, _jsp_string7.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/search/HrmResourceSearch_foot.jsp"), -1967990625649047473L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string4;
  private final static char []_jsp_string3;
  private final static char []_jsp_string6;
  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  private final static char []_jsp_string5;
  private final static char []_jsp_string1;
  private final static char []_jsp_string7;
  static {
    _jsp_string4 = "\";\r\n			} else if (shareTypeValue == \"4\") {\r\n				sHtml = sHtml\r\n						+ \",\"\r\n						+ shareTypeText\r\n						+ \"(\"\r\n						+ relatedShareNames\r\n						+ \")\"\r\n						+ \"".toCharArray();
    _jsp_string3 = "\";\r\n			} else if (shareTypeValue == \"3\") {\r\n				sHtml = sHtml\r\n						+ \",\"\r\n						+ shareTypeText\r\n						+ \"(\"\r\n						+ relatedShareNames\r\n						+ \")\"\r\n						+ \"".toCharArray();
    _jsp_string6 = "\";\r\n			} else {\r\n				sHtml = sHtml\r\n						+ \",\"\r\n						+ \"".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n \r\n\r\n".toCharArray();
    _jsp_string2 = ">=\"\r\n						+ secLevelValue\r\n						+ \"".toCharArray();
    _jsp_string5 = "=\"\r\n						+ rolelevelText\r\n						+ \"  ".toCharArray();
    _jsp_string1 = "\r\n\r\n\r\n<script type=\"text/javascript\" src=\"/wui/common/jquery/jquery.min_wev8.js\"></script>\r\n<SCRIPT language=\"javascript\" src=\"../../js/weaver_wev8.js\"></script>\r\n<script language=javascript src=\"/js/ecology8/hrm/HrmSearchInit_wev8.js\"></script>\r\n<script language=javascript src=\"/js/ecology8/request/e8.browser_wev8.js\"></script>\r\n<script language=javascript src=\"HrmResourceSearchResult1_wev8.js\"></script>\r\n</BODY>\r\n<SCRIPT language=\"javascript\" defer=\"defer\" src=\"/js/datetime_wev8.js\"></script>\r\n<SCRIPT language=\"javascript\" defer=\"defer\" src=\"/js/JSDateTime/WdatePicker_wev8.js\"></script>\r\n<script type=\"text/javascript\" src=\"/js/selectDateTime_wev8.js\"></script>\r\n<script language=\"javascript\">\r\nfunction onShowResourceConditionBrowserBack(e,dialogId,name){\r\n	if (wuiUtil.getJsonValueByIndex(dialogId, 0) != \"\") {\r\n		var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);\r\n		var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);\r\n		var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);\r\n		var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);\r\n		var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);\r\n		var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);\r\n		var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);\r\n		var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);\r\n	\r\n		var sHtml = \"\";\r\n		var fileIdValue = \"\";\r\n		shareTypeValues = shareTypeValues.substr(1);\r\n		shareTypeTexts = shareTypeTexts.substr(1);\r\n		relatedShareIdses = relatedShareIdses.substr(1);\r\n		relatedShareNameses = relatedShareNameses.substr(1);\r\n		rolelevelValues = rolelevelValues.substr(1);\r\n		rolelevelTexts = rolelevelTexts.substr(1);\r\n		secLevelValues = secLevelValues.substr(1);\r\n		secLevelTexts = secLevelTexts.substr(1);\r\n	\r\n		var shareTypeValueArray = shareTypeValues.split(\"~\");\r\n		var shareTypeTextArray = shareTypeTexts.split(\"~\");\r\n		var relatedShareIdseArray = relatedShareIdses.split(\"~\");\r\n		var relatedShareNameseArray = relatedShareNameses.split(\"~\");\r\n		var rolelevelValueArray = rolelevelValues.split(\"~\");\r\n		var rolelevelTextArray = rolelevelTexts.split(\"~\");\r\n		var secLevelValueArray = secLevelValues.split(\"~\");\r\n		var secLevelTextArray = secLevelTexts.split(\"~\");\r\n		for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {\r\n	\r\n			var shareTypeValue = shareTypeValueArray[_i];\r\n			var shareTypeText = shareTypeTextArray[_i];\r\n			var relatedShareIds = relatedShareIdseArray[_i];\r\n			var relatedShareNames = relatedShareNameseArray[_i];\r\n			var rolelevelValue = rolelevelValueArray[_i];\r\n			var rolelevelText = rolelevelTextArray[_i];\r\n			var secLevelValue = secLevelValueArray[_i];\r\n			var secLevelText = secLevelTextArray[_i];\r\n	\r\n			fileIdValue = fileIdValue + \"~\" + shareTypeValue + \"_\"\r\n					+ relatedShareIds + \"_\" + rolelevelValue + \"_\"\r\n					+ secLevelValue;\r\n\r\n			if (shareTypeValue == \"1\") {\r\n				sHtml = sHtml + \",\" + shareTypeText + \"(\"\r\n						+ relatedShareNames + \")\";\r\n			} else if (shareTypeValue == \"2\") {\r\n				sHtml = sHtml\r\n						+ \",\"\r\n						+ shareTypeText\r\n						+ \"(\"\r\n						+ relatedShareNames\r\n						+ \")\"\r\n						+ \"".toCharArray();
    _jsp_string7 = "\";\r\n			}\r\n		}\r\n				\r\n		sHtml = sHtml.substr(1);\r\n		fileIdValue = fileIdValue.substr(1);\r\n\r\n		jQuery(\"#\"+name).val(fileIdValue);\r\n		jQuery(\"#\"+name+\"span\").html(sHtml);\r\n	}else{\r\n		if (ismand == 0) {\r\n			jQuery(\"#\"+name+\"span\").html(\"\");\r\n		} else {\r\n			jQuery(\"#\"+name+\"span\").html(\"<img src='/images/BacoError.gif' align=absmiddle>\");\r\n		}\r\n		jQuery(\"#\"+name).val(\"\");\r\n	}\r\n}\r\n\r\nfunction resetCondition(selector){\r\n	if(!selector)selector=\"#advancedSearchDiv\";\r\n	//\u6e05\u7a7a\u6587\u672c\u6846\r\n	jQuery(selector).find(\"input[type='text']\").val(\"\");\r\n	//\u6e05\u7a7a\u6d4f\u89c8\u6309\u94ae\u53ca\u5bf9\u5e94\u9690\u85cf\u57df\r\n	jQuery(selector).find(\".e8_os\").find(\"span.e8_showNameClass\").remove();\r\n	jQuery(selector).find(\".e8_os\").find(\"input[type='hidden']\").val(\"\");\r\n	//\u6e05\u7a7a\u4e0b\u62c9\u6846\r\n	try{\r\n		jQuery(selector).find(\"select\").each(function(){\r\n			var $target = jQuery(this);\r\n			var _defaultValue = $target.attr(\"_defaultValue\");\r\n			if(!_defaultValue){\r\n				var option = $target.find(\"option:first\");\r\n				_defaultValue = option.attr(\"value\");\r\n			}\r\n			if($target.attr('id') == 'status')\r\n				_defaultValue = 8;\r\n			$target.val(_defaultValue);\r\n			var checkText=$target.find(\"option:selected\").text();\r\n			var sb = $target.attr('sb');\r\n			jQuery('#sbSelector_'+sb).text(checkText);\r\n			jQuery('#sbSelector_'+sb).attr(\"title\",checkText); \r\n		});\r\n	}catch(e){\r\n		\r\n	}\r\n	//\u6e05\u7a7a\u65e5\u671f\r\n	jQuery(selector).find(\".calendar\").siblings(\"span\").html(\"\");\r\n	jQuery(selector).find(\".calendar\").siblings(\"input[type='hidden']\").val(\"\");\r\n	\r\n	jQuery(selector).find(\".Calendar\").siblings(\"span\").html(\"\");\r\n	jQuery(selector).find(\".Calendar\").siblings(\"input[type='hidden']\").val(\"\");\r\n	\r\n	jQuery(selector).find(\"input[type='checkbox']\").each(function(){\r\n		try{\r\n			changeCheckboxStatus(this,false);\r\n		}catch(e){\r\n			this.checked = false;\r\n		}\r\n	});\r\n}\r\n</script>\r\n</HTML>".toCharArray();
  }
}
