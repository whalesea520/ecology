/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._homepage._element;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.text.SimpleDateFormat;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class _elementpreview__jsp extends com.caucho.jsp.JavaPage
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
      weaver.page.PageUtil pu;
      pu = (weaver.page.PageUtil) pageContext.getAttribute("pu");
      if (pu == null) {
        pu = new weaver.page.PageUtil();
        pageContext.setAttribute("pu", pu);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.homepage.cominfo.HomepageElementCominfo hpec;
      hpec = (weaver.homepage.cominfo.HomepageElementCominfo) pageContext.getAttribute("hpec");
      if (hpec == null) {
        hpec = new weaver.homepage.cominfo.HomepageElementCominfo();
        pageContext.setAttribute("hpec", hpec);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.admincenter.homepage.WeaverBaseElementCominfo wbe;
      wbe = (weaver.admincenter.homepage.WeaverBaseElementCominfo) pageContext.getAttribute("wbe");
      if (wbe == null) {
        wbe = new weaver.admincenter.homepage.WeaverBaseElementCominfo();
        pageContext.setAttribute("wbe", wbe);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.page.element.ElementUtil eu;
      eu = (weaver.page.element.ElementUtil) pageContext.getAttribute("eu");
      if (eu == null) {
        eu = new weaver.page.element.ElementUtil();
        pageContext.setAttribute("eu", eu);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.page.PageCominfo pc;
      pc = (weaver.page.PageCominfo) pageContext.getAttribute("pc");
      if (pc == null) {
        pc = new weaver.page.PageCominfo();
        pageContext.setAttribute("pc", pc);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.general.BaseBean baseBean;
      baseBean = (weaver.general.BaseBean) pageContext.getAttribute("baseBean");
      if (baseBean == null) {
        baseBean = new weaver.general.BaseBean();
        pageContext.setAttribute("baseBean", baseBean);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.admincenter.homepage.WeaverPortalContainer wpc;
      wpc = (weaver.admincenter.homepage.WeaverPortalContainer) pageContext.getAttribute("wpc");
      if (wpc == null) {
        wpc = new weaver.admincenter.homepage.WeaverPortalContainer();
        pageContext.setAttribute("wpc", wpc);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      	
	
	String ebaseid=Util.null2String(request.getParameter("ebaseid"));		
	String styleid=Util.null2String(request.getParameter("styleid"));
	String hpid=Util.null2String(request.getParameter("hpid"));
	int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),-1);
	String layoutflag=Util.null2String(request.getParameter("layoutflag"));
	String addType = Util.null2String(request.getParameter("addType"));
	String fromModule = Util.null2String(request.getParameter("fromModule"));
    boolean isSystemer=false;
	//int opreateLevel=cscr.ChkComRightByUserRightCompanyId(user.getUID(),"homepage:Maint",subCompanyId);
    if(HrmUserVarify.checkUserRight("homepage:Maint", user)) isSystemer=true;
    
    ArrayList list = pu.getShareMaintListByUser(user.getUID()+"");
    if(list.indexOf(hpid)!=-1){
    	isSystemer=true;
    }
    //if(opreateLevel>0&&subCompanyId!=-1)  isSystemer=true;
	
	int maxEid=0;
	String managerStr="0";
	if(isSystemer)  managerStr="1";

	//\u6c42\u7528\u6237\u7684ID\u4e0e\u5206\u90e8ID
	int userid=pu.getHpUserId(hpid,""+subCompanyId,user);
	int usertype=pu.getHpUserType(hpid,""+subCompanyId,user);
	if(pc.getSubcompanyid(hpid).equals("-1")&&pc.getCreatortype(hpid).equals("0")){
		userid =1;
		usertype=0;
	}else if("0".equals(hpid)&&subCompanyId==0){
		userid =1;
		usertype=0;
	}
	
	if(Util.getIntValue(hpid)<0) {//\u534f\u540c\u7684 userid  \u548c usertype \u4e3a 1  \u548c 0
		userid =1;
		usertype=0;
	}
	//\u6dfb\u52a0\u5143\u7d20
	String strSql="insert into hpElement(title,logo,islocked,ebaseid,isSysElement,hpid,styleid,marginTop,shareuser,scrolltype,fromModule,isuse) values('"+(user.getLanguage()==8?wbe.getTitleEN(ebaseid):wbe.getTitle(ebaseid))+"','"+wbe.getElogo(ebaseid)+"','0','"+ebaseid+"','"+managerStr+"',"+hpid+",'"+styleid+"','10','5_1','None','"+fromModule+"',1)";
	rs.executeSql(strSql);

	rs.executeSql("select max(id) from hpElement");
	if(rs.next()){
		maxEid=Util.getIntValue(rs.getString(1));
	}
	hpec.addHpElementCache(""+maxEid);

    String strUpdateSql="";
    if("Portal".equals(fromModule)){
	    if("".equals(addType)){
	    	//\u5148\u67e5\u8be2\u662f\u5426\u5b58\u5728\u6570\u636e
	    	rs.executeSql("select * from hplayout where hpid="+hpid+" and userid="+userid +" and usertype="+usertype);
	    	if(rs.next()){//\u7f16\u8f91
			    if (rs.getDBType().equals("sqlserver")){
			        strUpdateSql="update hplayout set areaElements='"+maxEid+",'+areaElements where hpid="+hpid+" and  areaflag='"+layoutflag+"' and userid="+userid+" and usertype="+usertype;
			    }else{
			        strUpdateSql="update hplayout set areaElements='"+maxEid+",' || areaElements where hpid="+hpid+" and  areaflag='"+layoutflag+"' and userid="+userid+" and usertype="+usertype;
			    }
	    	}else{//\u65b0\u589e
	    		//\u83b7\u53d6 layoutbaseid,areaflag,areasize
	    		rs.execute("select * from hplayout where hpid="+hpid +" and areaflag='"+layoutflag+"' order by id desc");
	    	    if(rs.next()){
	    		    rs.execute("insert into hplayout(hpid,layoutbaseid,areaflag,areasize,areaElements,userid,usertype) values ("+hpid+","+rs.getString("layoutbaseid")+",'"+layoutflag+"','"+rs.getString("areasize")+"','"+maxEid+",',"+userid+","+usertype+")");
	    	    }
	    	}
	    }else{
	    	if (rs.getDBType().equals("sqlserver"))
		        strUpdateSql="update pagenewstemplatelayout set areaElements='"+maxEid+",'+areaElements where templateid="+hpid+" and  areaFlag='"+layoutflag+"'";
		    else
		        strUpdateSql="update pagenewstemplatelayout set areaElements='"+maxEid+",' || areaElements where templateid="+hpid+" and  areaFlag='"+layoutflag+"'";
	    }
	    baseBean.writeLog(strUpdateSql+" ");
	    rs.executeSql(strUpdateSql);
    }
    String date = new SimpleDateFormat("yyyy-MM-dd").format(new Date()).toString();
  	String time = new SimpleDateFormat("HH:mm:ss").format(new Date()).toString();
    String areaStr = "insert into hpareaelement(hpid,eid,ebaseid,userid,usertype,module,modelastdate,modelasttime,ordernum) values("+hpid+","+maxEid+",'"+ebaseid+"',"+userid+","+usertype+",'"+fromModule+"','"+date+"','"+time+"',0)";

	rs.executeSql(areaStr);
    //\u6dfb\u52a0\u5171\u4eab\u4fe1\u606f
	String strInsertSql = "insert into hpElementSettingDetail(hpid,eid,userid,usertype,perpage,linkmode,sharelevel) values("+hpid+","+maxEid+","+userid+","+usertype+","+wbe.getPerpage(ebaseid)+","+wbe.getLinkmode(ebaseid)+",'2')";

	rs.executeSql(strInsertSql);
	 out.println("<style type=\"text/css\">");
	 out.println(pu.getElementCss(hpid,""+maxEid));
	 out.println("</style>");
	 if("Portal".equals(fromModule)){
		 if("".equals(addType)){
			 out.println(eu.getContainer(ebaseid,""+maxEid,hpid,styleid,"0","2",user,subCompanyId,userid,usertype,true));
		 }else{
			 out.println(eu.getContainer(ebaseid,""+maxEid,hpec.getStyleid(""+maxEid),user,true));
		 }
	 }else{
		 out.println(wpc.getElementFrame(ebaseid,""+maxEid,user));
	 }

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("homepage/element/ElementPreview.jsp"), -817833151333932044L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string3;
  private final static char []_jsp_string0;
  private final static char []_jsp_string2;
  private final static char []_jsp_string1;
  static {
    _jsp_string3 = "	\r\n    ".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n".toCharArray();
    _jsp_string1 = "  \r\n".toCharArray();
  }
}