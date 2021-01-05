/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._formmode._setup;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.general.Util;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;
import weaver.systeminfo.SystemEnv;
import weaver.formmode.ThreadLocalUser;
import weaver.systeminfo.systemright.CheckSubCompanyRight;
import java.io.IOException;

public class _interfaceinfo__jsp extends com.caucho.jsp.JavaPage
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

      out.write(_jsp_string0, 0, _jsp_string0.length);
      weaver.hrm.moduledetach.ManageDetachComInfo ManageDetachComInfo;
      ManageDetachComInfo = (weaver.hrm.moduledetach.ManageDetachComInfo) pageContext.getAttribute("ManageDetachComInfo");
      if (ManageDetachComInfo == null) {
        ManageDetachComInfo = new weaver.hrm.moduledetach.ManageDetachComInfo();
        pageContext.setAttribute("ManageDetachComInfo", ManageDetachComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.systeminfo.systemright.CheckSubCompanyRight CheckSubCompanyRight;
      CheckSubCompanyRight = (weaver.systeminfo.systemright.CheckSubCompanyRight) pageContext.getAttribute("CheckSubCompanyRight");
      if (CheckSubCompanyRight == null) {
        CheckSubCompanyRight = new weaver.systeminfo.systemright.CheckSubCompanyRight();
        pageContext.setAttribute("CheckSubCompanyRight", CheckSubCompanyRight);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.hrm.company.SubCompanyComInfo SubCompanyComInfo;
      SubCompanyComInfo = (weaver.hrm.company.SubCompanyComInfo) pageContext.getAttribute("SubCompanyComInfo");
      if (SubCompanyComInfo == null) {
        SubCompanyComInfo = new weaver.hrm.company.SubCompanyComInfo();
        pageContext.setAttribute("SubCompanyComInfo", SubCompanyComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      
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

      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((user.getLanguage()));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((SystemEnv.getHtmlLabelName(15097,user.getLanguage())));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(22161,user.getLanguage())));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((SystemEnv.getHtmlLabelName(15859,user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)
		&&!HrmUserVarify.checkUserRight("FORMMODEFORM:ALL", user)
		&&!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

      out.write(_jsp_string1, 0, _jsp_string1.length);
      
int customSearchId = Util.getIntValue(request.getParameter("id"), 0);

      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((SystemEnv.getHtmlLabelName(85,user.getLanguage())));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      if(customSearchId==1){
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(82143,user.getLanguage())));
      out.write(_jsp_string10, 0, _jsp_string10.length);
      }else if(customSearchId==2){
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(82144,user.getLanguage())));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      }else if(customSearchId==3){
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(82145,user.getLanguage())));
      out.write(_jsp_string12, 0, _jsp_string12.length);
      }else if(customSearchId==4){
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(82146,user.getLanguage())));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      }else if(customSearchId==5){
      out.write(_jsp_string9, 0, _jsp_string9.length);
      out.print((SystemEnv.getHtmlLabelName(82147,user.getLanguage())));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      }
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((SystemEnv.getHtmlLabelName(28245,user.getLanguage())));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      if(customSearchId==1){
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((SystemEnv.getHtmlLabelName(19049,user.getLanguage())));
      out.write(_jsp_string18, 0, _jsp_string18.length);
      out.print((SystemEnv.getHtmlLabelName(82148,user.getLanguage())));
      out.write(_jsp_string19, 0, _jsp_string19.length);
      out.print((SystemEnv.getHtmlLabelName(82149,user.getLanguage())));
      out.write(_jsp_string20, 0, _jsp_string20.length);
      out.print((SystemEnv.getHtmlLabelName(82150,user.getLanguage())));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((SystemEnv.getHtmlLabelName(82151,user.getLanguage())));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((SystemEnv.getHtmlLabelName(20331,user.getLanguage())));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((SystemEnv.getHtmlLabelName(82152,user.getLanguage())));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((SystemEnv.getHtmlLabelName(82153,user.getLanguage())));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      }else if(customSearchId==2){
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((SystemEnv.getHtmlLabelName(19049,user.getLanguage())));
      out.write(_jsp_string26, 0, _jsp_string26.length);
      out.print((SystemEnv.getHtmlLabelName(24533,user.getLanguage())));
      out.write(_jsp_string27, 0, _jsp_string27.length);
      out.print((SystemEnv.getHtmlLabelName(20331,user.getLanguage())));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((SystemEnv.getHtmlLabelName(82152,user.getLanguage())));
      out.write(_jsp_string28, 0, _jsp_string28.length);
      }else if(customSearchId==3){
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((SystemEnv.getHtmlLabelName(19049,user.getLanguage())));
      out.write(_jsp_string29, 0, _jsp_string29.length);
      out.print((SystemEnv.getHtmlLabelName(563,user.getLanguage())));
      out.write(_jsp_string30, 0, _jsp_string30.length);
      out.print((SystemEnv.getHtmlLabelName(24533,user.getLanguage())));
      out.write(_jsp_string31, 0, _jsp_string31.length);
      out.print((SystemEnv.getHtmlLabelName(82152,user.getLanguage())));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((SystemEnv.getHtmlLabelName(82153,user.getLanguage())));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      }else if(customSearchId==4){
      out.write(_jsp_string32, 0, _jsp_string32.length);
      }else if(customSearchId==5){
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((SystemEnv.getHtmlLabelName(19049,user.getLanguage())));
      out.write(_jsp_string33, 0, _jsp_string33.length);
      out.print((SystemEnv.getHtmlLabelName(563,user.getLanguage())));
      out.write(_jsp_string30, 0, _jsp_string30.length);
      out.print((SystemEnv.getHtmlLabelName(24533,user.getLanguage())));
      out.write(_jsp_string34, 0, _jsp_string34.length);
      out.print((SystemEnv.getHtmlLabelName(82152,user.getLanguage())));
      out.write(_jsp_string28, 0, _jsp_string28.length);
      }
      out.write(_jsp_string35, 0, _jsp_string35.length);
      out.print((SystemEnv.getHtmlLabelName(28255,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      if(customSearchId==1){
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((SystemEnv.getHtmlLabelName(82154,user.getLanguage())));
      out.write(_jsp_string38, 0, _jsp_string38.length);
      }else if(customSearchId==2){
      out.write(_jsp_string39, 0, _jsp_string39.length);
      out.print((SystemEnv.getHtmlLabelName(82155,user.getLanguage())));
      out.write(_jsp_string40, 0, _jsp_string40.length);
      }else if(customSearchId==3){
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((SystemEnv.getHtmlLabelName(33473,user.getLanguage())));
      out.write(_jsp_string41, 0, _jsp_string41.length);
      }else if(customSearchId==4){
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((SystemEnv.getHtmlLabelName(82156,user.getLanguage())));
      out.write(_jsp_string42, 0, _jsp_string42.length);
      }else if(customSearchId==5){
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((SystemEnv.getHtmlLabelName(82157,user.getLanguage())));
      out.write(_jsp_string43, 0, _jsp_string43.length);
      }
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((SystemEnv.getHtmlLabelName(82158,user.getLanguage())));
      out.write(_jsp_string44, 0, _jsp_string44.length);
      out.print((SystemEnv.getHtmlLabelName(160,user.getLanguage())));
      out.write(_jsp_string45, 0, _jsp_string45.length);
      out.print((SystemEnv.getHtmlLabelName(82159,user.getLanguage())));
      out.write(_jsp_string46, 0, _jsp_string46.length);
      out.print((SystemEnv.getHtmlLabelName(82160,user.getLanguage())));
      out.write(_jsp_string47, 0, _jsp_string47.length);
      out.print((SystemEnv.getHtmlLabelName(30235,user.getLanguage())));
      out.write(_jsp_string48, 0, _jsp_string48.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/setup/interfaceInfo.jsp"), -5135395122895053063L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/pub.jsp"), -792240692296315271L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/pub_init.jsp"), -4246916824298514572L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("formmode/pub_function.jsp"), 5446055981984630656L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string11;
  private final static char []_jsp_string2;
  private final static char []_jsp_string24;
  private final static char []_jsp_string9;
  private final static char []_jsp_string40;
  private final static char []_jsp_string21;
  private final static char []_jsp_string43;
  private final static char []_jsp_string48;
  private final static char []_jsp_string32;
  private final static char []_jsp_string28;
  private final static char []_jsp_string38;
  private final static char []_jsp_string39;
  private final static char []_jsp_string34;
  private final static char []_jsp_string7;
  private final static char []_jsp_string12;
  private final static char []_jsp_string36;
  private final static char []_jsp_string6;
  private final static char []_jsp_string26;
  private final static char []_jsp_string15;
  private final static char []_jsp_string23;
  private final static char []_jsp_string41;
  private final static char []_jsp_string29;
  private final static char []_jsp_string13;
  private final static char []_jsp_string14;
  private final static char []_jsp_string5;
  private final static char []_jsp_string42;
  private final static char []_jsp_string46;
  private final static char []_jsp_string30;
  private final static char []_jsp_string4;
  private final static char []_jsp_string33;
  private final static char []_jsp_string22;
  private final static char []_jsp_string45;
  private final static char []_jsp_string20;
  private final static char []_jsp_string25;
  private final static char []_jsp_string37;
  private final static char []_jsp_string18;
  private final static char []_jsp_string31;
  private final static char []_jsp_string0;
  private final static char []_jsp_string17;
  private final static char []_jsp_string47;
  private final static char []_jsp_string1;
  private final static char []_jsp_string3;
  private final static char []_jsp_string44;
  private final static char []_jsp_string35;
  private final static char []_jsp_string16;
  private final static char []_jsp_string27;
  private final static char []_jsp_string19;
  private final static char []_jsp_string8;
  private final static char []_jsp_string10;
  static {
    _jsp_string11 = "<!-- \u8ddf\u636e\u6761\u4ef6\u83b7\u53d6\u8868\u5355\u6570\u636e\u603b\u6570 -->\r\n			".toCharArray();
    _jsp_string2 = "\r\n\r\n\r\n<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\r\n<html>\r\n<head>\r\n	<script type=\"text/javascript\" src=\"/formmode/js/jquery/jquery-1.8.3.min_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/formmode/js/FormmodeUtil_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/js/weaver_wev8.js\"></script>\r\n	<LINK type=\"text/css\" rel=\"stylesheet\" href=\"/css/Weaver_wev8.css\" />	<!-- for right menu -->\r\n	\r\n	<link type=\"text/css\" rel=\"stylesheet\" href=\"/js/ecology8/jNice/jNice/jNice_wev8.css\"/>\r\n	<script type=\"text/javascript\" src=\"/js/ecology8/jNice/jNice/jquery.jNice_wev8.js\"></script>\r\n	\r\n	<script language=\"javascript\" type=\"text/javascript\" src=\"/js/init_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/js/ecology8/lang/weaver_lang_".toCharArray();
    _jsp_string24 = "<!-- \u662f\u5426\u53d7\u6743\u9650\u63a7\u5236 --><br>\r\n				@param isReturnDetail \uff08y/n\uff09 ".toCharArray();
    _jsp_string9 = "\r\n					".toCharArray();
    _jsp_string40 = "<!-- \u8868\u5355\u603b\u6570 -->\r\n			".toCharArray();
    _jsp_string21 = "<!-- \u8bb0\u5f55\u603b\u6570\uff08\u5c0f\u4e8e\u7b49\u4e8e0\u65f6\u81ea\u52a8\u8ba1\u7b97\u8bb0\u5f55\u603b\u6570\uff09 --><br>\r\n				@param userid ".toCharArray();
    _jsp_string43 = "<!-- \u8fd4\u56de\u5220\u9664\u72b6\u6001 -->\r\n			".toCharArray();
    _jsp_string48 = "<!-- \u8868\u5355\u5efa\u6a21 -->webservice_example.rar</a>\r\n			</td>\r\n		</tr>\r\n		</table>\r\n	</div>\r\n</body>\r\n</html>\r\n".toCharArray();
    _jsp_string32 = "\r\n				@param paramXml\r\n			".toCharArray();
    _jsp_string28 = "<!-- \u662f\u5426\u53d7\u6743\u9650\u63a7\u5236 -->\r\n			".toCharArray();
    _jsp_string38 = "<!-- \u8868\u5355\u6570\u636e\u5217\u8868\uff08\u5206\u9875\uff09 -->\r\n			".toCharArray();
    _jsp_string39 = "\r\n					int: ".toCharArray();
    _jsp_string34 = "<!-- \u7528\u6237 -->ID<br>\r\n				@param right \uff08y/n\uff09   ".toCharArray();
    _jsp_string7 = "\r\n<html>\r\n<head>\r\n	<title></title>\r\n	<LINK href=\"/css/Weaver_wev8.css\" type=text/css rel=STYLESHEET>\r\n	\r\n	<style>\r\n	*{\r\n		font: 12px Microsoft YaHei;\r\n	}\r\n	.e8_tblForm{\r\n		width: 100%;\r\n		margin: 0 0;\r\n		border-collapse: collapse;\r\n	}\r\n	.e8_tblForm .e8_tblForm_label{\r\n		vertical-align: top;\r\n		border-bottom: 1px solid #e6e6e6;\r\n		padding: 5px 2px;\r\n	}\r\n	.e8_tblForm .e8_tblForm_field{\r\n		border-bottom: 1px solid #e6e6e6;\r\n		padding: 5px 7px;\r\n		background-color: #f8f8f8;\r\n	}\r\n	.e8_label_desc{\r\n		color: #aaa;\r\n	}\r\n	</style>\r\n	<style type=\"text/css\">\r\n		* {font:12px Microsoft YaHei}\r\n		html,body{\r\n			height: 100%;\r\n			margin: 0px;\r\n			padding: 0px 0 0 2px;\r\n		}\r\n		.e8_right_top{\r\n			padding: 13px 10px 0px 10px;\r\n			position: relative;\r\n		}\r\n		.e8_right_top .e8_baseinfo{\r\n			border-bottom: 1px solid #E9E9E9;\r\n			padding-bottom: 16px;\r\n		}\r\n		.e8_right_top .e8_baseinfo_name{\r\n			font-size: 18px;\r\n			color: #333;\r\n		}\r\n		.e8_right_top .e8_baseinfo_modify{\r\n			font-size: 12px;\r\n			color: #AFAFAF;\r\n		}\r\n		.e8_right_top ul{\r\n			list-style: none;\r\n			position: absolute;\r\n			right: 20px;\r\n			bottom: 15px;\r\n		}\r\n		.e8_right_top ul li{\r\n			float: left;\r\n			padding: 0px 5px;\r\n		}\r\n		.e8_right_top ul li a{\r\n			display: block;\r\n			font-size: 15px;\r\n			color: #A3A3A3;\r\n			padding: 1px;\r\n			text-decoration: none;\r\n			cursor: pointer;\r\n		}\r\n		.e8_right_top ul li.selected a{\r\n			color: #0072C6;		\r\n			border-bottom: 2px solid #0072C6;\r\n		}\r\n		.e8_right_center{\r\n			overflow: hidden;\r\n			padding: 0px 10px;\r\n		}\r\n		.e8_right_center .e8_right_frameContainer{\r\n			display: none;\r\n			height: 100%;\r\n		}\r\n		.e8_formmode_gray{\r\n			color: #aaa;\r\n		}\r\n	</style>\r\n	<script type=\"text/javascript\">\r\n		\r\n		$(document).ready(function () {\r\n			$(window).resize(forPageResize);\r\n			forPageResize();\r\n		});\r\n		\r\n		function forPageResize(){\r\n			var $body = $(document.body);\r\n			var $e8_right_top = $(\".e8_right_top\");\r\n			var $e8_right_center = $(\".e8_right_center\");\r\n			\r\n			var centerHeight = $body.height() - $e8_right_top.outerHeight(true);\r\n			\r\n			$e8_right_center.height(centerHeight);\r\n		}\r\n	</script>\r\n</head>\r\n  \r\n<body>\r\n	<div class=\"e8_right_top\">\r\n		<div style=\"width:40px;float:left;margin:2px 10px 0 0;\"><img src=\"/formmode/images/interfaceIconRounded_wev8.png\" /></div>\r\n		<div class=\"e8_baseinfo\">\r\n			<div class=\"e8_baseinfo_name\">\r\n				Web Service \r\n			</div>\r\n			<div class=\"e8_baseinfo_modify\">\r\n				webservices.services.weaver.com.cn\r\n			</div>\r\n		</div>\r\n	</div>\r\n	\r\n	<div class=\"e8_right_center\" style=\"\">\r\n		<table class=\"e8_tblForm\">\r\n		<tr>\r\n			<td class=\"e8_tblForm_label\" width=\"20%\">Name<div class=\"e8_label_desc\"></div></td>\r\n			<td class=\"e8_tblForm_field\" width=\"80%\">\r\n			ModeDataService\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td class=\"e8_tblForm_label\" width=\"20%\">Service Class<div class=\"e8_label_desc\"></div></td>\r\n			<td class=\"e8_tblForm_field\" width=\"80%\">\r\n			weaver.formmode.webservices.ModeDataService\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td class=\"e8_tblForm_label\" width=\"20%\">WSDL<div class=\"e8_label_desc\"></div></td>\r\n			<td class=\"e8_tblForm_field\" width=\"80%\">\r\n			http://ip:port//services/ModeDataService?wsdl\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td class=\"e8_tblForm_label\">".toCharArray();
    _jsp_string12 = "<!-- \u901a\u8fc7ID\u83b7\u53d6\u8be6\u7ec6\u4fe1\u606f -->\r\n			".toCharArray();
    _jsp_string36 = "<!-- \u8f93\u51fa\u53c2\u6570 --></td>\r\n			<td class=\"e8_tblForm_field\" width=\"80%\">\r\n			".toCharArray();
    _jsp_string6 = "\",function(){displayAllmenu();});//\u5fc5\u8981\u4fe1\u606f\u4e0d\u5b8c\u6574\uff01\r\n				return false;\r\n			}\r\n		}\r\n		return true;\r\n    }\r\n	</script>\r\n</head>\r\n	\r\n</html>\r\n\r\n".toCharArray();
    _jsp_string26 = "<!-- \u8868\u5355 -->ID<br>\r\n				@param userId ".toCharArray();
    _jsp_string15 = "\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td class=\"e8_tblForm_label\" width=\"20%\">".toCharArray();
    _jsp_string23 = "<!-- \u67e5\u8be2\u6761\u4ef6 --><br>\r\n				@param right \uff08y/n\uff09 ".toCharArray();
    _jsp_string41 = "<!-- \u8868\u5355\u5185\u5bb9 -->\r\n			".toCharArray();
    _jsp_string29 = "<!-- \u8868\u5355 -->ID<br>\r\n	 			@param Id ".toCharArray();
    _jsp_string13 = "<!-- \u4fdd\u5b58\u8868\u5355\u6570\u636e\uff08\u65b0\u589e\u3001\u66f4\u65b0\uff09 -->\r\n			".toCharArray();
    _jsp_string14 = "<!-- \u6839\u636e\u6570\u636eID\u5220\u9664\u8868\u5355\u6570\u636e -->\r\n			".toCharArray();
    _jsp_string5 = "\";//\u786e\u5b9a\u8981\u63d0\u4ea4\u5417?\r\n     if(!confirm(str)){\r\n       return false;\r\n     }\r\n       return true;\r\n   } \r\n   \r\n   function checkFieldValue(ids){\r\n		var idsArr = ids.split(\",\");\r\n		for(var i=0;i<idsArr.length;i++){\r\n			var obj = document.getElementById(idsArr[i]);\r\n			if(obj&&obj.value==\"\"){\r\n				window.top.Dialog.alert(\"".toCharArray();
    _jsp_string42 = "<!-- \u8fd4\u56de\u4fdd\u5b58\u72b6\u6001 -->\r\n			".toCharArray();
    _jsp_string46 = "<!-- \u793a\u4f8b --><div class=\"e8_label_desc\">".toCharArray();
    _jsp_string30 = "<!-- \u6570\u636e -->ID<br>\r\n				@param userId ".toCharArray();
    _jsp_string4 = "\";//\u786e\u5b9a\u8981\u5220\u9664\u5417?\r\n      if(!confirm(str)){\r\n        return false;\r\n      }\r\n        return true;\r\n    } \r\n\r\n   function issubmit(){\r\n	 var str = \"".toCharArray();
    _jsp_string33 = "<!-- \u8868\u5355 -->ID<br>\r\n			 	@param Id ".toCharArray();
    _jsp_string22 = "<!-- \u5f53\u524d\u7528\u6237 --><br>\r\n				@param conditions ".toCharArray();
    _jsp_string45 = "<!-- \u4f7f\u7528 -->Myeclipse -> File -> new -> Other -> Myeclipse -> Web Services -> Web Service Client \r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td class=\"e8_tblForm_label\">".toCharArray();
    _jsp_string20 = "<!-- \u6bcf\u9875\u8bb0\u5f55\u6570 --><br>\r\n		 		@param recordCount ".toCharArray();
    _jsp_string25 = "<!-- \u662f\u5426\u8fd4\u56de\u660e\u7ec6\u8868\u6570\u636e -->\r\n			".toCharArray();
    _jsp_string37 = "\r\n					String: ".toCharArray();
    _jsp_string18 = "ID<br><!-- \u8868\u5355 -->\r\n				@param pageNo ".toCharArray();
    _jsp_string31 = "<!-- \u7528\u6237 -->ID<br>\r\n	 			@param right \uff08y/n\uff09  ".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string17 = "\r\n				@param modeId ".toCharArray();
    _jsp_string47 = "<!-- \u5916\u90e8\u7cfb\u7edf\u8c03\u7528\u63a5\u53e3\u7684\u793a\u4f8b\u4ee3\u7801 --></div></td>\r\n			<td class=\"e8_tblForm_field\">\r\n				<a href=\"/weaver/weaver.formmode.servelt.DownloadFile?filename=/formmode/setup/webservice_example.rar\">".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string3 = "_wev8.js\"></script>\r\n	<script type=\"text/javascript\" src=\"/wui/theme/ecology8/jquery/js/zDialog_wev8.js\"></script>\r\n	\r\n	\r\n	<LINK type=\"text/css\" rel=\"stylesheet\" href=\"/formmode/css/pub_wev8.css?d=20140616\" />\r\n	<script type=\"text/javascript\" >\r\n	function isdel(){\r\n	  var str = \"".toCharArray();
    _jsp_string44 = "<!-- \u5ba2\u6237\u7aef\u751f\u6210\u8bf4\u660e --><div class=\"e8_label_desc\"></div></td>\r\n			<td class=\"e8_tblForm_field\" width=\"80%\">\r\n			".toCharArray();
    _jsp_string35 = "\r\n			</td>\r\n		</tr>\r\n		<tr>\r\n			<td class=\"e8_tblForm_label\" >".toCharArray();
    _jsp_string16 = "<!-- \u8f93\u5165\u53c2\u6570 --><div class=\"e8_label_desc\"></div></td>\r\n			<td class=\"e8_tblForm_field\" width=\"80%\">\r\n			".toCharArray();
    _jsp_string27 = "<!-- \u7528\u6237 -->ID<br>\r\n				@param conditions ".toCharArray();
    _jsp_string19 = "<!-- \u5f53\u524d\u9875\u6570 --><br>\r\n				@param pageSize ".toCharArray();
    _jsp_string8 = "<!-- \u8bf4\u660e --></td>\r\n			<td class=\"e8_tblForm_field\">\r\n			".toCharArray();
    _jsp_string10 = "<!-- \u83b7\u53d6\u8868\u5355\u6570\u636e\u5217\u8868\uff08\u5206\u9875\uff09 -->\r\n			".toCharArray();
  }
}
