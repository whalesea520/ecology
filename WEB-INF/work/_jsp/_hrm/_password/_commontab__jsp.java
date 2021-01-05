/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._hrm._password;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.hrm.common.*;
import weaver.general.MouldIDConst;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.*;
import ln.LN;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.systeminfo.template.UserTemplate;
import weaver.systeminfo.setting.*;

public class _commontab__jsp extends com.caucho.jsp.JavaPage
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
       // \u589e\u52a0\u53c2\u6570\u5224\u65ad\u7f13\u5b58 
			int isIncludeToptitle = 0;
			response.setHeader("cache-control", "no-cache");
			response.setHeader("pragma", "no-cache");
			response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT"); 
		
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.general.ParameterPackage pack;
      pack = (weaver.general.ParameterPackage) pageContext.getAttribute("pack");
      if (pack == null) {
        pack = new weaver.general.ParameterPackage();
        pageContext.setAttribute("pack", pack);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
	HashMap<String,String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String fromUrl = Tools.vString(kv.get("fromUrl"));
	int languageid = Tools.parseToInt(kv.get("languageid"),7);
	String cmd = Tools.vString(kv.get("cmd"));
	String id = Tools.vString(kv.get("id"));
	String mouldid = "resource";

      out.write(_jsp_string3, 0, _jsp_string3.length);
      
			String title = "";
			String url = "";
			if("forgotPassword".equals(fromUrl)){
				title = SystemEnv.getHtmlLabelName(83510, languageid);
				url = "/hrm/password/forgotPassword.jsp?languageid="+languageid;
			} else if ("resetPassword".equals(fromUrl)){
				title = SystemEnv.getHtmlLabelName(31479, languageid);
				String loginid = Tools.vString(kv.get("loginid"));
				url = "/hrm/password/resetPassword.jsp?loginid="+loginid;
			} else if("hrmResourcePassword".equals(fromUrl)){
				title = SystemEnv.getHtmlLabelName(17993, languageid);
				String redirectFile = Tools.vString(kv.get("RedirectFile"));
				String canpass = Tools.vString(kv.get("canpass"));
				String showClose = Tools.vString(kv.get("showClose"));
				url = "/hrm/resource/HrmResourcePassword.jsp?isdialog=1&frompage=/login/RemindLogin.jsp&canpass="+canpass+"&RedirectFile="+redirectFile+"&showClose="+showClose;
			}
		
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((MouldIDConst.getID(mouldid)));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((title));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((url ));
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("hrm/password/commonTab.jsp"), -3338769806261678515L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("systeminfo/nlinit.jsp"), 1705609848119212532L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string4;
  private final static char []_jsp_string7;
  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  private final static char []_jsp_string3;
  private final static char []_jsp_string6;
  private final static char []_jsp_string2;
  private final static char []_jsp_string5;
  static {
    _jsp_string4 = "\r\n		<script type=\"text/javascript\">\r\n			jQuery(function(){\r\n				jQuery('.e8_box').Tabs({\r\n					getLine:1,\r\n					iframe:\"tabcontentframe\",\r\n					mouldID:\"".toCharArray();
    _jsp_string7 = "\" onload=\"update();\" id=\"tabcontentframe\" name=\"tabcontentframe\" class=\"flowFrame\" frameborder=\"0\" height=\"100%\" width=\"100%;\"></iframe>\r\n				</div>\r\n			</div>\r\n		</div>\r\n	</body>\r\n</html>\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n		<meta http-equiv=Content-Type content=\"text/html; charset=UTF-8\">\r\n		<script type=\"text/javascript\" src=\"/wui/common/jquery/jquery.min_wev8.js\"></script>\r\n		<script language=\"javascript\" type=\"text/javascript\"\r\n			src=\"/FCKEditor/swfobject_wev8.js\"></script>\r\n		<!-- IE\u4e0b\u4e13\u7528vbs\uff08\u4e34\u65f6\uff09 -->\r\n		<script language=\"vbs\" src=\"/js/string2VbArray.vbs\"></script>\r\n		<!-- js \u6574\u5408\u5230 init_wev8.js -->\r\n		<script language=\"javascript\" type=\"text/javascript\" src=\"/js/init_wev8.js\"></script>\r\n		<script language=\"javascript\" src=\"/js/wbusb_wev8.js\"></script>\r\n		<script type=\"text/javascript\" src=\"/js/jquery/plugins/client/jquery.client_wev8.js\"></script>\r\n		<script type=\"text/javascript\" src=\"/js/ecology8/jNice/jNice/jquery.jNice_wev8.js\"></script>\r\n\r\n\r\n		<script type=\"text/javascript\" src=\"/js/ecology8/wTooltip/wTooltip_wev8.js\"></script>\r\n		<script type=\"text/javascript\" src=\"/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js\"></script>\r\n		<script type=\"text/javascript\" src=\"/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js\"></script>\r\n\r\n		<script type=\"text/javascript\" src=\"/js/ecology8/browserCommon_wev8.js\"></script>\r\n		<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>\r\n		<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>\r\n		<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>\r\n		<script language=javascript src=\"/wui/theme/ecology8/jquery/js/zDialog_wev8.js\"></script>\r\n		<script language=javascript src=\"/wui/theme/ecology8/jquery/js/zDrag_wev8.js\"></script>\r\n		<script type=\"text/javascript\" src=\"/js/select/script/selectForK13_wev8.js\"></script>\r\n\r\n		<!--radio\u7f8e\u5316\u6846-->\r\n		<script language=javascript src=\"/js/checkbox/jquery.tzRadio_wev8.js\"></script>\r\n		<script language=javascript src=\"/js/checkbox/jquery.tzCheckbox_wev8.js\"></script>\r\n\r\n\r\n		<!-- \u4e0b\u62c9\u6846\u7f8e\u5316\u7ec4\u4ef6-->\r\n		<script language=javascript src=\"/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js\"></script>\r\n\r\n		<!-- \u79fb\u9664 -->\r\n\r\n		<script type=\"text/javascript\" src=\"/js/ecology8/request/searchInput_wev8.js\"></script>\r\n\r\n		<script type=\"text/javascript\" src=\"/js/ecology8/request/hoverBtn_wev8.js\"></script>\r\n		<script type=\"text/javascript\" src=\"/js/ecology8/request/titleCommon_wev8.js\"></script>\r\n\r\n		<!-- init.css, \u6240\u6709css\u6587\u4ef6\u90fd\u5728\u6b64\u6587\u4ef6\u4e2d\u5f15\u5165 -->\r\n		<link rel=\"stylesheet\" href=\"/css/init_wev8.css\" type=\"text/css\" />\r\n		<link type=\"text/css\" rel=\"stylesheet\" href=\"/wui/theme/ecology8/templates/default/css/default_wev8.css\" />\r\n		<link type=\"text/css\" rel=\"stylesheet\" href=\"/js/tabs/css/e8tabs1_wev8.css\" />\r\n		<link type=\"text/css\" rel=\"stylesheet\" href=\"/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css\" />\r\n		<link type=\"text/css\" rel=\"stylesheet\" href=\"/wui/theme/ecology8/templates/default/css/default_wev8.css\" />\r\n\r\n		<script language=javascript>\r\n			var ieVersion = 6;//ie\u7248\u672c\r\n			\r\n			jQuery(document).ready(function(){\r\n				jQuery(\".addbtn\").hover(function(){\r\n					jQuery(this).addClass(\"addbtn2\");\r\n				},function(){\r\n					jQuery(this).removeClass(\"addbtn2\");\r\n				});\r\n				\r\n				jQuery(\".delbtn\").hover(function(){\r\n					jQuery(this).addClass(\"delbtn2\");\r\n				},function(){\r\n					jQuery(this).removeClass(\"delbtn2\");\r\n				});\r\n				\r\n				jQuery(\".downloadbtn\").hover(function(){\r\n					jQuery(this).addClass(\"downloadbtn2\");\r\n				},function(){\r\n					jQuery(this).removeClass(\"downloadbtn2\");\r\n				});\r\n				var isNewPlugisSelect = jQuery(\"#isNewPlugisSelect\");\r\n				if(isNewPlugisSelect.length>0&&isNewPlugisSelect.val()!=\"1\"){\r\n					// do nothing\r\n				}else{\r\n					beautySelect();\r\n				}\r\n				\r\n				jQuery(\"input[type=checkbox]\").each(function(){\r\n					if(jQuery(this).attr(\"tzCheckbox\")==\"true\"){\r\n						jQuery(this).tzCheckbox({labels:['','']});\r\n					}\r\n				});\r\n				\r\n				jQuery(window).resize(function(){\r\n					resizeDialog();\r\n				});\r\n				\r\n			});\r\n			/**\r\n			*\u6e05\u7a7a\u641c\u7d22\u6761\u4ef6\r\n			*/\r\n			function resetCondtion(selector){\r\n				resetCondition(selector);\r\n			}\r\n			\r\n			function resetCondition(selector){\r\n				if(!selector)selector=\"#advancedSearchDiv\";\r\n				//\u6e05\u7a7a\u6587\u672c\u6846\r\n				jQuery(selector).find(\"input[type='text']\").val(\"\");\r\n				//\u6e05\u7a7a\u6d4f\u89c8\u6309\u94ae\u53ca\u5bf9\u5e94\u9690\u85cf\u57df\r\n				jQuery(selector).find(\".e8_os\").find(\"span.e8_showNameClass\").remove();\r\n				jQuery(selector).find(\".e8_os\").find(\"input[type='hidden']\").val(\"\");\r\n				//\u6e05\u7a7a\u4e0b\u62c9\u6846\r\n				jQuery(selector).find(\"select\").selectbox(\"detach\");\r\n				jQuery(selector).find(\"select\").val(\"\");\r\n				jQuery(selector).find(\"select\").trigger(\"change\");\r\n				beautySelect(jQuery(selector).find(\"select\"));\r\n				//\u6e05\u7a7a\u65e5\u671f\r\n				jQuery(selector).find(\".calendar\").siblings(\"span\").html(\"\");\r\n				jQuery(selector).find(\".calendar\").siblings(\"input[type='hidden']\").val(\"\");\r\n				\r\n				jQuery(selector).find(\"input[type='checkbox']\").each(function(){\r\n					changeCheckboxStatus(this,false);\r\n				});\r\n			}\r\n			\r\n			function resizeDialog(_document){\r\n				if(!_document)_document = document;\r\n				var bodyheight = jQuery(window).height();//_document.body.offsetHeight;\r\n				var bottomheight = jQuery(\".zDialog_div_bottom\").css(\"height\");\r\n				var paddingBottom = jQuery(\".zDialog_div_bottom\").css(\"padding-bottom\");\r\n				var paddingTop = jQuery(\".zDialog_div_bottom\").css(\"padding-top\");\r\n				var headHeight = 0;\r\n				var e8Box = jQuery(\".zDialog_div_content\").closest(\".e8_box\");\r\n				if(e8Box.length>0){\r\n					headHeight = e8Box.children(\".e8_boxhead\").height();\r\n				}\r\n				if(!!bottomheight && bottomheight.indexOf(\"px\")>0){\r\n					bottomheight = bottomheight.substring(0,bottomheight.indexOf(\"px\"));\r\n				}\r\n				if(!!paddingBottom && paddingBottom.indexOf(\"px\")>0){\r\n					paddingBottom = paddingBottom.substring(0,paddingBottom.indexOf(\"px\"));\r\n				}\r\n				if(!!paddingTop && paddingTop.indexOf(\"px\")>0){\r\n					paddingTop = paddingTop.substring(0,paddingTop.indexOf(\"px\"));\r\n				}\r\n				if(isNaN(bottomheight)){\r\n					bottomheight = 0;\r\n				}else{\r\n					bottomheight = parseInt(bottomheight);\r\n				}\r\n				if(isNaN(paddingBottom)){\r\n					paddingBottom = 0;\r\n				}else{\r\n					paddingBottom = parseInt(paddingBottom);\r\n				}\r\n				if(isNaN(paddingTop)){\r\n					paddingTop = 0;\r\n				}else{\r\n					paddingTop = parseInt(paddingTop);\r\n				}\r\n				if(document.documentMode!=5){\r\n					jQuery(\".zDialog_div_content\").css(\"height\",bodyheight-bottomheight-paddingTop-headHeight-7);\r\n				}else{\r\n					jQuery(\".zDialog_div_content\").css(\"height\",bodyheight-bottomheight-paddingBottom-paddingTop-headHeight-7);\r\n				}\r\n			}\r\n		</script>\r\n	</head>\r\n</html>\r\n<!--For wui-->\r\n<link type='text/css' rel='stylesheet' href='/wui/theme/ecology8/skins/default/wui_wev8.css' />\r\n\r\n<!-- \u5b57\u4f53\u8bbe\u7f6e\uff0cwin7\u3001vista\u7cfb\u7edf\u4f7f\u7528\u96c5\u9ed1\u5b57\u4f53,\u5176\u4ed6\u7cfb\u7edf\u4f7f\u7528\u5b8b\u4f53 Start -->\r\n<link type='text/css' rel='stylesheet' href='/wui/common/css/w7OVFont_wev8.css' id=\"FONT2SYSTEMF\">\r\n<script language=\"javascript\"> \r\n/*\r\nif (jQuery.client.version< 6) {\r\n	document.getElementById('FONT2SYSTEMF').href = \"/wui/common/css/notW7AVFont_wev8.css\";\r\n}\r\n*/\r\n</script>\r\n<!-- \u5b57\u4f53\u8bbe\u7f6e\uff0cwin7\u3001vista\u7cfb\u7edf\u4f7f\u7528\u96c5\u9ed1\u5b57\u4f53,\u5176\u4ed6\u7cfb\u7edf\u4f7f\u7528\u5b8b\u4f53 End -->\r\n<script language=\"javascript\">\r\n//------------------------------\r\n// the folder of current skins \r\n//------------------------------\r\n//\u5f53\u524d\u4f7f\u7528\u7684\u4e3b\u9898\r\nvar GLOBAL_CURRENT_THEME = \"ecology8\";\r\n//\u5f53\u524d\u4e3b\u9898\u4f7f\u7528\u7684\u76ae\u80a4\r\nvar GLOBAL_SKINS_FOLDER = \"default\";\r\n</script>\r\n\r\n<!--For wuiForm-->\r\n<script type=\"text/javascript\" src=\"/wui/common/jquery/plugin/wuiform/jquery.wuiform_wev8.js\"></script>\r\n<script language=\"javascript\">\r\njQuery(document).ready(function(){\r\n	wuiform.init();\r\n});\r\n</script>\r\n<!-- Added by wcd 2014-12-18 -->\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n<!DOCTYPE HTML>\r\n<!-- Added by wcd 2014-12-18 -->\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n<html>\r\n	<head>\r\n		<style type=\"text/css\">\r\n			html{height:100%;}\r\n		</style>\r\n		".toCharArray();
    _jsp_string3 = "\r\n<HTML>\r\n	<HEAD>\r\n		<script src=\"/js/tabs/jquery.tabs.extend_wev8.js\"></script>\r\n		<link type=\"text/css\" href=\"/js/tabs/css/e8tabs1_wev8.css\" rel=\"stylesheet\" />\r\n		<link rel=\"stylesheet\" href=\"/css/ecology8/request/searchInput_wev8.css\" type=\"text/css\" />\r\n		<script type=\"text/javascript\" src=\"/js/ecology8/request/searchInput_wev8.js\"></script>\r\n		<link rel=\"stylesheet\" href=\"/css/ecology8/request/seachBody_wev8.css\" type=\"text/css\" />\r\n		<link rel=\"stylesheet\" href=\"/css/ecology8/request/hoverBtn_wev8.css\" type=\"text/css\" />\r\n		<script type=\"text/javascript\" src=\"/js/ecology8/request/hoverBtn_wev8.js\"></script>\r\n		<script type=\"text/javascript\" src=\"/js/ecology8/request/titleCommon_wev8.js\"></script>\r\n\r\n		<script type=\"text/javascript\">\r\n		function refreshTab(){\r\n			jQuery('.flowMenusTd',parent.document).toggle();\r\n			jQuery('.leftTypeSearch',parent.document).toggle();\r\n		} \r\n		</script>\r\n		".toCharArray();
    _jsp_string6 = "\"\r\n				});\r\n			});\r\n		</script>\r\n	</head>\r\n	<BODY scroll=\"no\">\r\n		<div class=\"e8_box demo2\">\r\n			<div class=\"e8_boxhead\">\r\n				<div class=\"div_e8_xtree\" id=\"div_e8_xtree\"></div>\r\n				<div class=\"e8_tablogo\" id=\"e8_tablogo\"></div>\r\n				<div class=\"e8_ultab\">\r\n					<div class=\"e8_navtab\" id=\"e8_navtab\">\r\n						<span id=\"objName\"></span>\r\n					</div>\r\n					<div>\r\n						<ul class=\"tab_menu\"></ul>\r\n						<div id=\"rightBox\" class=\"e8_rightBox\"></div>\r\n					</div>\r\n				</div>\r\n			</div>\r\n			<div class=\"tab_box\">\r\n				<div>\r\n					<iframe src=\"".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
    _jsp_string5 = "\",\r\n					staticOnLoad:true,\r\n					objName:\"".toCharArray();
  }
}
