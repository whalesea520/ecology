/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._system;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;

public class _modifycode__jsp extends com.caucho.jsp.JavaPage
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
      
response.setHeader("cache-control", "no-cache");
response.setHeader("pragma", "no-cache");
response.setHeader("expires", "Mon 1 Jan 1990 00:00:00 GMT");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      
String message = Util.null2String(request.getParameter("message"));
String from = Util.null2String(request.getParameter("from"));

      out.write(_jsp_string2, 0, _jsp_string2.length);
       if(message.equals("1")) {
      out.write(_jsp_string3, 0, _jsp_string3.length);
      }
      out.write(_jsp_string4, 0, _jsp_string4.length);
       if(message.equals("2")) {
      out.write(_jsp_string5, 0, _jsp_string5.length);
      }
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((from.equals("db")?"/system/CreateDB.jsp":"/system/InLicense.jsp"));
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("system/ModifyCode.jsp"), 6380262453639932466L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string1;
  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  private final static char []_jsp_string5;
  private final static char []_jsp_string7;
  private final static char []_jsp_string6;
  private final static char []_jsp_string4;
  private final static char []_jsp_string3;
  static {
    _jsp_string1 = "\r\n<HTML><HEAD>\r\n<LINK href=\"/css/Weaver_wev8.css\" type=text/css rel=STYLESHEET>\r\n<SCRIPT language=\"javascript\" src=\"/js/weaver_wev8.js\"></script>\r\n<script type=\"text/javascript\" src=\"/wui/common/jquery/jquery.min_wev8.js\"></script>\r\n<script language=javascript src=\"/wui/theme/ecology8/jquery/js/zDialog_wev8.js\"></script>\r\n<script language=javascript src=\"/wui/theme/ecology8/jquery/js/zDrag_wev8.js\"></script>\r\n<link rel=\"stylesheet\" href=\"/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css\" type=\"text/css\" />\r\n<link rel=\"stylesheet\" href=\"/css/ecology8/request/seachBody_wev8.css\" type=\"text/css\" />\r\n<style type=\"text/css\">\r\n	td,input{\r\n		font-family:\"\u5fae\u8f6f\u96c5\u9ed1\",\"\u5b8b\u4f53\";\r\n	}\r\n	.e8_btn_top_first_hover{\r\n		background-color:#4393ff!important;\r\n	}\r\n</style>\r\n<script type=\"text/javascript\">\r\n	jQuery(document).ready(function(){\r\n		jQuery(\".e8_btn_top_first\").hover(function(){\r\n			jQuery(this).addClass(\"e8_btn_top_first_hover\");\r\n		},function(){\r\n			jQuery(this).removeClass(\"e8_btn_top_first_hover\");\r\n		});\r\n	});\r\n</script>\r\n</head>\r\n".toCharArray();
    _jsp_string2 = "\r\n<BODY style=\"margin:0 auto;\">\r\n\r\n<table style=\"text-align:center;margin-left:auto;margin-right:auto;\" width=\"800px\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">\r\n<colgroup>\r\n<col width=\"10\">\r\n<col width=\"\">\r\n<col width=\"10\">\r\n<tr>\r\n<td height=\"10\" colspan=\"3\"></td>\r\n</tr>\r\n<tr>\r\n<td ></td>\r\n<td valign=\"top\">\r\n<TABLE class=Shadow>\r\n<tr>\r\n<td valign=\"top\">\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string5 = "\r\n<font color=\"#FF0000\"></font>\r\n".toCharArray();
    _jsp_string7 = "'\" value=\"\u8fd4 \u56de\"></input> \r\n    	</td>\r\n    </tr>\r\n    </TBODY>\r\n    </TABLE>\r\n    </FORM>\r\n</td>\r\n</tr>\r\n</TABLE>\r\n</td>\r\n<td></td>\r\n</tr>\r\n<tr>\r\n<td height=\"10\" colspan=\"3\"></td>\r\n</tr>\r\n</table>\r\n<script language=javascript>\r\nfunction submitData() {\r\n if(checkpassword ()){\r\n frmMain.submit();\r\n }\r\n}\r\nfunction check_form(thiswins,items)\r\n{\r\n	thiswin = thiswins\r\n	items = items + \",\";\r\n\r\n	for(i=1;i<=thiswin.length;i++)\r\n	{\r\n	tmpname = thiswin.elements[i-1].name;\r\n	tmpvalue = thiswin.elements[i-1].value;\r\n    if(tmpvalue==null){\r\n        continue;\r\n    }\r\n	while(tmpvalue.indexOf(\" \") == 0)\r\n		tmpvalue = tmpvalue.substring(1,tmpvalue.length);\r\n\r\n	if(tmpname!=\"\" &&items.indexOf(tmpname+\",\")!=-1 && tmpvalue == \"\"){\r\n		 top.Dialog.alert(\"\u5fc5\u586b\u4fe1\u606f\u4e0d\u5b8c\u6574\uff01\");\r\n		 return false;\r\n		}\r\n\r\n	}\r\n	return true;\r\n}\r\n\r\nfunction checkpassword() {\r\nif(!check_form(password,\"passwordold,passwordnew,confirmpassword\"))\r\n    return false;\r\nif(password.passwordnew.value != password.confirmpassword.value) {\r\n    top.Dialog.alert(\"\u4e24\u6b21\u8f93\u5165\u7684\u65b0\u9a8c\u8bc1\u7801\u4e0d\u540c!\");\r\n    return false;\r\n}\r\nreturn true;\r\n	}\r\n	</script>\r\n	 </BODY>\r\n    </HTML>".toCharArray();
    _jsp_string6 = "\r\n<FORM id=password name=frmMain style=\"MARGIN-TOP: 3px\" action=CodeOperation.jsp method=post onsubmit=\"return checkpassword()\">\r\n<input type=hidden name=operation value=\"changecode\">\r\n<TABLE class=viewForm class=ViewForm  width=\"750px\" cellspacing=\"0\">\r\n  <COLGROUP>\r\n  <COL width=\"30%\">\r\n  <COL width=\"70%\">\r\n  <TBODY>\r\n  <TR class=title>\r\n    <TD colSpan=2 style=\"background-color:#f8f8f8;font-weight: bold;text-align:center;height:50px;color:#545454;border:1px solid #eaeaea;padding-bottom:5px;\">\r\n   		<span style=\"display:inline-block;line-height:32px;height:32px;\">\r\n   			<span style=\"display:inline-block;height:32px;line-height:32px;font-size:18px;\">\u9a8c\u8bc1\u7801\u53d8\u66f4</span>\r\n   		</span>\r\n   	</TD>\r\n    </TR>\r\n    <tr>\r\n      <TD style=\"vertical-align:bottom;font-size:14px;color:#5c5c5c;height:60px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;\">\u65e7\u9a8c\u8bc1\u7801:</TD>\r\n    <TD style=\"vertical-align:bottom;font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;\"><INPUT class=inputstyle id=passwordold type=password\r\n    name=passwordold style=\"border:1px solid #c5c5c5;width:300px;height:30px;\"  onchange='checkinput(\"passwordold\",\"passwordoldimage\")'>\r\n	<SPAN id=passwordoldimage><IMG src=\"/images/BacoError_wev8.gif\" align=absMiddle></SPAN>\r\n	</TD>\r\n    </TR>\r\n  <TR>\r\n      <TD style=\"font-size:14px;color:#5c5c5c;height:60px;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;\">\u65b0\u9a8c\u8bc1\u7801:</TD>\r\n    <TD  style=\"font-size:14px;color:#5c5c5c;border-right:1px solid #eaeaea;\"><INPUT style=\"border:1px solid #c5c5c5;width:300px;height:30px;\"  class=inputstyle id=passwordnew type=password\r\n    name=passwordnew onchange='checkinput(\"passwordnew\",\"passwordnewimage\")'>\r\n        <span id=passwordnewimage><img src=\"/images/BacoError_wev8.gif\" align=absMiddle></span></TD>\r\n    </TR>\r\n  <TR>\r\n      <TD style=\"vertical-align:top;font-size:14px;color:#5c5c5c;height:60px;border-bottom:1px solid #f4f4f4;border-left:1px solid #eaeaea;text-align:right;padding-right:30px;\">\u786e\u8ba4\u65b0\u9a8c\u8bc1\u7801:</TD>\r\n    <TD  style=\"vertical-align:top;font-size:14px;color:#5c5c5c;border-bottom:1px solid #f4f4f4;border-right:1px solid #eaeaea;\"><INPUT class=inputstyle id=confirmpassword type=password\r\n      name=confirmpassword style=\"border:1px solid #c5c5c5;width:300px;height:30px;\"  onchange='checkinput(\"confirmpassword\",\"confirmpasswordimage\")'>\r\n        <span id=confirmpasswordimage><img src=\"/images/BacoError_wev8.gif\" align=absMiddle></span></TD>\r\n    </TR>\r\n    <tr>\r\n    	<td colspan=\"2\" style=\"text-align:right;height:60px;border-left:1px solid #eaeaea;border-bottom:1px solid #eaeaea;border-right:1px solid #eaeaea;\">\r\n    	<input style=\"margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;background-color:#65a9ff;\" class=\"e8_btn_top_first\" id=btnSave accessKey=S name=btnSave type=submit value=\"\u63d0 \u4ea4\"></input> \r\n    	<input style=\"margin-right:18px;font-size:14px;height:35px;width:100px;text-align:center;background-color:#65a9ff;\" class=\"e8_btn_top_first\" id=btnSaves accessKey=S name=btnSaves type=button onclick=\"javascript:top.location='".toCharArray();
    _jsp_string4 = "\r\n".toCharArray();
    _jsp_string3 = "\r\n<font color=\"#FF0000\">\u65e7\u7684\u9a8c\u8bc1\u7801\u4e0d\u6b63\u786e\uff01</font>\r\n".toCharArray();
  }
}
