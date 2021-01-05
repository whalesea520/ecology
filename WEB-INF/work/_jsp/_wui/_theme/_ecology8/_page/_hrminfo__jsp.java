/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._wui._theme._ecology8._page;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.io.*;
import java.util.*;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;
import weaver.general.Util;
import weaver.file.Prop;
import java.text.*;
import weaver.general.TimeUtil;
import weaver.systeminfo.SystemEnv;
import weaver.general.GCONST;
import weaver.rtx.RTXExtCom;
import weaver.hrm.settings.BirthdayReminder;
import weaver.hrm.settings.RemindSettings;
import weaver.systeminfo.setting.HrmUserSettingHandler;
import weaver.systeminfo.setting.HrmUserSetting;
import weaver.hrm.report.schedulediff.HrmScheduleDiffUtil;
import weaver.login.Account;
import weaver.hrm.common.Tools;
import java.sql.Timestamp;
import java.util.Map;

public class _hrminfo__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  private String getCurrWuiConfig(HttpSession session, User user, String keyword) throws Exception {
  	
  	if (keyword == null || "".equals(keyword)) {
  		return "";
  	}
  	
  	String curTheme = "";
  	String curskin = "";
  
  	
  		String[] rtnValue = getHrmUserSetting(user);
  		
  		curTheme = rtnValue[0];
  		curskin = rtnValue[1];
  		if(curTheme.equals("")||curskin.equals("")){
  			String templatetype = getCurrE8TemplateType(user);
  			if("".equals(templatetype)){
  				curTheme = "ecologyBasic";
  				curskin = "default";
  			}else if("ecology7".equals(templatetype)){
  				curTheme ="ecology7";
  				curskin = getCurrE8SkinInfo(user);
  			}else{
  				curTheme ="ecology8";
  				curskin = "default";
  			}
  			
  			
  			
  			
  		}else{
  			curTheme = rtnValue[0];
  			curskin = rtnValue[1];
  		}
  		
  		if(curTheme.equals("custom")){
  			curTheme ="ecology8";
  		}
  		
  		session.setAttribute("SESSION_CURRENT_THEME", curTheme);
  		session.setAttribute("SESSION_CURRENT_SKIN", curskin);
  	
  	if ("THEME".equals(keyword.toUpperCase())) {
  		return curTheme;
  	}
  	
