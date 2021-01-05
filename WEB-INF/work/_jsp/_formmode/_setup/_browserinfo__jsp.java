/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._setup;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.formmode.service.BrowserInfoService;
import weaver.formmode.service.LogService;
import weaver.formmode.Module;
import java.util.*;
import weaver.general.Util;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;
import weaver.systeminfo.SystemEnv;
import weaver.formmode.ThreadLocalUser;
import weaver.systeminfo.systemright.CheckSubCompanyRight;
import java.io.IOException;

public class _browserinfo__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  private Map getCheckRightSubCompanyParam(String userRightStr,User user,String fmdetachable,int subCompanyId,String subCompanyIdName,
  	HttpServletRequest request,HttpServletResponse response,HttpSession session){
  	int operatelevel=0;
  	Map map = new HashMap();
  	if(subCompanyIdName.equals("")){
  		subCompanyIdName = "subCompanyId";
  	}
  	
  	if(fmdetachable.equals("1")){  
  		if(subCompanyId==-1){
  		    if(request.getParameter(subCompanyIdName)==null){
  		        subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
  		    }else{
  		        subCompanyId=Util.getIntValue(request.getParameter(subCompanyIdName),-1);
  		    }
  		    if(subCompanyId == -1){
  		        subCompanyId = user.getUserSubCompany1();
  		    }
  		}
  	    CheckSubCompanyRight CheckSubCompanyRight = new CheckSubCompanyRight();
  	    operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),userRightStr,subCompanyId);
  	    if(operatelevel>=0){
  		    session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
  	    }
  	}else{
  	    if(HrmUserVarify.checkUserRight(userRightStr, user)){
  	        operatelevel=2;
  	    }
  	}
  	String currentSubCompanyId = ""+session.getAttribute("defaultSubCompanyId");
  	map.put("currentSubCompanyId",currentSubCompanyId);
  	map.put("subCompanyId",subCompanyId);
  	map.put("operatelevel",operatelevel);
  	return map;
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
    response.setContentType("text/html; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      out.write(_jsp_string0, 0, _jsp_string0.length);
      
int isIncludeToptitle = 0;
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
ThreadLocalUser.setUser(user);

      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.moduledetach.ManageDetachComInfo ManageDetachComInfo;
      ManageDetachComInfo = (weaver.hrm.moduledetach.ManageDetachComInfo) pageContext.getAttribute("ManageDetachComInfo");
      if (ManageDetachComInfo == null) {
        ManageDetachComInfo = new weaver.hrm.moduledetach.ManageDetachComInfo();
        pageContext.setAttribute("ManageDetachComInfo", ManageDetachComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.systeminfo.systemright.CheckSubCompanyRight CheckSubCompanyRight;
      CheckSubCompanyRight = (weaver.systeminfo.systemright.CheckSubCompanyRight) pageContext.getAttribute("CheckSubCompanyRight");
      if (CheckSubCompanyRight == null) {
        CheckSubCompanyRight = new weaver.systeminfo.systemright.CheckSubCompanyRight();
        pageContext.setAttribute("CheckSubCompanyRight", CheckSubCompanyRight);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.hrm.company.SubCompanyComInfo SubCompanyComInfo;
      SubCompanyComInfo = (weaver.hrm.company.SubCompanyComInfo) pageContext.getAttribute("SubCompanyComInfo");
      if (SubCompanyComInfo == null) {
        SubCompanyComInfo = new weaver.hrm.company.SubCompanyComInfo();
        pageContext.setAttribute("SubCompanyComInfo", SubCompanyComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
boolean isUseFmManageDetach=ManageDetachComInfo.isUseFmManageDetach();
String fmdetachable="0";
if(isUseFmManageDetach){
   fmdetachable="1";
   session.setAttribute("detachable","1");
   session.setAttribute("fmdetachable",fmdetachable);
   session.setAttribute("fmdftsubcomid",ManageDetachComInfo.getFmdftsubcomid());
}else{
   fmdetachable="0";
   session.setAttribute("detachable","0");
   session.setAttribute("fmdetachable",fmdetachable);
   session.setAttribute("fmdftsubcomid","0");
}

      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((user.getLanguage()));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(15097,user.getLanguage())));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((SystemEnv.getHtmlLabelName(22161,user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((SystemEnv.getHtmlLabelName(15859,user.getLanguage())));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
	if (!HrmUserVarify.checkUserRight("FORMMODEAPP:All", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

      out.write(_jsp_string2, 0, _jsp_string2.length);
      
int browserId = Util.getIntValue(request.getParameter("id"), 0);
int appid = Util.getIntValue(request.getParameter("appid"), 0);
String customname = "";
String customdesc = "";
BrowserInfoService browserInfoService = new BrowserInfoService();
if(browserId!=0){
	Map<String,Object> map=browserInfoService.getBrowserInfoById(browserId);
	if(map.size()>0){
		customname = Util.toScreen(Util.null2String(map.get("customname")),user.getLanguage());
		customdesc = Util.toScreen(Util.null2String(map.get("customdesc")),user.getLanguage());
	}
}

boolean hasTitleField = false;
if(browserId!=0){
	String sql = "select b.fieldname from mode_CustomBrowserDspField a,workflow_billfield b where a.fieldid = b.id and a.customid = "+browserId+" and (a.istitle = '1' or a.istitle='2')";
	rs.executeSql(sql);
	if(rs.next()){
		hasTitleField = true;
	}
}

      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((SystemEnv.getHtmlLabelName(32306,user.getLanguage())));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((customname));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      LogService logService = new LogService(); 
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((SystemEnv.getHtmlLabelName(82013,user.getLanguage())));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((logService.getLastOptTime(browserId, Module.BROWSER) ));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((SystemEnv.getHtmlLabelName(81990,user.getLanguage())));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      if(browserId>0){ 
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((SystemEnv.getHtmlLabelName(16503,user.getLanguage())));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((SystemEnv.getHtmlLabelName(82029,user.getLanguage())));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((SystemEnv.getHtmlLabelName(83,user.getLanguage())));
      out.write(_jsp_string18, 0, _jsp_string18.length);
      }
      out.write(_jsp_string19, 0, _jsp_string19.length);
      out.print((appid ));
      out.write(_jsp_string20, 0, _jsp_string20.length);
      out.print((browserId ));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      if(browserId>0){ 
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((browserId ));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((browserId));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((Module.BROWSER ));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      out.print((browserId));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      }
      out.write(_jsp_string26, 0, _jsp_string26.length);
      out.print((hasTitleField));
      out.write(_jsp_string27, 0, _jsp_string27.length);
      out.print((browserId));
      out.write(_jsp_string28, 0, _jsp_string28.length);
      out.print((SystemEnv.getHtmlLabelName(28625,user.getLanguage())));
      out.write(_jsp_string29, 0, _jsp_string29.length);
      out.print((SystemEnv.getHtmlLabelName(82031,user.getLanguage())));
      out.write(_jsp_string30, 0, _jsp_string30.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/setup/browserInfo.jsp"), -928314952105658572L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/pub.jsp"), -792240692296315271L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/pub_init.jsp"), -4246916824298514572L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/pub_function.jsp"), 5446055981984630656L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string16;
  private final static char []_jsp_string25;
  private final static char []_jsp_string3;
  private final static char []_jsp_string24;
  private final static char []_jsp_string14;
  private final static char []_jsp_string21;
  private final static char []_jsp_string18;
  private final static char []_jsp_string30;
  private final static char []_jsp_string26;
  private final static char []_jsp_string20;
  private final static char []_jsp_string7;
  private final static char []_jsp_string0;
  private final static char []_jsp_string19;
  private final static char []_jsp_string23;
  private final static char []_jsp_string12;
  private final static char []_jsp_string6;
  private final static char []_jsp_string27;
  private final static char []_jsp_string5;
  private final static char []_jsp_string8;
  private final static char []_jsp_string11;
  private final static char []_jsp_string13;
  private final static char []_jsp_string1;
  private final static char []_jsp_string10;
  private final static char []_jsp_string29;
  private final static char []_jsp_string17;
  private final static char []_jsp_string2;
  private final static char []_jsp_string4;
  private final static char []_jsp_string28;
  private final static char []_jsp_string15;
  private final static char []_jsp_string9;
  private final static char []_jsp_string22;
  static {
    _jsp_string16 = "</a></li><!-- \u5b57\u6bb5\u5b9a\u4e49 -->\r\n				<li href=\"#tabs-content-4\"><a>".toCharArray();
    _jsp_string25 = "\">\r\n					\r\n			</iframe>\r\n		</div>\r\n		<div id=\"tabs-content-4\" class=\"e8_right_frameContainer\">\r\n			<iframe id=\"listFrame\" name=\"listFrame\" frameborder=\"0\" style=\"width: 100%;height: 100%;\" scrolling=\"auto\" lazy-src=\"/formmode/setup/browserList.jsp?objid=".toCharArray();
    _jsp_string3 = "\r\n\r\n\r\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\r\n<html>\r\n<head>\r\n	<script type=\"text/javascript\" src=\"/formmode/js/jquery/jquery-1.8.3.min_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/formmode/js/FormmodeUtil_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/js/weaver_wev8.js\"></script>\r\n	<LINK type=\"text/css\" rel=\"stylesheet\" href=\"/css/Weaver_wev8.css\" />	<!-- for right menu -->\r\n	\r\n	<link type=\"text/css\" rel=\"stylesheet\" href=\"/js/ecology8/jNice/jNice/jNice_wev8.css\"/>\r\n	<script type=\"text/javascript\" src=\"/js/ecology8/jNice/jNice/jquery.jNice_wev8.js\"></script>\r\n	\r\n	<script language=\"javascript\" type=\"text/javascript\" src=\"/js/init_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/js/ecology8/lang/weaver_lang_".toCharArray();
    _jsp_string24 = "&logmodule=".toCharArray();
    _jsp_string14 = "</a></li><!-- \u57fa\u7840 -->\r\n				".toCharArray();
    _jsp_string21 = "\">\r\n					\r\n			</iframe>\r\n		</div>\r\n		".toCharArray();
    _jsp_string18 = "</a></li><!-- \u65e5\u5fd7 -->\r\n				".toCharArray();
    _jsp_string30 = "\");//\u8bf7\u5148\u4e3a\u6d4f\u89c8\u6846\u8bbe\u7f6e\u94fe\u63a5\u5b57\u6bb5\uff01\r\n	}\r\n}\r\n</script>\r\n</body>\r\n</html>\r\n".toCharArray();
    _jsp_string26 = "\r\n	</div>\r\n\r\n<script type=\"text/javascript\">\r\nfunction createbrowser(){\r\n	if(".toCharArray();
    _jsp_string20 = "&id=".toCharArray();
    _jsp_string7 = "\",function(){displayAllmenu();});//\u5fc5\u8981\u4fe1\u606f\u4e0d\u5b8c\u6574\uff01\r\n				return false;\r\n			}\r\n		}\r\n		return true;\r\n    }\r\n	</script>\r\n</head>\r\n	\r\n</html>\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string19 = "\r\n			</ul>\r\n		</div>\r\n	</div>\r\n	\r\n	<div class=\"e8_right_center\">\r\n		<div id=\"tabs-content-1\" class=\"e8_right_frameContainer\">\r\n			<iframe frameborder=\"0\" style=\"width: 100%;height: 100%;\" scrolling=\"auto\" lazy-src=\"/formmode/setup/browserBase.jsp?appid=".toCharArray();
    _jsp_string23 = "\">\r\n					\r\n			</iframe>\r\n		</div>\r\n		<div id=\"tabs-content-3\" class=\"e8_right_frameContainer\">\r\n			<iframe id=\"logFrame\" name=\"logFrame\" frameborder=\"0\" style=\"width: 100%;height: 100%;\" scrolling=\"auto\" lazy-src=\"/formmode/setup/log.jsp?objid=".toCharArray();
    _jsp_string12 = " \uff1a".toCharArray();
    _jsp_string6 = "\";//\u786e\u5b9a\u8981\u63d0\u4ea4\u5417?\r\n     if(!confirm(str)){\r\n       return false;\r\n     }\r\n       return true;\r\n   } \r\n   \r\n   function checkFieldValue(ids){\r\n		var idsArr = ids.split(\",\");\r\n		for(var i=0;i<idsArr.length;i++){\r\n			var obj = document.getElementById(idsArr[i]);\r\n			if(obj&&obj.value==\"\"){\r\n				window.top.Dialog.alert(\"".toCharArray();
    _jsp_string27 = "){\r\n		var dialogurl = \"/systeminfo/BrowserMain.jsp?url=/formmode/browser/CreateBrowser.jsp?customid=".toCharArray();
    _jsp_string5 = "\";//\u786e\u5b9a\u8981\u5220\u9664\u5417?\r\n      if(!confirm(str)){\r\n        return false;\r\n      }\r\n        return true;\r\n    } \r\n\r\n   function issubmit(){\r\n	 var str = \"".toCharArray();
    _jsp_string8 = "\r\n<html>\r\n<head>\r\n	<title></title>\r\n	<link rel=\"stylesheet\" type=\"text/css\" href=\"/formmode/js/ext/resources/css/ext-all_wev8.css\" />\r\n	<script type=\"text/javascript\" src=\"/formmode/js/ext/adapter/ext/ext-base_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/formmode/js/ext/ext-all_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/formmode/js/ext/ux/miframe_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/formmode/js/jquery/simpleTabs/simpleTabs_wev8.js\"></script>\r\n	\r\n	<style type=\"text/css\">\r\n		* {font:12px Microsoft YaHei}\r\n		html,body{\r\n			height: 100%;\r\n			margin: 0px;\r\n			padding: 0px 0 0 2px;\r\n		}\r\n		.e8_right_top{\r\n			padding: 13px 10px 0px 10px;\r\n			position: relative;\r\n		}\r\n		.e8_right_top .e8_baseinfo{\r\n			border-bottom: 1px solid #E9E9E9;\r\n			padding-bottom: 16px;\r\n		}\r\n		.e8_right_top .e8_baseinfo_name{\r\n			font-size: 18px;\r\n			color: #333;\r\n		}\r\n		.e8_right_top .e8_baseinfo_modify{\r\n			font-size: 12px;\r\n			color: #AFAFAF;\r\n		}\r\n		.e8_right_top ul{\r\n			list-style: none;\r\n			position: absolute;\r\n			right: 20px;\r\n			bottom: 15px;\r\n		}\r\n		.e8_right_top ul li{\r\n			float: left;\r\n			padding: 0px 5px;\r\n		}\r\n		.e8_right_top ul li a{\r\n			display: block;\r\n			font-size: 15px;\r\n			color: #A3A3A3;\r\n			padding: 1px;\r\n			text-decoration: none;\r\n			cursor: pointer;\r\n			border-bottom: 2px solid #fff;\r\n		}\r\n		.e8_right_top ul li.selected a{\r\n			color: #0072C6;		\r\n			border-bottom: 2px solid #0072C6;\r\n		}\r\n		.e8_right_center{\r\n			overflow: hidden;\r\n			padding: 0px 10px;\r\n		}\r\n		.e8_right_center .e8_right_frameContainer{\r\n			display: none;\r\n			height: 100%;\r\n		}\r\n	</style>\r\n	<script type=\"text/javascript\">\r\n		\r\n		$(document).ready(function () {\r\n			$(window).resize(forPageResize);\r\n			forPageResize();\r\n			\r\n			$(\".e8_right_tabs\").simpleTabs();\r\n		});\r\n		\r\n		function forPageResize(){\r\n			var $body = $(document.body);\r\n			var $e8_right_top = $(\".e8_right_top\");\r\n			var $e8_right_center = $(\".e8_right_center\");\r\n			\r\n			var centerHeight = $body.height() - $e8_right_top.outerHeight(true);\r\n			\r\n			$e8_right_center.height(centerHeight);\r\n		}\r\n	</script>\r\n</head>\r\n  \r\n<body>\r\n	<div class=\"e8_right_top\">\r\n		<div style=\"width:40px;float:left;margin:2px 10px 0 0;\"><img src=\"/formmode/images/browserIconRounded_wev8.png\" /></div>\r\n		<div class=\"e8_baseinfo\">\r\n			<div class=\"e8_baseinfo_name\">\r\n				".toCharArray();
    _jsp_string11 = "\r\n				".toCharArray();
    _jsp_string13 = "<!-- \u6700\u540e\u7f16\u8f91\u65f6\u95f4 -->\r\n			</div>\r\n		</div>\r\n		<div class=\"e8_right_tabs\">\r\n			<ul>\r\n				<li href=\"#tabs-content-1\" defaultSelected=\"true\"><a>".toCharArray();
    _jsp_string1 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string10 = "<!-- \u6d4f\u89c8\u6846 -->\r\n			</div>\r\n			<div class=\"e8_baseinfo_modify\">\r\n				".toCharArray();
    _jsp_string29 = "\";//\u521b\u5efa\u6d4f\u89c8\u6846\r\n		dialog.Width = 550 ;\r\n		dialog.Height = 550;\r\n		dialog.Drag = true;\r\n		dialog.show();\r\n	}else{\r\n		Dialog.alert(\"".toCharArray();
    _jsp_string17 = "</a></li><!-- \u6d4f\u89c8\u6846\u5217\u8868 -->\r\n				<li href=\"#tabs-content-3\"><a>".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
    _jsp_string4 = "_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/wui/theme/ecology8/jquery/js/zDialog_wev8.js\"></script>\r\n	\r\n	\r\n	<LINK type=\"text/css\" rel=\"stylesheet\" href=\"/formmode/css/pub_wev8.css?d=20140616\" />\r\n	<script type=\"text/javascript\" >\r\n	function isdel(){\r\n	  var str = \"".toCharArray();
    _jsp_string28 = "\";\r\n		var dialog = new window.top.Dialog();\r\n		dialog.currentWindow = window;\r\n		dialog.URL = dialogurl;\r\n		dialog.callbackfun = function (paramobj, id1) {\r\n			\r\n		} ;\r\n		dialog.Title = \"".toCharArray();
    _jsp_string15 = "\r\n				<li href=\"#tabs-content-2\"><a>".toCharArray();
    _jsp_string9 = " / ".toCharArray();
    _jsp_string22 = "\r\n		<div id=\"tabs-content-2\" class=\"e8_right_frameContainer\">\r\n			<iframe frameborder=\"0\" style=\"width: 100%;height: 100%;\" scrolling=\"no\" lazy-src=\"/formmode/setup/browserField.jsp?id=".toCharArray();
  }
}