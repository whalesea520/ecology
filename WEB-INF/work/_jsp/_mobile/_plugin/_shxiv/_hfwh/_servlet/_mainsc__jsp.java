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

public class _mainsc__jsp extends com.caucho.jsp.JavaPage
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

      out.write(_jsp_string1, 0, _jsp_string1.length);
      out.print((resourceId));
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("mobile/plugin/shxiv/hfwh/servlet/mainsc.jsp"), -7247810736924102557L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  private final static char []_jsp_string0;
  static {
    _jsp_string2 = "\";\r\n    var isSc=\"1\";\r\n    jQuery(document).ready(function(){\r\n        getTcList();\r\n    });\r\n\r\n    function getTcList() {\r\n        jQuery.ajax({\r\n            url : \"/mobile/plugin/shxiv/hfwh/servlet/ScTkMsg.jsp\",\r\n            type : \"post\",\r\n            processData : false,\r\n            async: false,\r\n            data : \"userId=\"+userId,\r\n            dataType: \"json\",\r\n            error:function (XMLHttpRequest, textStatus, errorThrown) {\r\n\r\n            } ,\r\n            success:function (data, textStatus) {\r\n                if(data!=null&&data!=\"\"){\r\n                    var htm = \"<ul>\";\r\n                    for(var j = 0; j<data.length; j++){\r\n                        htm+=\"<li>\"+\r\n                            \"<div class='item'>\"+\r\n                            \"<div class='img'>\"+\r\n                            \"<a href='/mobile/plugin/shxiv/hfwh/servlet/mainTp.jsp?tcId=\"+data[j].tcId+\"&name=\"+data[j].ipName+\"&tcIp=\"+data[j].tcIp+\"&fileId=\"+data[j].fmId+\"&tcName=\"+data[j].tcName+\"&pdf=\"+data[j].pdfId+\"&isSc=\"+isSc+\"'>\"+\r\n                            \"<img src='/weaver/weaver.file.FileDownloadDontLogin?fileid=\"+data[j].fmId+\"'/>\"+\r\n                                /*\"<i class='icon-big'></i>\"+*/\r\n                            \"</a></div>\"+\r\n                            \"<div class='txt'>\"+\r\n                            \"<div class='txt-l'>\"+data[j].tcName+\"</div>\"+\r\n                            \"<div class='txt-r'>\"+\r\n                            \"<i class='icon-down' onclick='download(\"+data[j].pdfId+\",\"+data[j].tcId+\",\"+data[j].tcIp+\")'></i>\"+\r\n                            \"<i class='icon-del' onclick='delSc(\"+data[j].tcId+\")'></i>\"+\r\n                            \"</div></div></div></li>\";\r\n                    }\r\n                    htm+=\"</ul>\";\r\n                    jQuery(\"#tcList\").html(htm);\r\n                }\r\n            }\r\n        });\r\n    }\r\n\r\n    function download(pdfId,tcId,tcIp) {\r\n        /*jQuery.ajax({\r\n            url : \"/mobile/plugin/shxiv/hfwh/servlet/CheckTc.jsp\",\r\n            type : \"post\",\r\n            processData : false,\r\n            async: false,\r\n            data : \"userId=\"+userId+\"&tcId=\"+tcId+\"&tcIp=\"+tcIp,\r\n            dataType: \"json\",\r\n            error:function (XMLHttpRequest, textStatus, errorThrown) {\r\n\r\n            } ,\r\n            success:function (data, textStatus) {\r\n                if(data){\r\n                    window.open(\"/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid=\"+pdfId);\r\n                }else{\r\n                    window.top.alert(\"\u4e0b\u8f7d\u6570\u91cf\u5df2\u7528\u5b8c\uff0c\u8bf7\u5347\u7ea7\u540e\u518d\u64cd\u4f5c\u3002\");\r\n                }\r\n            }\r\n        });*/\r\n        window.open(\"/weaver/weaver.file.FileDownloadDontLogin?download=1&requestid=-1&fileid=\"+pdfId);\r\n    }\r\n\r\n    function delSc(tcId) {\r\n        jQuery.ajax({\r\n         url : \"/mobile/plugin/shxiv/hfwh/servlet/DeleteSc.jsp\",\r\n         type : \"post\",\r\n         processData : false,\r\n         async: false,\r\n         data : \"userId=\"+userId+\"&tcId=\"+tcId,\r\n         dataType: \"json\",\r\n         error:function (XMLHttpRequest, textStatus, errorThrown) {\r\n\r\n         } ,\r\n         success:function (data, textStatus) {\r\n             location.reload();\r\n         }\r\n         });\r\n    }\r\n\r\n    function openSy() {\r\n        window.location.href=\"/docs/news/NewsDsp.jsp\";\r\n    }\r\n\r\n    function openTk() {\r\n        window.location.href=\"/mobile/plugin/shxiv/hfwh/servlet/mainTk.jsp\";\r\n    }\r\n\r\n    function openSc() {\r\n        window.location.href=\"/mobile/plugin/shxiv/hfwh/servlet/mainSc.jsp\";\r\n    }\r\n\r\n    function openMm() {\r\n        window.location.href=\"/CRM/data/ManagerUpdatePassword.jsp?type=customer&crmid=\"+userId;\r\n    }\r\n\r\n</script>\r\n</html>".toCharArray();
    _jsp_string1 = "\r\n<html>\r\n<head>\r\n    <meta charset=\"utf-8\">\r\n    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\">\r\n    <title>\u7ea2\u7eba\u6587\u5316</title>\r\n    <link rel=\"stylesheet\" href=\"/mobile/plugin/shxiv/hfwh/css/qietu.css\">\r\n    <link rel=\"stylesheet\" href=\"/mobile/plugin/shxiv/hfwh/css/swiper.min.css\">\r\n    <link rel=\"stylesheet\" href=\"/mobile/plugin/shxiv/hfwh/css/lightbox.css\">\r\n    <link rel=\"stylesheet\" href=\"/mobile/plugin/shxiv/hfwh/css/style.css\">\r\n</head>\r\n<body>\r\n<!--\u5934\u90e8-->\r\n<div class=\"header\">\r\n    <div class=\"header-logo\">\r\n        <a href=\"#\"><img src=\"/mobile/plugin/shxiv/hfwh/imgs/logo.png\"/></a>\r\n    </div>\r\n    <div class=\"header-nav\">\r\n        <ul>\r\n            <li class=\"header-nav-item\"><a href=\"javascript:void(0)\" onclick=\"openSy()\" style=\"font-size: 20px;\">\u9996\u9875</a></li>\r\n            <li class=\"header-nav-item\"><a href=\"javascript:void(0)\" onclick=\"openTk()\" style=\"font-size: 20px;\">\u56fe\u5e93</a></li>\r\n            <li class=\"header-nav-item\"><a href=\"javascript:void(0)\" onclick=\"openSc()\" style=\"font-size: 20px;\">\u56fe\u5e93\u6536\u85cf</a></li>\r\n        </ul>\r\n        <div class=\"icon-mima\" onclick=\"openMm()\"></div>\r\n        <div class=\"icon-quit\" onclick=\"window.location='/login/Logout.jsp'\"></div>\r\n    </div>\r\n</div>\r\n<!--//\u5934\u90e8-->\r\n\r\n<div class=\"wrapper m-wrapper\">\r\n    <!--\u641c\u7d22-->\r\n    <!--<div class=\"m-search\">\r\n        <input class=\"text\" type=\"text\" name=\"\" value=\"\" placeholder=\"IP\" />\r\n    </div>-->\r\n    <!--//\u641c\u7d22-->\r\n\r\n    <div class=\"m-hd\">\r\n        <div class=\"m-breadcrumb\">\r\n            <i class=\"ico-line\"></i><a href=\"javascript:void(0)\"> \u56fe\u5e93\u6536\u85cf</a>\r\n        </div>\r\n    </div>\r\n\r\n\r\n    <!--\u56fe\u7247\u5217\u8868-->\r\n    <div class=\"m-searchlist\" id=\"tcList\">\r\n\r\n    </div>\r\n    <!--//\u56fe\u7247\u5217\u8868-->\r\n</div>\r\n\r\n\r\n<script type=\"text/javascript\" src=\"/mobile/plugin/shxiv/hfwh/js/jquery-1.11.0.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"/mobile/plugin/shxiv/hfwh/js/swiper.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"/mobile/plugin/shxiv/hfwh/js/lightbox.min.js\"></script>\r\n<script type=\"text/javascript\" src=\"/mobile/plugin/shxiv/hfwh/js/script.js\"></script>\r\n\r\n</body>\r\n<script type=\"text/javascript\">\r\n    var userId=\"".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n".toCharArray();
  }
}