  	if ("SKIN".equals(keyword.toUpperCase())) {
  		return curskin;
  	}
  	return "";
  }
  
  
  
  private String getCurrSkinFolder(User user) throws Exception {
  	String pslSkinfolder = "";
  	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
  
  	int userid = user.getUID();
  
  	rs.executeSql("select skin from HrmUserSetting where resourceId=" + userid);
  	
  	if (rs.next()) {
  		pslSkinfolder = rs.getString("skin");
  	}
  
  	if (pslSkinfolder == null || "".equals(pslSkinfolder)) {
  	    pslSkinfolder = "default";
  	}
  	return pslSkinfolder;
  }
  
  private String getCurrE8TemplateType(User user){
  	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
  	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
  	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
  	
  	
  	String skin =  userTemplate.getTemplatetype();
  	
  	
  	return skin;
  	
  }
  
  private String getCurrE8SkinInfo(User user){
  	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
  	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
  	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
  	
  	
  	String skin =  userTemplate.getSkin();
  	
  	
  	return skin;
  	
  }
  
  private int getCurrTemplateId(User user){
  	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
  	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
  	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
  	
  	
  	int id =  userTemplate.getTemplateId();
  	
  	
  	return id;
  	
  }
  
  private String getCurrTemplateLogo(User user){
  	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
  	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
  	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
  	
  	
  	String logo =  userTemplate.getLogo();
  	
  	
  	return logo;
  	
  }
  
  private String[] getHrmUserSetting(User user) throws Exception {
  	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
  
  	String[] result = new String[2];
  	String theme = "";
  	String skin = "";
  	
  	String sql="select templateid from SystemTemplateSubComp where subcompanyid="+user.getUserSubCompany1();
  	rs.executeSql(sql);
  	if(rs.next()){	
  	
  		String curUserCanUse = rs.getString("templateid");
  		sql = "SELECT a.* FROM HrmUserSetting a, SystemTemplate  b WHERE a.resourceId="+user.getUID()+" AND a.templateId=b.id  and  b.id="+curUserCanUse;
  		rs.execute(sql);
  		if(rs.next()){
  			theme = rs.getString("theme");
  			skin = rs.getString("skin");
  			if("ecology8".equals(theme)){
  				skin = "default";
  			}
  			result[0] = theme;
  			result[1] = skin;
  			return result;
  		}
  	}
  	
  	
  
  	
  	int userid = user.getUID();
  	rs.executeSql("select theme, skin from HrmUserSetting where resourceId=" + userid);
  	
  	if (rs.next()) {
  		theme = rs.getString("theme");
  		skin = rs.getString("skin");
  	}
  	
  	//rs.executeSql("select * from extandHpThemeItem where extandHpThemeId=" + sqltemplateid1 + " and isopen=1 and theme='" + theme + "' and skin='" + skin + "'");
  	result[0] = theme;
  	result[1] = skin;
  	
  	
  	
  	//System.out.println("result"+result[0]+result[1]);
  	return result;
  }
  
  
  private java.util.Map getPageConfigInfo(HttpSession session, User user) throws Exception{
  	
  	weaver.conn.RecordSet rs = new weaver.conn.RecordSet();
  	java.util.Map pageConfigkv = new java.util.HashMap();
  	
  	weaver.systeminfo.template.UserTemplate  userTemplate = new weaver.systeminfo.template.UserTemplate();
  	userTemplate.getTemplateByUID(user.getUID(),user.getUserSubCompany1());
  	
  	pageConfigkv.put("logoTop",userTemplate.getLogo());
  	pageConfigkv.put("logoBottom", userTemplate.getLogo());
  	pageConfigkv.put("isopen", userTemplate.getIsopen());
  	//pageConfigkv.put("islock", rs.getString("islock"));
  	
  	int extendtempletvalueid = userTemplate.getExtendtempletvalueid();
  	rs.executeSql("select * from extandHpThemeItem where extandHpThemeId=" + extendtempletvalueid + " and isopen=1 and theme='" + getCurrWuiConfig(session, user, "THEME") + "' and skin='" + getCurrWuiConfig(session, user, "SKIN") + "'");
  	
  	if (rs.next()) {
  	
  		
  		/**
  		 * ecologybasic\u4e3b\u9898\u7528\u8bbe\u7f6e\u9879
  		 */
  		pageConfigkv.put("bodyBg", rs.getString("bodyBg"));
  		pageConfigkv.put("topBgImage", rs.getString("topBgImage"));
  		pageConfigkv.put("toolbarBgColor", rs.getString("toolbarBgColor"));
  		pageConfigkv.put("menuborderColor", rs.getString("menuborderColor"));
  
  		pageConfigkv.put("leftbarBgImage", rs.getString("leftbarBgImage"));
  		pageConfigkv.put("leftbarBgImageH", rs.getString("leftbarBgImageH"));
  
  		pageConfigkv.put("leftbarborderColor", rs.getString("leftbarborderColor"));
  		pageConfigkv.put("leftbarFontColor", rs.getString("leftbarFontColor"));
  
  		pageConfigkv.put("topleftbarBgImage_left", rs.getString("topleftbarBgImage_left"));
  		pageConfigkv.put("topleftbarBgImage_center", rs.getString("topleftbarBgImage_center"));
  		pageConfigkv.put("topleftbarBgImage_right", rs.getString("topleftbarBgImage_right"));
  
  		pageConfigkv.put("bottomleftbarBgImage_left", rs.getString("bottomleftbarBgImage_left"));
  		pageConfigkv.put("bottomleftbarBgImage_center", rs.getString("bottomleftbarBgImage_center"));
  		pageConfigkv.put("bottomleftbarBgImage_right", rs.getString("bottomleftbarBgImage_right"));
  
  	}
  	
  	return pageConfigkv;
  	
  }


  
  	private String formatDate(String format, Date date) {
  		SimpleDateFormat sdf = new SimpleDateFormat(format);
  		Calendar calendar = Calendar.getInstance();
  		if (date == null) {
  			date = new Date();
  		}
  		calendar.setTime(date);
  		return sdf.format(calendar.getTime());
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
      weaver.hrm.company.DepartmentComInfo DepartmentComInfo;
      DepartmentComInfo = (weaver.hrm.company.DepartmentComInfo) pageContext.getAttribute("DepartmentComInfo");
      if (DepartmentComInfo == null) {
        DepartmentComInfo = new weaver.hrm.company.DepartmentComInfo();
        pageContext.setAttribute("DepartmentComInfo", DepartmentComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.license.PluginUserCheck PluginUserCheck;
      PluginUserCheck = (weaver.license.PluginUserCheck) pageContext.getAttribute("PluginUserCheck");
      if (PluginUserCheck == null) {
        PluginUserCheck = new weaver.license.PluginUserCheck();
        pageContext.setAttribute("PluginUserCheck", PluginUserCheck);
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
      weaver.hrm.job.JobTitlesComInfo JobTitlesComInfo;
      JobTitlesComInfo = (weaver.hrm.job.JobTitlesComInfo) pageContext.getAttribute("JobTitlesComInfo");
      if (JobTitlesComInfo == null) {
        JobTitlesComInfo = new weaver.hrm.job.JobTitlesComInfo();
        pageContext.setAttribute("JobTitlesComInfo", JobTitlesComInfo);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      weaver.conn.RecordSet signRs;
      signRs = (weaver.conn.RecordSet) pageContext.getAttribute("signRs");
      if (signRs == null) {
        signRs = new weaver.conn.RecordSet();
        pageContext.setAttribute("signRs", signRs);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      weaver.workflow.workflow.TestWorkflowCheck TestWorkflowCheckInitWui;
      TestWorkflowCheckInitWui = (weaver.workflow.workflow.TestWorkflowCheck) pageContext.getAttribute("TestWorkflowCheckInitWui");
      if (TestWorkflowCheckInitWui == null) {
        TestWorkflowCheckInitWui = new weaver.workflow.workflow.TestWorkflowCheck();
        pageContext.setAttribute("TestWorkflowCheckInitWui", TestWorkflowCheckInitWui);
      }
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.println(TestWorkflowCheckInitWui.ReloadByDialogClose(request));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      
    if(TestWorkflowCheckInitWui.checkURI(session,request.getRequestURI(),request.getQueryString())){
        response.sendRedirect("/login/Login.jsp");
        return;
    }

      out.write(_jsp_string2, 0, _jsp_string2.length);
      
/*\u7528\u6237\u9a8c\u8bc1*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
  response.sendRedirect("/login/Login.jsp");
  return;
}

int userId=user.getUID();
boolean canMessager=false;
boolean isHaveEMessager=Prop.getPropValue("Messager2","IsUseEMessager").equalsIgnoreCase("1");
boolean isHaveMessager=Prop.getPropValue("Messager","IsUseWeaverMessager").equalsIgnoreCase("1");
int isHaveMessagerRight = PluginUserCheck.checkPluginUserRight("messager",userId+"");
if((isHaveMessager&&userId!=1&&isHaveMessagerRight==1)||isHaveEMessager){
	canMessager=true;
}

String strDepartment=DepartmentComInfo.getDepartmentname(String.valueOf(user.getUserDepartment()));

      out.write(_jsp_string2, 0, _jsp_string2.length);
      
Map pageConfigKv = getPageConfigInfo(session, user);
String islock = (String)pageConfigKv.get("islock");

      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((SystemEnv.getHtmlLabelName(28062,user.getLanguage())));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((user.getLoginid()));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      out.print((user.getLastname()));
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((user.getLastname() ));
      out.write(_jsp_string9, 0, _jsp_string9.length);
      

//\u591a\u8d26\u53f7
String userid = ""+user.getUID() ;

      out.write(_jsp_string10, 0, _jsp_string10.length);
      if(weaver.general.GCONST.getMOREACCOUNTLANDING()){
      out.write(_jsp_string11, 0, _jsp_string11.length);
      List accounts =(List)session.getAttribute("accounts");
    	if(accounts!=null&&accounts.size()>1){
        	Iterator iter=accounts.iterator();
        	int tmpCount = 0;
	
      out.write(_jsp_string12, 0, _jsp_string12.length);
       while(iter.hasNext()){
			        			Account a=(Account)iter.next();
				            	String subcompanyname=SubCompanyComInfo.getSubCompanyname(""+a.getSubcompanyid());
				              	String departmentname=DepartmentComInfo.getDepartmentname(""+a.getDepartmentid());
				            	String jobtitlename=JobTitlesComInfo.getJobTitlesname(""+a.getJobtitleid());  
				            	String userName = ResourceComInfo.getResourcename(""+a.getId());
				            
      out.write(_jsp_string13, 0, _jsp_string13.length);
      out.print((a.getId() ));
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((userName ));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((userName));
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((jobtitlename ));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((jobtitlename ));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      out.print((subcompanyname +"/"+departmentname ));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((subcompanyname +"/"+departmentname ));
      out.write(_jsp_string18, 0, _jsp_string18.length);
      if(userid.equals(a.getId()+"")){ 
      out.write(_jsp_string19, 0, _jsp_string19.length);
      } 
      out.write(_jsp_string20, 0, _jsp_string20.length);
      if(++tmpCount < accounts.size()) {
      out.write(_jsp_string21, 0, _jsp_string21.length);
      } 
      out.write(_jsp_string22, 0, _jsp_string22.length);
      } 
      out.write(_jsp_string23, 0, _jsp_string23.length);
      }else{
      out.write(_jsp_string24, 0, _jsp_string24.length);
      out.print((strDepartment));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((strDepartment));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      }} else {
      out.write(_jsp_string26, 0, _jsp_string26.length);
      out.print((strDepartment));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      out.print((strDepartment));
      out.write(_jsp_string25, 0, _jsp_string25.length);
      } 
      out.write(_jsp_string27, 0, _jsp_string27.length);
      
			boolean isHaveMessagerUrl=false;
			String messagerUrl=ResourceComInfo.getMessagerUrls(""+userId);
			if(messagerUrl.indexOf("dummyContact_wev8.png")==-1) isHaveMessagerUrl=true;
		
      out.write(_jsp_string28, 0, _jsp_string28.length);
      if(isHaveMessagerUrl){
      out.write(_jsp_string29, 0, _jsp_string29.length);
      out.print((ResourceComInfo.getMessagerUrls(""+userId)));
      out.write(_jsp_string30, 0, _jsp_string30.length);
      out.print((SystemEnv.getHtmlLabelName(28062,user.getLanguage())));
      out.write(_jsp_string31, 0, _jsp_string31.length);
      }
      out.write(_jsp_string32, 0, _jsp_string32.length);
      out.print((userid));
      out.write(_jsp_string33, 0, _jsp_string33.length);
      out.print((SystemEnv.getHtmlLabelName(1515,user.getLanguage())));
      out.write(_jsp_string34, 0, _jsp_string34.length);
      out.print((SystemEnv.getHtmlLabelName(1207,user.getLanguage())));
      out.write(_jsp_string35, 0, _jsp_string35.length);
      out.print((SystemEnv.getHtmlLabelName(27603,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      out.print((SystemEnv.getHtmlLabelName(26274,user.getLanguage())));
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((userId));
      out.write(_jsp_string38, 0, _jsp_string38.length);
      out.print((SystemEnv.getHtmlLabelName(16415,user.getLanguage())));
      out.write(_jsp_string39, 0, _jsp_string39.length);
      out.print((userId));
      out.write(_jsp_string40, 0, _jsp_string40.length);
      out.print((SystemEnv.getHtmlLabelName(17993,user.getLanguage())));
      out.write(_jsp_string41, 0, _jsp_string41.length);
      if(canMessager){
      out.write(_jsp_string42, 0, _jsp_string42.length);
      }
      out.write(_jsp_string43, 0, _jsp_string43.length);
      out.print((SystemEnv.getHtmlLabelName(16455,user.getLanguage())));
      out.write(_jsp_string44, 0, _jsp_string44.length);
      out.print((SystemEnv.getHtmlLabelName(2211,user.getLanguage())));
      out.write(_jsp_string45, 0, _jsp_string45.length);
      if(canMessager){
      out.write(_jsp_string46, 0, _jsp_string46.length);
      } else {
      out.write(_jsp_string47, 0, _jsp_string47.length);
      }
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("wui/theme/ecology8/page/hrmInfo.jsp"), 6246113175426829630L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("wui/common/page/initWui.jsp"), 3390533274175540290L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string25;
  private final static char []_jsp_string47;
  private final static char []_jsp_string44;
  private final static char []_jsp_string37;
  private final static char []_jsp_string35;
  private final static char []_jsp_string13;
  private final static char []_jsp_string29;
  private final static char []_jsp_string17;
  private final static char []_jsp_string32;
  private final static char []_jsp_string9;
  private final static char []_jsp_string42;
  private final static char []_jsp_string15;
  private final static char []_jsp_string18;
  private final static char []_jsp_string22;
  private final static char []_jsp_string5;
  private final static char []_jsp_string11;
  private final static char []_jsp_string12;
  private final static char []_jsp_string41;
  private final static char []_jsp_string4;
  private final static char []_jsp_string39;
  private final static char []_jsp_string43;
  private final static char []_jsp_string8;
  private final static char []_jsp_string33;
  private final static char []_jsp_string26;
  private final static char []_jsp_string16;
  private final static char []_jsp_string27;
  private final static char []_jsp_string36;
  private final static char []_jsp_string46;
  private final static char []_jsp_string14;
  private final static char []_jsp_string21;
  private final static char []_jsp_string10;
  private final static char []_jsp_string45;
  private final static char []_jsp_string6;
  private final static char []_jsp_string28;
  private final static char []_jsp_string38;
  private final static char []_jsp_string3;
  private final static char []_jsp_string34;
  private final static char []_jsp_string1;
  private final static char []_jsp_string31;
  private final static char []_jsp_string24;
  private final static char []_jsp_string30;
  private final static char []_jsp_string0;
  private final static char []_jsp_string48;
  private final static char []_jsp_string19;
  private final static char []_jsp_string7;
  private final static char []_jsp_string40;
  private final static char []_jsp_string23;
  private final static char []_jsp_string2;
  private final static char []_jsp_string20;
  static {
    _jsp_string25 = "</a></div>\r\n".toCharArray();
    _jsp_string47 = "\r\n					&nbsp;\r\n					".toCharArray();
    _jsp_string44 = "'  target=\"mainFrame\" style><span style=\"cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(/wui/theme/ecology8/page/images/hrminfo/org_wev8.png) no-repeat;\"></span></a></td>-->\r\n				<!--  <td width=\"24px\"><a  href=\"/workplan/data/WorkPlan.jsp\" title='".toCharArray();
    _jsp_string37 = "'    target=\"mainFrame\" style><span  class=\"quickImg\"  style=\"background:url(/wui/theme/ecology8/page/images/theme_wev8.png) no-repeat;\"></span></a></td>\r\n				<!--<td width=\"24px\"><a  href=\"/hrm/resource/HrmResource.jsp?id=".toCharArray();
    _jsp_string35 = "'    target=\"mainFrame\" style><span class=\"quickImg\"  style=\"background:url(/wui/theme/ecology8/page/images/request/unhandle_wev8.png) no-repeat;\"></span></a></td>\r\n				\r\n				<td><a  href=\"#\" title='".toCharArray();
    _jsp_string13 = "\r\n				            \r\n							<div class=\"accountItem \" userid=\"".toCharArray();
    _jsp_string29 = "\r\n		<img src=\"".toCharArray();
    _jsp_string17 = "</font>\r\n										<br>\r\n										<font color=\"#868686\"  title=\"".toCharArray();
    _jsp_string32 = "\r\n	</div>\r\n	<script type=\"text/javascript\">\r\n	 jQuery(document).ready(function(){\r\n        if(\"".toCharArray();
    _jsp_string9 = "\r\n	   \r\n	</div>\r\n".toCharArray();
    _jsp_string42 = "	\r\n				<td ><div class=\"quickImg\" id=\"tdMessageState\" style=\"cursor:pointer;font-size:11px;color:#666;position:relative;background:url(/wui/theme/ecology8/page/images/request/info_wev8.png) no-repeat;\"></div>	</td>\r\n				".toCharArray();
    _jsp_string15 = "\">".toCharArray();
    _jsp_string18 = "</font>\r\n									</div >\r\n									\r\n									<div class=\"accountIcon\">\r\n									".toCharArray();
    _jsp_string22 = "\r\n							".toCharArray();
    _jsp_string5 = "\r\n\r\n<script language=javascript> \r\n//------------------------------------\r\n//\u591a\u8d26\u53f7 Start\r\n//------------------------------------\r\nfunction onCheckTime(obj){\r\n	window.location = \"/login/IdentityShift.jsp?shiftid=\"+obj.value;\r\n}\r\n\r\nfunction changeAccount(obj){\r\n	window.location = \"/login/IdentityShift.jsp?shiftid=\"+$(obj).attr(\"userid\");\r\n}\r\n\r\nvar firstTime = new Date().getTime();\r\nfunction setAccountSelect(){\r\n    var nowTime = new Date().getTime();\r\n    if((nowTime-firstTime) < 10000){\r\n    	setTimeout(function(){setAccountSelect();},1000);\r\n    }else{\r\n        try{\r\n            document.getElementById(\"accountSelect\").disabled = false;\r\n            jQuery(\"#accountText\").html(jQuery(\"#accountSelect\").find(\"option:selected\").text());\r\n			jQuery(\"#accountText\").attr(\"title\", jQuery(\"#accountSelect\").find(\"option:selected\").text());\r\n			jQuery(\"#accountSelect\").hide();\r\n			jQuery(\"#accountText\").show();\r\n        }catch(e){}\r\n    }\r\n}\r\nsetAccountSelect();\r\n\r\njQuery(document).ready(function () {\r\n	\r\n	if (jQuery(\"#accountSelect\")[0]) {\r\n		jQuery(\"#leftBlockHrmDep\").hover(function () {\r\n			jQuery(\"#accountText\").html(\"\");\r\n			jQuery(\"#accountText\").hide();\r\n			jQuery(\"#accountSelect\").show();\r\n			jQuery(\"#accountSelect\").focus();\r\n		}, function () {\r\n		});\r\n		jQuery(\"#accountSelect\").bind(\"blur\", function () {\r\n			jQuery(\"#accountText\").html(jQuery(\"#accountSelect\").find(\"option:selected\").text());\r\n			jQuery(\"#accountText\").attr(\"title\", jQuery(\"#accountSelect\").find(\"option:selected\").text());\r\n			jQuery(\"#accountSelect\").hide();\r\n			jQuery(\"#accountText\").show();\r\n		});\r\n	}\r\n});\r\n\r\n//\u8bbe\u7f6e\u4e2a\u4eba\u5934\u50cf\r\nvar userIconDialog;\r\nfunction setUserIcon(){\r\n    userIconDialog = new Dialog();\r\n	userIconDialog.Width = 600;\r\n	userIconDialog.Height = 450;\r\n	userIconDialog.Title = \"".toCharArray();
    _jsp_string11 = "\r\n	\r\n	".toCharArray();
    _jsp_string12 = "\r\n		<!-- <select id=\"accountSelect\" name=\"accountSelect\" onchange=\"onCheckTime(this);\"  disabled style=\"width:100px;height:20px;font-size:11px;\">\r\n			\r\n            \r\n        </select>\r\n        -->\r\n      \r\n         <div id=\"accountChange\" class=\"\" style=\"float:left;position: relative;margin-left:20px\" >\r\n			        		\r\n			        		\r\n			        	<img onclick=\"showAccoutList()\" id=\"accoutImg\"  src=\"/wui/theme/ecology8/page/images/hrminfo/accout_wev8.png\" style=\"position:absolute;top:13px;cursor:pointer;\">\r\n		        		\r\n			        	<div class=\"accoutList\" id=\"accoutList\" style=\"display: none;\">\r\n			        		<div style=\"height:10px;width:15px;z-index:101;top: 0px;position: absolute;background:url(/images/topnarrow.png) no-repeat;\"></div>\r\n			        		<div class=\"accoutListBox\" style=\"max-height: 600px;overflow: hidden;\">\r\n			        		".toCharArray();
    _jsp_string41 = "'   target=\"mainFrame\" style><span class=\"quickImg\"  style=\"background:url(/wui/theme/ecology8/page/images/hrminfo/psw_wev8.png) no-repeat;\"></span></a></td>\r\n				".toCharArray();
    _jsp_string4 = "\r\n}\r\n\r\nfunction doScannerEscape(ev, obj){\r\n	IMCarousel.doScannerEscape(ev, obj);\r\n}\r\n\r\nfunction scaleImg(obj, tag){\r\n	IMCarousel.scaleImg(obj, tag);\r\n}\r\n\r\nfunction rotateImg(obj){\r\n	IMCarousel.rotateImg(obj);\r\n}\r\n\r\nfunction downloadImg(obj){\r\n	IMCarousel.downloadImg(obj);\r\n}\r\n\r\nfunction slideImg(obj, direction){\r\n	IMCarousel.slideImg(obj, direction);\r\n}\r\n\r\nfunction showImgScanner(ev, isShow, id){\r\n	IMCarousel.showImgScanner(ev, isShow, id);\r\n}\r\n\r\nfunction downloads(id){\r\n	document.location.href=\"/weaver/weaver.file.FileDownload?fileid=\"+id+\"&download=1\";\r\n}\r\n</script>\r\n".toCharArray();
    _jsp_string39 = "'    target=\"mainFrame\" style><span style=\"cursor:pointer;height:16px;width:16px;display:block;overflow:hidden;background:url(/wui/theme/ecology8/page/images/hrminfo/card_wev8.png) no-repeat;\"></span></a></td>-->\r\n				<td width=\"24px\"><a  href=\"/hrm/resource/HrmResourcePassword.jsp?id=".toCharArray();
    _jsp_string43 = "\r\n				<!--<td width=\"24px\"><a  href=\"/org/OrgChartHRM.jsp\" title='".toCharArray();
    _jsp_string8 = "\" class=\"hrminfo_fontcolor leftColor hand\" style=\"max-width:100px;float: left;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;\" onclick=\"window.open('/hrm/HrmTab.jsp?_fromURL=HrmResource','mainFrame')\">\r\n	   ".toCharArray();
    _jsp_string33 = "\"==\"1\"){\r\n        	jQuery(userIcon).removeAttr(\"onclick\");\r\n        	jQuery(userIcon).removeAttr(\"title\");\r\n        }\r\n\r\n    });\r\n	</script>\r\n	<div  class=\"more\" style=\"display:none;\">\r\n		<table cellpadding=\"0px\" cellspacing=\"0px\" id=\"tblHrmToolbr\" align=\"left\">\r\n			<tr>\r\n				<!-- \u89e3\u51b3\u56e0ie6\u4e0bpng\u900f\u660e\u5f15\u8d77img\u56fe\u7247\u7a7a\u767d\u663e\u793a\u7684bug -->\r\n				<td ><a  href=\"/newportal/contactslist.jsp\"  title='".toCharArray();
    _jsp_string26 = "\r\n	<div id=\"leftBlockHrmDep\"  style=\"float:left;cursor:default;overflow:hidden;width: 100px;\" class=\"leftBlockHrmDep leftColor\" title=\"".toCharArray();
    _jsp_string16 = "</font>&nbsp;&nbsp;&nbsp;&nbsp;<font color=\"#0071ca\" title=\"".toCharArray();
    _jsp_string27 = "\r\n	\r\n		\r\n\r\n	<div  style=\"position:absolute;width:41px;height:41px;left:14px;top:17px;display:none;\">\r\n		".toCharArray();
    _jsp_string36 = "'    target=\"mainFrame\" style><span  class=\"quickImg\"  style=\"background:url(/wui/theme/ecology8/page/images/email/email_wev8.png) no-repeat;\"></span></a></td>\r\n				<td><a  href=\"#\" title='".toCharArray();
    _jsp_string46 = "					\r\n						<div id=\"tdMessageState\" style=\"cursor:pointer;font-size:11px;color:#666;position:relative;\"></div>	\r\n					".toCharArray();
    _jsp_string14 = "\" onclick=\"changeAccount(this)\">\r\n									<div class=\"accountText\">\r\n										<font color=\"#363636\" title=\"".toCharArray();
    _jsp_string21 = "\r\n							<div style=\"background-color:#d4d4d4;height:1px;width:188px;\"></div>\r\n							".toCharArray();
    _jsp_string10 = "	\r\n".toCharArray();
    _jsp_string45 = "'  target=\"mainFrame\" style><img  src=\"/wui/theme/ecology8/page/images/hrminfo/cal_wev8.gif\" border=\"0\"></a></td>-->\r\n				<!--<td  align=\"left\">\r\n					".toCharArray();
    _jsp_string6 = "\";//\u8bbe\u7f6e\u4e2a\u4eba\u5934\u50cf\r\n	userIconDialog.Modal  = false;\r\n	userIconDialog.URL = \"/messager/GetUserIcon.jsp?loginid=".toCharArray();
    _jsp_string28 = "\r\n		".toCharArray();
    _jsp_string38 = "\"title='".toCharArray();
    _jsp_string3 = "\r\n<LINK href=\"/js/jquery/jquery_dialog_wev8.css\" type=text/css rel=STYLESHEET>\r\n<script type=\"text/javascript\" src=\"/wui/common/jquery/jquery.min_wev8.js\"></script>\r\n<script type=\"text/javascript\" language=\"javascript\" src=\"/js/jquery/jquery_dialog_wev8.js\"></script>\r\n\r\n<script src=\"/social/js/drageasy/drageasy.js\"></script>\r\n<script type=\"text/javascript\" src=\"/social/js/bootstrap/js/bootstrap.js\"></script>\r\n<script type=\"text/javascript\" src=\"/social/im/js/IMUtil_wev8.js\"></script>\r\n\r\n<script type=\"text/javascript\" src=\"/social/js/imcarousel/imcarousel.js\"></script>\r\n<script type=\"text/javascript\" language=\"javascript\">\r\nfunction ReloadOpenerByDialogClose() {\r\n    ".toCharArray();
    _jsp_string34 = "'   target=\"mainFrame\" style><span  class=\"quickImg\" style=\"background:url(/wui/theme/ecology8/page/images/hrminfo/address_wev8.png) no-repeat;\"></span></a></td>\r\n				<td ><a  href=\"/workflow/request/RequestView.jsp\" title='".toCharArray();
    _jsp_string1 = "\r\n".toCharArray();
    _jsp_string31 = "\" id=\"userIcon\" style=\"cursor: pointer;\">\r\n		".toCharArray();
    _jsp_string24 = "\r\n	<div id=\"leftBlockHrmDep\"  style=\"float:left; cursor:default;overflow:hidden;width: 100px;\" class=\"leftBlockHrmDep leftColor\" title=\"".toCharArray();
    _jsp_string30 = "\" border=\"0\" width=\"38\" height=\"37\" onclick=\"setUserIcon()\" title=\"".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string48 = "\r\n				</td>-->\r\n			</tr>\r\n		</table>\r\n\r\n		\r\n	</div>\r\n</div>\r\n\r\n\r\n<script type=\"text/javascript\">\r\n	$('.accoutListBox').perfectScrollbar();\r\n</script>\r\n\r\n".toCharArray();
    _jsp_string19 = "\r\n										<img style=\"width: 16px;height: 16px;vertical-align: middle;\" src=\"/images/check.png\">\r\n									".toCharArray();
    _jsp_string7 = "&requestFrom=homepage\";\r\n	userIconDialog.show();\r\n   \r\n}\r\n\r\n</script> \r\n\r\n\r\n<div style=\"position:relative;height:100%\">\r\n\r\n    <!-- \u66f4\u6362\u76ae\u80a4\u8bbe\u7f6e Start -->\r\n    <div  style=\"position:absolute;left:63px;top:16px;font-size:12px;height:16px;right:0px;\">\r\n       <span style=\"float:right;\">\r\n      \r\n       </span>\r\n    </div>\r\n    <!-- \u66f4\u6362\u76ae\u80a4\u8bbe\u7f6e End -->\r\n    \r\n	<div title=\"".toCharArray();
    _jsp_string40 = "\" title='".toCharArray();
    _jsp_string23 = "\r\n							</div>\r\n						</div>\r\n		</div>	\r\n       \r\n	".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
    _jsp_string20 = "\r\n									</div>\r\n									<div style=\"clear:both;\"></div>\r\n							</div>\r\n							".toCharArray();
  }
}