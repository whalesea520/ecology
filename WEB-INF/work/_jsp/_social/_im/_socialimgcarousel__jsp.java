/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._social._im;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.systeminfo.SystemEnv;
import weaver.hrm.User;
import weaver.hrm.HrmUserVarify;

public class _socialimgcarousel__jsp extends com.caucho.jsp.JavaPage
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
	String from = request.getParameter("from");
	boolean ifFromPc = "pc".equalsIgnoreCase(from);

      out.write(_jsp_string1, 0, _jsp_string1.length);
      if(!ifFromPc){ 
      out.write(_jsp_string2, 0, _jsp_string2.length);
      }
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((SystemEnv.getHtmlLabelName(126977, user.getLanguage())));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(126978, user.getLanguage())));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((SystemEnv.getHtmlLabelName(126979, user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      if(ifFromPc){ 
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((SystemEnv.getHtmlLabelName(131907, user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      } 
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((SystemEnv.getHtmlLabelName(126980, user.getLanguage())));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(309, user.getLanguage())));
      out.write(_jsp_string10, 0, _jsp_string10.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("social/im/SocialImgCarousel.jsp"), 1736253164662760856L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string4;
  private final static char []_jsp_string2;
  private final static char []_jsp_string9;
  private final static char []_jsp_string6;
  private final static char []_jsp_string0;
  private final static char []_jsp_string8;
  private final static char []_jsp_string5;
  private final static char []_jsp_string3;
  private final static char []_jsp_string7;
  private final static char []_jsp_string1;
  private final static char []_jsp_string10;
  static {
    _jsp_string4 = "\"><!-- \u653e\u5927\u6b64\u56fe\u7247 -->\r\n	   			</div>\r\n	   			<div class=\"ctrlbtn shrink\" onclick=\"IMCarousel.scaleImg(this, 'shrink')\" data-toggle=\"tooltip\" title=\"".toCharArray();
    _jsp_string2 = "\r\n	.carousel-fullpane .control-pane {width: 200px;}\r\n	".toCharArray();
    _jsp_string9 = "\"><!-- \u4e0b\u8f7d\u6b64\u56fe\u7247 -->\r\n	   			</div>\r\n	   		</div>\r\n	   </div>\r\n	   <!-- \u8f6e\u64ad\uff08Carousel\uff09\u5bfc\u822a -->\r\n	   <a class=\"carousel-control left\" data-slide=\"prev\" onmouseover=\"IMCarousel.showImgIndexNo(this, 'prev')\" onclick=\"IMCarousel.slideImg(this, 'prev');\">&lsaquo;</a>\r\n	   <a class=\"carousel-control right\" data-slide=\"next\" onmouseover=\"IMCarousel.showImgIndexNo(this, 'next')\" onclick=\"IMCarousel.slideImg(this, 'next');\">&rsaquo;</a>\r\n	</div> \r\n	<div class=\"miniClose\" data-toggle=\"tooltip\" data-placement=\"bottom\" title=\"".toCharArray();
    _jsp_string6 = "\"><!-- \u65cb\u8f6c\u6b64\u56fe\u7247 -->\r\n	   			</div>\r\n	   			".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string8 = "\r\n	   			<div class=\"ctrlbtn download\" onclick=\"IMCarousel.downloadImg(this)\" data-toggle=\"tooltip\" title=\"".toCharArray();
    _jsp_string5 = "\"><!-- \u7f29\u5c0f\u6b64\u56fe\u7247 -->\r\n	   			</div>\r\n	   			<div class=\"ctrlbtn rotate\" onclick=\"IMCarousel.rotateImg(this)\" data-toggle=\"tooltip\" title=\"".toCharArray();
    _jsp_string3 = "\r\n</style>\r\n\r\n<!-- \u804a\u5929\u7a97\u53e3\u56fe\u7247\u6d4f\u89c8 -->\r\n<!-- layer -->\r\n<div class=\"mengbanLayer\"></div>\r\n<div class=\"chatImgPagWrap\" onclick=\"IMCarousel.doScannerEscape(event, this);\">\r\n	<div class=\"pcDragArea\" style='height:60px;'></div>\r\n	<div id=\"myCarousel\" class=\"chatImgPag carousel slide\" data=\"carousel\">\r\n	   <!-- \u8f6e\u64ad\uff08Carousel\uff09\u6307\u6807 -->\r\n	   \r\n	   <ol class=\"carousel-indicators\" style=\"display: none;\">\r\n	   \r\n	   </ol>\r\n	   \r\n	   <!-- \u8f6e\u64ad\uff08Carousel\uff09\u9879\u76ee -->\r\n	   <div class=\"carousel-inner\">\r\n	   \r\n	   </div>\r\n	   <!-- \u8f6e\u64ad\uff08Carousel \u63a7\u5236\u9762\u677f -->\r\n	   <div class=\"carousel-fullpane\">\r\n	   		<div class=\"control-pane\">\r\n	   			<div class=\"ctrlbtn enlarge\" onclick=\"IMCarousel.scaleImg(this, 'enlarge')\" data-toggle=\"tooltip\" title=\"".toCharArray();
    _jsp_string7 = "\r\n	   			<div class=\"ctrlbtn copy\" onclick=\"IMCarousel.copyImg(this)\" data-toggle=\"tooltip\" title=\"".toCharArray();
    _jsp_string1 = "\r\n\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"/social/js/bootstrap/css/bootstrap.css\" />\r\n<link rel=\"stylesheet\" type=\"text/css\" href=\"/social/js/bootstrap/css/bs.base.wev8.css\" />\r\n<script src=\"/social/js/drageasy/drageasy.js\"></script>\r\n<script type=\"text/javascript\" src=\"/social/js/bootstrap/js/bootstrap.js\"></script>\r\n<script type=\"text/javascript\" src=\"/social/im/js/IMUtil_wev8.js\"></script>\r\n<script type=\"text/javascript\" src=\"/social/js/imcarousel/imcarousel.js\"></script>\r\n<script type=\"text/javascript\" src=\"/social/js/imcarousel/i18n.js\"></script>\r\n<style>\r\n	".toCharArray();
    _jsp_string10 = "\" onclick=\"IMCarousel.showImgScanner(event, 0, '')\">\u00d7</div><!-- \u5173\u95ed\u56fe\u7247\u6d4f\u89c8 -->\r\n</div>\r\n".toCharArray();
  }
}