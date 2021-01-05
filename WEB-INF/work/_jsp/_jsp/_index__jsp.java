/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._jsp;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import weaver.general.GCONST;
import java.io.*;
import java.util.*;
import weaver.hrm.User;
import weaver.hrm.HrmUserVarify;
import weaver.general.StaticObj;
import weaver.systeminfo.SystemEnv;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.general.MouldIDConst;

public class _index__jsp extends com.caucho.jsp.JavaPage
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
      

	int isIncludeToptitle = 0;
	response.setHeader("cache-control", "no-cache");
	response.setHeader("pragma", "no-cache");
	response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((user.getLanguage()));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      com.weaver.function.ConfigInfo ConfigInfo;
      ConfigInfo = (com.weaver.function.ConfigInfo) pageContext.getAttribute("ConfigInfo");
      if (ConfigInfo == null) {
        ConfigInfo = new com.weaver.function.ConfigInfo();
        pageContext.setAttribute("ConfigInfo", ConfigInfo);
      }
      out.write(_jsp_string3, 0, _jsp_string3.length);
      weaver.general.BaseBean baseBean;
      baseBean = (weaver.general.BaseBean) pageContext.getAttribute("baseBean");
      if (baseBean == null) {
        baseBean = new weaver.general.BaseBean();
        pageContext.setAttribute("baseBean", baseBean);
      }
      out.write(_jsp_string3, 0, _jsp_string3.length);
      
if(ConfigInfo.getEcologypath() == null || "".equals(ConfigInfo.getEcologypath())) {
	String servletPath = request.getSession().getServletContext().getRealPath("/");
	ConfigInfo.setEcologypath(servletPath);
}
	String operation = Util.null2String(request.getParameter("operation"));
	int userid= user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}

      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((operation));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      
String type= Util.null2String(request.getParameter("type"));
String url = "/verifyBeforeForward.do?type=local";
String navName = "";
boolean processSql = false;
if("1".equals(type)) {//\u672c\u5730\u5347\u7ea7
	url = "/verifyBeforeForward.do?type=local";
	navName = SystemEnv.getHtmlLabelName(127349,user.getLanguage());
} else if("2".equals(type)) {//\u8fdc\u7a0b\u5347\u7ea7
	url = "/verifyBeforeForward.do?type=remote";
	navName = SystemEnv.getHtmlLabelName(127350,user.getLanguage());
} else if("3".equals(type)) {//\u8fd8\u539f
	url = "/prepareToRecover.do?type=prepareToRecover";
	navName = SystemEnv.getHtmlLabelName(589,user.getLanguage());
} else if("4".equals(type)) {//\u53c2\u6570\u8bbe\u7f6e
	url = "/jsp/selectdirectory.jsp";
	navName = SystemEnv.getHtmlLabelName(17632,user.getLanguage());
} else if("5".equals(type)) {//\u5347\u7ea7\u8bb0\u5f55
	url = "/jsp/updateView.jsp";
	navName = SystemEnv.getHtmlLabelName(17632,user.getLanguage());
} else if("6".equals(type)) {//\u4ee3\u7801\u8ba4\u8bc1
	url = "/jsp/keyCompare.jsp";
	navName = SystemEnv.getHtmlLabelName(127698,user.getLanguage());
} else if("7".equals(type)) {
	url = "/jsp/sqlLog.jsp";
	navName = "\u811a\u672c\u6267\u884c\u6548\u7387\u62a5\u8868";
}

Properties prop = new Properties();
FileInputStream fis = new FileInputStream(GCONST.getRootPath() +"WEB-INF"+ File.separatorChar 
		+ "prop" + File.separatorChar+"Upgrade.properties");

prop.load(fis);
int upgradeStatus=Util.getIntValue(prop.getProperty("STATUS"),3);
int pagestatus = Util.getIntValue(prop.getProperty("PAGESTATUS"),0);//

String classbeanbak= Util.null2String(baseBean.getPropValue("ecologyupdate","classbeanbak"));
String upgradetype= Util.null2String(baseBean.getPropValue("ecologyupdate","upgradetype"));


