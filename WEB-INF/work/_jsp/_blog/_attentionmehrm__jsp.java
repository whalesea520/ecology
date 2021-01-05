/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._blog;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.blog.BlogManager;
import weaver.blog.BlogDiscessVo;
import weaver.blog.BlogDao;
import java.text.SimpleDateFormat;
import weaver.blog.BlogShareManager;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.general.Util;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class _attentionmehrm__jsp extends com.caucho.jsp.JavaPage
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
	

	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	Log logger= LogFactory.getLog(this.getClass());
	String isIE = (String)session.getAttribute("browser_isie");

      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet RecordSet;
      RecordSet = (weaver.conn.RecordSet) pageContext.getAttribute("RecordSet");
      if (RecordSet == null) {
        RecordSet = new weaver.conn.RecordSet();
        pageContext.setAttribute("RecordSet", RecordSet);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.company.SubCompanyComInfo SubCompanyComInfo;
      SubCompanyComInfo = (weaver.hrm.company.SubCompanyComInfo) pageContext.getAttribute("SubCompanyComInfo");
      if (SubCompanyComInfo == null) {
        SubCompanyComInfo = new weaver.hrm.company.SubCompanyComInfo();
        pageContext.setAttribute("SubCompanyComInfo", SubCompanyComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.company.DepartmentComInfo DepartmentComInfo;
      DepartmentComInfo = (weaver.hrm.company.DepartmentComInfo) pageContext.getAttribute("DepartmentComInfo");
      if (DepartmentComInfo == null) {
        DepartmentComInfo = new weaver.hrm.company.DepartmentComInfo();
        pageContext.setAttribute("DepartmentComInfo", DepartmentComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.job.JobTitlesComInfo JobTitlesComInfo;
      JobTitlesComInfo = (weaver.hrm.job.JobTitlesComInfo) pageContext.getAttribute("JobTitlesComInfo");
      if (JobTitlesComInfo == null) {
        JobTitlesComInfo = new weaver.hrm.job.JobTitlesComInfo();
        pageContext.setAttribute("JobTitlesComInfo", JobTitlesComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((SystemEnv.getHtmlLabelName(18659,user.getLanguage())));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((SystemEnv.getHtmlLabelName(27084,user.getLanguage())));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(27084,user.getLanguage())));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      
String from=Util.null2String(request.getParameter("from"));
String userid=""+user.getUID();
String attentionedid=Util.null2String(request.getParameter("userid"));
BlogDao blogDao=new BlogDao();
List attentionList=blogDao.getAttentionMe(attentionedid);
SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat dateFormat2=new SimpleDateFormat("yyyy\u5e74MM\u6708dd\u65e5");

BlogShareManager shareManager=new BlogShareManager();

if(attentionList.size()>0){

      out.write(_jsp_string6, 0, _jsp_string6.length);
      	
for(int i=0;i<attentionList.size();i++){
	  String attentionid=(String)attentionList.get(i);
	  int status=shareManager.viewRight(attentionid,userid);
	  String islower="0";
	  if(status==2||status==4) 
		  islower="1";
	  String username=ResourceComInfo.getLastname(attentionid);
      String deptName=DepartmentComInfo.getDepartmentname(ResourceComInfo.getDepartmentID(attentionid));

      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((attentionid));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((ResourceComInfo.getMessagerUrls(attentionid)));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((weaver.hrm.User.getUserIcon(attentionid,"width: 55px; height: 55px;cursor: pointer;line-height: 55px;border-radius:40px;") ));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((attentionid));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      out.print((username));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((deptName));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((deptName));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((SystemEnv.getHtmlLabelName(83152,user.getLanguage())));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      if(!"view".equals(from)) {
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((attentionid));
      out.write(',');
      out.print((islower));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((status==1||status==2?"":"none"));
      out.write(_jsp_string18, 0, _jsp_string18.length);
      out.print((SystemEnv.getHtmlLabelName(26939,user.getLanguage())));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      out.print((attentionid));
      out.write(',');
      out.print((islower));
      out.write(_jsp_string20, 0, _jsp_string20.length);
      out.print((status==3||status==4?"":"none"));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((SystemEnv.getHtmlLabelName(26938,user.getLanguage())));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((attentionid));
      out.write(',');
      out.print((islower));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((status==0?"":"none"));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((SystemEnv.getHtmlLabelName(26941,user.getLanguage())));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      } 
      out.write(_jsp_string26, 0, _jsp_string26.length);
      }
      out.write(_jsp_string27, 0, _jsp_string27.length);
      
}else
    out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");

      out.write(_jsp_string28, 0, _jsp_string28.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("blog/attentionMeHrm.jsp"), -7651733819276597924L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string7;
  private final static char []_jsp_string10;
  private final static char []_jsp_string3;
  private final static char []_jsp_string22;
  private final static char []_jsp_string9;
  private final static char []_jsp_string13;
  private final static char []_jsp_string12;
  private final static char []_jsp_string24;
  private final static char []_jsp_string15;
  private final static char []_jsp_string20;
  private final static char []_jsp_string6;
  private final static char []_jsp_string0;
  private final static char []_jsp_string25;
  private final static char []_jsp_string27;
  private final static char []_jsp_string8;
  private final static char []_jsp_string14;
  private final static char []_jsp_string2;
  private final static char []_jsp_string16;
  private final static char []_jsp_string4;
  private final static char []_jsp_string21;
  private final static char []_jsp_string28;
  private final static char []_jsp_string17;
  private final static char []_jsp_string18;
  private final static char []_jsp_string1;
  private final static char []_jsp_string19;
  private final static char []_jsp_string5;
  private final static char []_jsp_string26;
  private final static char []_jsp_string23;
  private final static char []_jsp_string11;
  static {
    _jsp_string7 = "\r\n   <LI class=\"LInormal\">\r\n	<DIV class=\"LIdiv\">\r\n	   <A class=figure href=\"viewBlog.jsp?blogid=".toCharArray();
    _jsp_string10 = "\r\n	   </A>\r\n	   <div style=\"float: left;padding-top: 10px;padding-left: 10px;overflow: hidden;\">\r\n		   <SPAN class=line><A class=name href=\"viewBlog.jsp?blogid=".toCharArray();
    _jsp_string3 = "\");\r\n         jQuery(obj).attr(\"isApply\",\"true\");\r\n         alert(\"".toCharArray();
    _jsp_string22 = "</span></label>\r\n	           </button>\r\n	           \r\n	           <button class=\"blueButton\" onclick=\"disAttention(this,".toCharArray();
    _jsp_string9 = "\" width=55  height=55>\r\n	   -->\r\n	   ".toCharArray();
    _jsp_string13 = "\">".toCharArray();
    _jsp_string12 = "</A></SPAN> \r\n	       <SPAN class=\"line gray-time\" title=\"".toCharArray();
    _jsp_string24 = "\">\r\n	           		<label id=\"btnLabel\" style=\"font-size:12px;\"><span class='add'>\u221a</span>".toCharArray();
    _jsp_string15 = "</span>	    \r\n	    </div>\r\n	    <div style=\"float: left;padding-left: 15px\"> \r\n			".toCharArray();
    _jsp_string20 = ",event);\" type=\"button\" status=\"cancel\" style=\"margin-right: 8px;width:65px;display: ".toCharArray();
    _jsp_string6 = "\r\n<DIV id=footwall_visitme class=\"footwall\" style=\"width: 100%;float: left;\">\r\n<UL>\r\n".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string25 = "</span></label>\r\n	           </button>\r\n		        \r\n		    ".toCharArray();
    _jsp_string27 = "\r\n</UL>\r\n</DIV>      \r\n".toCharArray();
    _jsp_string8 = "\" target=_blank>\r\n	   <!--\r\n	   <IMG src=\"".toCharArray();
    _jsp_string14 = "</SPAN>\r\n	   </div>\r\n	   \r\n	   <div class=info>\r\n	    <div style=\"float: left;\">\r\n			<span style=\"visibility: hidden; \">".toCharArray();
    _jsp_string2 = "\r\n<script>\r\n  function addAttention(attentionid,islower){\r\n      jQuery.post(\"blogOperation.jsp?operation=addAttention&islower=\"+islower+\"&attentionid=\"+attentionid);\r\n      jQuery(\"#cancelAttention_\"+attentionid).show();\r\n      jQuery(\"#addAttention_\"+attentionid).hide();\r\n   }\r\n  function cancelAttention(attentionid,islower){\r\n      jQuery.post(\"blogOperation.jsp?operation=cancelAttention&islower=\"+islower+\"&attentionid=\"+attentionid);\r\n      jQuery(\"#cancelAttention_\"+attentionid).hide();\r\n      jQuery(\"#addAttention_\"+attentionid).show();\r\n   }\r\n  function requestAttention(obj,attentionid){\r\n    if(jQuery(obj).attr(\"isApply\")!=\"true\"){\r\n      jQuery.post(\"blogOperation.jsp?operation=requestAttention&attentionid=\"+attentionid,function(){\r\n         jQuery(obj).find(\"#btnLabel\").html(\"<span class='apply'>\u221a</span>".toCharArray();
    _jsp_string16 = "\r\n			   <button class=\"blueButton\" onclick=\"disAttention(this,".toCharArray();
    _jsp_string4 = "\");//\u7533\u8bf7\u5df2\u7ecf\u53d1\u9001\r\n      });\r\n     }else{\r\n         alert(\"".toCharArray();
    _jsp_string21 = "\">\r\n	           		<label id=\"btnLabel\" style=\"font-size:12px;\"><span class='add'>-</span>".toCharArray();
    _jsp_string28 = "\r\n<script>\r\n  jQuery(\"#footwall_visitme li\").hover(\r\n    function(){\r\n       jQuery(this).addClass(\"LIhover\");\r\n    },function(){\r\n       jQuery(this).removeClass(\"LIhover\");\r\n    }\r\n  );\r\n</script>\r\n<br/>\r\n<br/>      \r\n".toCharArray();
    _jsp_string17 = ",event);\" type=\"button\" status=\"add\" style=\"margin-right: 8px;width:65px;display: ".toCharArray();
    _jsp_string18 = "\">\r\n	           		<label id=\"btnLabel\" style=\"font-size:12px;\"><span class='add'>+</span>".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string19 = "</span></label>\r\n	           </button>\r\n	           \r\n			   <button class=\"grayButton\" onclick=\"disAttention(this,".toCharArray();
    _jsp_string5 = "\");//\u7533\u8bf7\u5df2\u7ecf\u53d1\u9001\r\n     }  \r\n   } \r\n</script>\r\n".toCharArray();
    _jsp_string26 = "\r\n		 </div>\r\n	   </div>	   \r\n	</DIV>\r\n  </LI>\r\n   ".toCharArray();
    _jsp_string23 = ",event);\" type=\"button\" status=\"apply\" style=\"margin-right: 8px;width:65px;display: ".toCharArray();
    _jsp_string11 = "\" target=_blank>".toCharArray();
  }
}
