/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._mobile._plugin._shxiv._hfwh._servlet;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.hrm.User;
import weaver.hrm.HrmUserVarify;
import weaver.file.FileUploadToPath;
import weaver.general.Util;

public class _mainxs__jsp extends com.caucho.jsp.JavaPage
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
    int resourceId = user.getUID();//\u5f53\u524d\u7528\u6237\u7684id
    FileUploadToPath fu = new FileUploadToPath(request) ;
    String name= Util.null2String(fu.getParameter("name"));

      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((resourceId));
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((name));
      out.write(_jsp_string3, 0, _jsp_string3.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("mobile/plugin/shxiv/hfwh/servlet/mainXs.jsp"), -1297137963726430540L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string3;
  private final static char []_jsp_string0;
  private final static char []_jsp_string1;
  static {
    _jsp_string2 = "\";\r\n    let name=\"".toCharArray();
    _jsp_string3 = "\";\r\n    jQuery(document).ready(function(){\r\n        /*parseURL(window.location.href);*/\r\n        getHtml();\r\n        getMsg();\r\n    });\r\n\r\n    function getHtml(){\r\n        console.log(userId);\r\n        console.log(name);\r\n        let head=\"\";\r\n        head+=\"<i class='ico-line'></i> <span class='big'><a href='/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp'>\"+name+\"</span>\";\r\n        jQuery(\"#headXs\").html(head);\r\n    }\r\n\r\n    /*function parseURL(url){\r\n        var url = url.split(\"?\")[1];\r\n        var para = url.split(\"&\");\r\n        var len = para.length;\r\n        var res = {};\r\n        var arr = [];\r\n        for(var i=0;i<len;i++){\r\n            arr = para.split(\"=\");\r\n            res[arr[0]] = arr[1];\r\n        }\r\n        return res;\r\n    }*/\r\n\r\n    function getMsg() {\r\n        jQuery.ajax({\r\n            url : \"/mobile/plugin/shxiv/hfwh/servlet/XsxMsg.jsp\",\r\n            type : \"post\",\r\n            processData : false,\r\n            async: false,\r\n            data : \"userId=\"+userId+\"&name=\"+name,\r\n            dataType: \"json\",\r\n            error:function (XMLHttpRequest, textStatus, errorThrown) {\r\n\r\n            } ,\r\n            success:function (data, textStatus) {\r\n                console.log(data);\r\n                if(data!==null&&data!==\"\"){\r\n                    let htm = \"<ul>\";\r\n                    if(data==0){\r\n                        htm+=\"<li>\"+\r\n                            \"<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTxs.jsp?name=\"+name+\"&xs=\"+data+\"&zt=0'>\"+\r\n                            \"<div class='img'><img src='/mobile/plugin/shxiv/hfwh/imgs/img15.jpg'/></div>\"+\r\n                            \"<div class='txt'>\u7ebf   \u4e0a</div></a></li>\";\r\n                    }\r\n                    if(data==1){\r\n                        htm+=\"<li>\"+\r\n                            \"<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTxx.jsp?name=\"+name+\"&xs=\"+data+\"&zt=1'>\"+\r\n                            \"<div class='img'><img src='/mobile/plugin/shxiv/hfwh/imgs/img16.jpg'/></div>\"+\r\n                            \"<div class='txt'>\u7ebf   \u4e0b</div></a></li>\";\r\n                    }\r\n                    if(data==2){\r\n                        htm+=\"<li>\"+\r\n                            \"<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTxs.jsp?name=\"+name+\"&xs=\"+data+\"&zt=0'>\"+\r\n                            \"<div class='img'><img src='/mobile/plugin/shxiv/hfwh/imgs/img15.jpg'/></div>\"+\r\n                            \"<div class='txt'>\u7ebf   \u4e0a</div></a></li>\";\r\n\r\n                        htm+=\"<li>\"+\r\n                            \"<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTxx.jsp?name=\"+name+\"&xs=\"+data+\"&zt=1'>\"+\r\n                            \"<div class='img'><img src='/mobile/plugin/shxiv/hfwh/imgs/img16.jpg'/></div>\"+\r\n                            \"<div class='txt'>\u7ebf   \u4e0b</div></a></li>\";\r\n                    }\r\n\r\n                    htm+=\"</ul>\";\r\n                    jQuery(\"#xsId\").html(htm);\r\n                }\r\n            }\r\n        });\r\n\r\n    }\r\n\r\n\r\n    function openSy() {\r\n        window.location.href=\"/docs/news/NewsDsp.jsp\";\r\n    }\r\n\r\n    function openTk() {\r\n        window.location.href=\"/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp\";\r\n    }\r\n\r\n    function openSc() {\r\n        window.location.href=\"/mobile/plugin/shxiv/hfwh/servlet/mainSc.jsp\";\r\n    }\r\n\r\n    function openMm() {\r\n        window.location.href=\"/CRM/data/ManagerUpdatePassword.jsp?type=customer&crmid=\"+userId;\r\n    }\r\n\r\n</script>\r\n</html>\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string1 = "\r\n<html>\r\n<head>\r\n    <meta charset=\"utf-8\">\r\n    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\r\n    <title>\u7ea2\u7eba\u6587\u5316</title>\r\n    <link rel=\"stylesheet\" href=\"/mobile/plugin/shxiv/hfwh/css/qietu.css\">\r\n    <link rel=\"stylesheet\" href=\"/mobile/plugin/shxiv/hfwh/css/swiper.min.css\">\r\n    <link rel=\"stylesheet\" href=\"/mobile/plugin/shxiv/hfwh/css/style.css\">\r\n</head>\r\n<body>\r\n<!--\u5934\u90e8-->\r\n<div class=\"header\">\r\n    <div class=\"header-logo\">\r\n        <a href=\"#\"><img src=\"/mobile/plugin/shxiv/hfwh/imgs/logo.png\"/></a>\r\n    </div>\r\n    <div class=\"header-nav\">\r\n        <ul>\r\n            <li class=\"header-nav-item\"><a href=\"javascript:void(0)\" onclick=\"openSy()\" style=\"font-size: 20px;\">\u9996\u9875</a></li>\r\n            <li class=\"header-nav-item\"><a href=\"javascript:void(0)\" onclick=\"openTk()\" style=\"font-size: 20px;\">\u56fe\u5e93</a></li>\r\n            <li class=\"header-nav-item\"><a href=\"javascript:void(0)\" onclick=\"openSc()\" style=\"font-size: 20px;\">\u56fe\u5e93\u6536\u85cf</a></li>\r\n        </ul>\r\n        <div class=\"icon-mima\" onclick=\"openMm()\"></div>\r\n        <div class=\"icon-quit\" onclick=\"window.location='/login/Logout.jsp'\"></div>\r\n    </div>\r\n</div>\r\n<!--//\u5934\u90e8-->\r\n\r\n<div class=\"wrapper m-wrapper\">\r\n    <div class=\"m-hd\">\r\n        <div class=\"m-breadcrumb\" id=\"headXs\">\r\n            \r\n        </div>\r\n    </div>\r\n\r\n\r\n    <!--\u9009\u62e9-->\r\n    <div class=\"m-choose\" id=\"xsId\">\r\n        <!--<ul>\r\n            <li>\r\n                <a href=\"tkb.html\">\r\n                    <div class=\"img\">\r\n                        <img src=\"/mobile/plugin/shxiv/hfwh/imgs/img15.jpg\"/>\r\n                    </div>\r\n                    <div class=\"txt\">\u7ebf   \u4e0a</div>\r\n                </a>\r\n            </li>\r\n            <li>\r\n                <a href=\"tkb.html\">\r\n                    <div class=\"img\">\r\n                        <img src=\"/mobile/plugin/shxiv/hfwh/imgs/img16.jpg\"/>\r\n                    </div>\r\n                    <div class=\"txt\">\u7ebf   \u4e0b</div>\r\n                </a>\r\n            </li>\r\n        </ul>-->\r\n    </div>\r\n    <!--//\u9009\u62e9-->\r\n</div>\r\n\r\n\r\n<script type=\"text/javascript\" src=\"/mobile/plugin/shxiv/hfwh/js/jquery-1.11.0.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"/mobile/plugin/shxiv/hfwh/js/swiper.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"/mobile/plugin/shxiv/hfwh/js/script.js\"></script>\r\n\r\n</body>\r\n<script type=\"text/javascript\">\r\n\r\n    let userId=\"".toCharArray();
  }
}