if("1".equals(type)&&(upgradeStatus != 0 || pagestatus == 3 || pagestatus == 2)) {//
	url = "/jsp/processSql.jsp";
	navName = SystemEnv.getHtmlLabelName(17530,user.getLanguage());
	processSql = true;
}


      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print(( MouldIDConst.getID("integration")));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((navName));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((type ));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((processSql ));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((SystemEnv.getHtmlLabelName(589,user.getLanguage())));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((classbeanbak));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((upgradetype));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((upgradeStatus));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      
if("1".equals(type)||"2".equals(type)||"".equals(type)) {

      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((url));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      }
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((url ));
      out.write(_jsp_string18, 0, _jsp_string18.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("jsp/index.jsp"), -9165327676396708424L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("jsp/systeminfo/init_wev8.jsp"), -2069432776849156148L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string18;
  private final static char []_jsp_string1;
  private final static char []_jsp_string16;
  private final static char []_jsp_string2;
  private final static char []_jsp_string15;
  private final static char []_jsp_string10;
  private final static char []_jsp_string8;
  private final static char []_jsp_string12;
  private final static char []_jsp_string9;
  private final static char []_jsp_string14;
  private final static char []_jsp_string6;
  private final static char []_jsp_string5;
  private final static char []_jsp_string7;
  private final static char []_jsp_string13;
  private final static char []_jsp_string4;
  private final static char []_jsp_string3;
  private final static char []_jsp_string0;
  private final static char []_jsp_string11;
  private final static char []_jsp_string17;
  static {
    _jsp_string18 = "\" class=\"flowFrame\" frameborder=\"0\" height=\"100%\" width=\"100%;\"></iframe>	\r\n</body>\r\n</html>".toCharArray();
    _jsp_string1 = "\r\n\r\n<script type=\"text/javascript\" src=\"/js/select/script/jquery-1.8.3.min_wev8.js\"></script>	\r\n\r\n<script language=\"javascript\" type=\"text/javascript\" src=\"/FCKEditor/swfobject_wev8.js\"></script>\r\n<script type=\"text/javascript\" src=\"/js/jquery.table_wev8.js\"></script>\r\n<script language=\"javascript\" type=\"text/javascript\" src=\"/js/init_wev8.js\"></script>\r\n<script language=\"javascript\"  src=\"/js/wbusb_wev8.js\"></script>\r\n<script type=\"text/javascript\" src=\"/js/jquery/plugins/client/jquery.client_wev8.js\"></script>\r\n<script type=\"text/javascript\" src=\"/js/ecology8/jNice/jNice/jquery.jNice_wev8.js\"></script>\r\n<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>\r\n<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>\r\n<script language=javascript src=\"/wui/theme/ecology8/jquery/js/zDialog_wev8.js\"></script>\r\n<script type=\"text/javascript\" src=\"/js/ecology8/request/hoverBtn_wev8.js\"></script>\r\n<script type=\"text/javascript\" src=\"/js/ecology8/lang/weaver_lang_".toCharArray();
    _jsp_string16 = "',\r\n		error : function(res,status){\r\n			$(\"#iframe1\").attr(\"src\",\"/jsp/message.jsp?errortype=3\");\r\n		}\r\n	});\r\n\r\n});\r\n".toCharArray();
    _jsp_string2 = "_wev8.js\"></script>\r\n<!-- init.css, \u6240\u6709css\u6587\u4ef6\u90fd\u5728\u6b64\u6587\u4ef6\u4e2d\u5f15\u5165 -->\r\n<link rel=\"stylesheet\" href=\"/css/init_wev8.css\" type=\"text/css\" />\r\n<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology8/skins/default/wui_wev8.css'/>\r\n<script type=\"text/javascript\" src=\"/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js\"></script>\r\n<script language=\"javascript\">\r\njQuery(document).ready(function(){\r\n	wuiform.init();\r\n});\r\n</script>\r\n \r\n".toCharArray();
    _jsp_string15 = "\r\n$(\"document\").ready(function(){\r\n	$.ajax({\r\n		url:'".toCharArray();
    _jsp_string10 = "\";\r\n	if(processSql == \"false\") {\r\n	 	$.get('/checkProcess.do',function(res){\r\n			  //var backuppath = $(\"#backuppath\").val();\r\n			 var checkpro = res.checkProcess;\r\n			\r\n	     	  if(checkpro == \"0\"||checkpro == \"1\"||checkpro == \"2\") {\r\n	     		 $(\"#iframe1\").attr(\"src\",\"/jsp/check.jsp?checkpro=\"+checkpro);\r\n	     	  }\r\n		});	\r\n	 	\r\n	 	$.get('/getProcess.do',function(res){\r\n	 		 var pro = res.progress;\r\n 			 var backuppath = res.backuppath;\r\n	     	  if(\"\"!=pro&&\"0\"!=pro&&undefined!=pro&&(type==\"1\"||type==\"2\")) {\r\n	     		  $(\"#iframe1\").attr(\"src\",\"/jsp/upgradefiles.jsp?process=\"+pro+\"&backuppath=\"+backuppath);\r\n	     		  $(\"#objName\").val(\"".toCharArray();
    _jsp_string8 = "\"\r\n    });\r\n}); \r\n\r\n$(\"document\").ready(function(){\r\n	var type = \"".toCharArray();
    _jsp_string12 = "\";\r\n	  		var upgradetype = \"".toCharArray();
    _jsp_string9 = "\";\r\n	var processSql = \"".toCharArray();
    _jsp_string14 = "\";\r\n	  		//\u6587\u4ef6\u5907\u4efd\u8986\u76d6\u5b8c\u6210  \u811a\u672c\u6267\u884c\u5b8c\u6210\r\n	  		if(pro==\"0\"&&upgradeStatus==\"0\"&&\"\"!=classbeanbak&&\"1\"==upgradetype) {\r\n	  			 $(\"#iframe1\").attr(\"src\",\"/jsp/upgradesuccess.jsp\");\r\n	  		}\r\n		});\r\n\r\n	}\r\n});\r\n".toCharArray();
    _jsp_string6 = "\r\n<script type=\"text/javascript\">\r\n$(function(){\r\n    $('.e8_box').Tabs({\r\n        getLine:1,\r\n        iframe:\"iframe1\",\r\n        mouldID:\"".toCharArray();
    _jsp_string5 = "';\r\n	</script>\r\n	<script type=\"text/javascript\" src=\"/js/updateclient/index.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/wui/common/jquery/jquery.min_wev8.js\"></script>\r\n	<script src=\"/js/tabs/jquery.tabs.extend_wev8.js\"></script>\r\n<link type=\"text/css\" href=\"/js/tabs/css/e8tabs1_wev8.css\" rel=\"stylesheet\" />\r\n<link rel=\"stylesheet\" href=\"/css/ecology8/request/searchInput_wev8.css\" type=\"text/css\" />\r\n<script type=\"text/javascript\" src=\"/js/ecology8/request/searchInput_wev8.js\"></script>\r\n\r\n<link rel=\"stylesheet\" href=\"/css/ecology8/request/seachBody_wev8.css\" type=\"text/css\" />\r\n<link rel=\"stylesheet\" href=\"/css/ecology8/request/hoverBtn_wev8.css\" type=\"text/css\" />\r\n<script type=\"text/javascript\" src=\"/js/ecology8/request/hoverBtn_wev8.js\"></script>\r\n<script type=\"text/javascript\" src=\"/js/ecology8/request/titleCommon_wev8.js\"></script>\r\n".toCharArray();
    _jsp_string7 = "\",\r\n        staticOnLoad:true,\r\n        notRefreshIfrm:true,\r\n        objName:\"".toCharArray();
    _jsp_string13 = "\";\r\n	  		var upgradeStatus = \"".toCharArray();
    _jsp_string4 = "\r\n<html>\r\n <head>\r\n \r\n	<title> E-cology\u5347\u7ea7\u7a0b\u5e8f</title>\r\n\r\n	<SCRIPT language=\"javascript\" src=\"/js/weaver_wev8.js\"></script>\r\n	<script type=\"text/javascript\">\r\n	var operation = '".toCharArray();
    _jsp_string3 = "\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n<!DOCTYPE HTML>\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string11 = "\");\r\n	     	  }\r\n	     	  \r\n	  		//\u5347\u7ea7\u6210\u529f\u9875\u9762\r\n	  		var classbeanbak = \"".toCharArray();
    _jsp_string17 = "\r\n</script>\r\n </head>\r\n\r\n<body style=\"height:100%;width:100%;\">\r\n<iframe id=\"iframe1\" name=\"iframe1\" src=\"".toCharArray();
  }
}
