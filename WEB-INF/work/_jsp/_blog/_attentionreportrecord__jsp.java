/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._blog;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.*;
import weaver.hrm.*;
import weaver.systeminfo.*;
import weaver.general.StaticObj;
import weaver.general.Util;
import weaver.hrm.settings.RemindSettings;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import weaver.blog.WorkDayDao;
import weaver.blog.BlogReportManager;
import weaver.blog.BlogManager;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class _attentionreportrecord__jsp extends com.caucho.jsp.JavaPage
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
      weaver.hrm.resource.ResourceComInfo ResourceComInfo;
      ResourceComInfo = (weaver.hrm.resource.ResourceComInfo) pageContext.getAttribute("ResourceComInfo");
      if (ResourceComInfo == null) {
        ResourceComInfo = new weaver.hrm.resource.ResourceComInfo();
        pageContext.setAttribute("ResourceComInfo", ResourceComInfo);
      }
      out.write(_jsp_string2, 0, _jsp_string2.length);
      
  String userid=""+user.getUID();
  Calendar calendar=Calendar.getInstance();
  int currentMonth=calendar.get(Calendar.MONTH)+1;
  int currentYear=calendar.get(Calendar.YEAR);
  String type=Util.null2String(request.getParameter("type"));
  int year=Util.getIntValue(request.getParameter("year"),currentYear);
  int month=Util.getIntValue(request.getParameter("month"),currentMonth);
  String monthStr=month<10?("0"+month):(""+month);
  BlogReportManager reportManager=new BlogReportManager();
  reportManager.setUser(user);
  Map resultMap=new HashMap();
  int allUnsubmit=0;
  int allWorkday=0;
  double allWorkIndex=0;
  if("blog".equals(type)){
	  resultMap=reportManager.getBlogAttentionReport(userid,year,month);
	  allUnsubmit=((Integer)resultMap.get("allUnsubmit")).intValue();      //\u88ab\u5173\u6ce8\u4eba\u672a\u63d0\u4ea4\u603b\u6570
	  allWorkday=((Integer)resultMap.get("allWorkday")).intValue();      //\u88ab\u5173\u6ce8\u4eba\u672a\u63d0\u4ea4\u603b\u6570
	  allWorkIndex=((Double)resultMap.get("allWorkIndex")).doubleValue();      //\u88ab\u5173\u6ce8\u4eba\u672a\u63d0\u4ea4\u603b\u6570
  }else if("mood".equals(type)){
	  resultMap=reportManager.getMoodAttentionReport(userid,year,month);
  }else{
	  out.println(SystemEnv.getHtmlLabelName(83153,user.getLanguage()));
	  return;
  }
  List resultList=(List)resultMap.get("resultList");          //\u7edf\u8ba1\u7ed3\u679c
  List totaldateList=(List)resultMap.get("totaldateList");          //\u5f53\u6708\u603b\u7684\u5929\u6570
  int totalWorkday=((Integer)resultMap.get("totalWorkday")).intValue();    //\u5f53\u6708\u5de5\u4f5c\u65e5\u603b\u6570
  
  List isWorkdayList=(List)resultMap.get("isWorkdayList");    //\u6709\u6548\u65e5\u671f\u7edf\u8ba1list
  List resultCountList=(List)resultMap.get("resultCountList"); //\u6709\u6548\u65e5\u671f\u7edf\u8ba1list
  
  int total=resultList.size();

      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print((SystemEnv.getHtmlLabelName(556,user.getLanguage())));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      out.print((SystemEnv.getHtmlLabelName(26943,user.getLanguage())));
      out.write(_jsp_string5, 0, _jsp_string5.length);
      out.print((type ));
      out.write(_jsp_string6, 0, _jsp_string6.length);
      out.print((SystemEnv.getHtmlLabelName(26962,user.getLanguage())));
      out.write(_jsp_string7, 0, _jsp_string7.length);
      
	   
	      for(int i=0;i<totaldateList.size();i++){
	    	  int day=((Integer)totaldateList.get(i)).intValue();
	    	  
	    	  if(i<isWorkdayList.size()){
	    		  boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    	  if(isWorkday){
		
      out.write(_jsp_string8, 0, _jsp_string8.length);
      out.print((day));
      out.write(_jsp_string9, 0, _jsp_string9.length);
          		  
		    	  }
	    	  }else{
	    
      out.write(_jsp_string10, 0, _jsp_string10.length);
      out.print((day));
      out.write(_jsp_string11, 0, _jsp_string11.length);
      }}
      out.write(_jsp_string12, 0, _jsp_string12.length);
      out.print((SystemEnv.getHtmlLabelName(129959,user.getLanguage())));
      out.write(_jsp_string13, 0, _jsp_string13.length);
      if("blog".equals(type)) {
      out.write(_jsp_string14, 0, _jsp_string14.length);
      out.print((SystemEnv.getHtmlLabelName(26929,user.getLanguage())));
      out.write(_jsp_string15, 0, _jsp_string15.length);
      } else if("mood".equals(type)){
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((SystemEnv.getHtmlLabelName(26930,user.getLanguage())));
      out.write(_jsp_string17, 0, _jsp_string17.length);
      } else{
      out.write(_jsp_string16, 0, _jsp_string16.length);
      out.print((SystemEnv.getHtmlLabelName(26931,user.getLanguage())));
      out.write(_jsp_string18, 0, _jsp_string18.length);
      } 
      out.write(_jsp_string19, 0, _jsp_string19.length);
      
	  
	  if("blog".equals(type)){
		  for(int i=0;i<resultList.size();i++){
	    	  Map reportMap=(Map)resultList.get(i);
	    	  String attentionid=(String)reportMap.get("attentionid");
	    	  List reportList=(List)reportMap.get("reportList");
	    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
	    	  double workIndex=((Double)reportMap.get("workIndex")).doubleValue();
	    	  
	  
      out.write(_jsp_string20, 0, _jsp_string20.length);
      out.print((attentionid));
      out.write(_jsp_string21, 0, _jsp_string21.length);
      out.print((attentionid));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((attentionid));
      out.write(_jsp_string23, 0, _jsp_string23.length);
      out.print((ResourceComInfo.getLastname(attentionid)));
      out.write(_jsp_string24, 0, _jsp_string24.length);
      
	     for(int j=0;j<totaldateList.size();j++){
	       if(j<isWorkdayList.size()){	 
	         boolean isWorkday=((Boolean)isWorkdayList.get(j)).booleanValue();
	         boolean isSubmited=((Boolean)reportList.get(j)).booleanValue();
	  
      out.write(_jsp_string25, 0, _jsp_string25.length);
      if(isWorkday){
      out.write(_jsp_string26, 0, _jsp_string26.length);
      if(isSubmited){
      out.write(_jsp_string27, 0, _jsp_string27.length);
      }else{ 
      out.write(_jsp_string28, 0, _jsp_string28.length);
      } 
      out.write(_jsp_string29, 0, _jsp_string29.length);
      }else{
      out.write(_jsp_string30, 0, _jsp_string30.length);
      }}else{
      out.write(_jsp_string31, 0, _jsp_string31.length);
      }}
      out.write(_jsp_string32, 0, _jsp_string32.length);
      out.print((totalUnsubmit ));
      out.write(_jsp_string33, 0, _jsp_string33.length);
      out.print((totalWorkday ));
      out.write(_jsp_string34, 0, _jsp_string34.length);
      out.print((attentionid));
      out.write(_jsp_string35, 0, _jsp_string35.length);
      out.print((SystemEnv.getHtmlLabelName(15178,user.getLanguage())));
      out.print((totalUnsubmit));
      out.print((SystemEnv.getHtmlLabelName(1925,user.getLanguage())));
      out.print((SystemEnv.getHtmlLabelName(26932,user.getLanguage())));
      out.print((totalWorkday));
      out.print((SystemEnv.getHtmlLabelName(1925,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      out.print((reportManager.getReportIndexStar(workIndex)));
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((workIndex));
      out.write(_jsp_string38, 0, _jsp_string38.length);
      out.print((attentionid));
      out.write(_jsp_string39, 0, _jsp_string39.length);
      out.print((year));
      out.write(_jsp_string40, 0, _jsp_string40.length);
      out.print((ResourceComInfo.getLastname(attentionid)));
      out.print((SystemEnv.getHtmlLabelName(26467,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())));
      out.write(_jsp_string41, 0, _jsp_string41.length);
       }
      out.write(_jsp_string42, 0, _jsp_string42.length);
      out.print((SystemEnv.getHtmlLabelName(523,user.getLanguage())));
      out.write(_jsp_string43, 0, _jsp_string43.length);
      
	  for(int i=0;i<totaldateList.size();i++){
		  if(i<isWorkdayList.size()){	 
		    boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    int unsubmit=((Integer)resultCountList.get(i)).intValue();
		    if(isWorkday){
	
      out.write(_jsp_string44, 0, _jsp_string44.length);
      out.print((unsubmit));
      out.write(_jsp_string33, 0, _jsp_string33.length);
      out.print((total));
      out.write(_jsp_string45, 0, _jsp_string45.length);
       	    	
		    }else{
    
      out.write(_jsp_string46, 0, _jsp_string46.length);
      		    	
		    }
	      }else{
	
      out.write(_jsp_string47, 0, _jsp_string47.length);
      	
	      }
	  }
	
      out.write(_jsp_string48, 0, _jsp_string48.length);
      out.print((SystemEnv.getHtmlLabelName(15178,user.getLanguage())));
      out.print((allUnsubmit));
      out.print((SystemEnv.getHtmlLabelName(1925,user.getLanguage())));
      out.print((SystemEnv.getHtmlLabelName(26932,user.getLanguage())));
      out.print((allWorkday));
      out.print((SystemEnv.getHtmlLabelName(1925,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      out.print((reportManager.getReportIndexStar(allWorkIndex)));
      out.write(_jsp_string49, 0, _jsp_string49.length);
      out.print((allWorkIndex));
      out.write(_jsp_string50, 0, _jsp_string50.length);
      }else if("mood".equals(type)){
	    	
			for(int i=0;i<resultList.size();i++){
			      int totalSubmitedDays = 0;
		    	  Map reportMap=(Map)resultList.get(i);
		    	  String attentionid=(String)reportMap.get("attentionid");
		    	  List reportList=(List)reportMap.get("reportList");
		    	  int totalUnsubmit=((Integer)reportMap.get("totalUnsubmit")).intValue();
	    		  double moodIndex=((Double)reportMap.get("moodIndex")).doubleValue();
	    		  int happyDays=((Integer)reportMap.get("happyDays")).intValue();
	    		    int unHappyDays=((Integer)reportMap.get("unHappyDays")).intValue();
	    		  
      out.write(_jsp_string51, 0, _jsp_string51.length);
      out.print((attentionid));
      out.write(_jsp_string22, 0, _jsp_string22.length);
      out.print((attentionid));
      out.write(_jsp_string52, 0, _jsp_string52.length);
      out.print((ResourceComInfo.getLastname(attentionid)));
      out.write(_jsp_string53, 0, _jsp_string53.length);
      
	    		     for(int j=0;j<totaldateList.size();j++){
	    		       if(j<isWorkdayList.size()){	 
	    		         boolean isWorkday=((Boolean)isWorkdayList.get(j)).booleanValue();
	    		         String faceImg=(String)reportList.get(j);
	    		  			
      out.write(_jsp_string54, 0, _jsp_string54.length);
      if(isWorkday){
      out.write(_jsp_string55, 0, _jsp_string55.length);
      if("".equals(faceImg)){
      out.write(_jsp_string56, 0, _jsp_string56.length);
      }else{ 
	    			           totalSubmitedDays++;
	    			       
      out.write(_jsp_string57, 0, _jsp_string57.length);
      out.print((faceImg ));
      out.write(_jsp_string58, 0, _jsp_string58.length);
      } 
      out.write(_jsp_string59, 0, _jsp_string59.length);
      }else{
      out.write(_jsp_string60, 0, _jsp_string60.length);
      }}else{
      out.write(_jsp_string61, 0, _jsp_string61.length);
      }}
      out.write(_jsp_string62, 0, _jsp_string62.length);
      out.print((happyDays ));
      out.write(_jsp_string33, 0, _jsp_string33.length);
      out.print((totalSubmitedDays ));
      out.write(_jsp_string63, 0, _jsp_string63.length);
      out.print((attentionid));
      out.write(_jsp_string64, 0, _jsp_string64.length);
      out.print((SystemEnv.getHtmlLabelName(26918,user.getLanguage())));
      out.print((unHappyDays));
      out.print((SystemEnv.getHtmlLabelName(1925,user.getLanguage())));
      out.print((SystemEnv.getHtmlLabelName(26917,user.getLanguage())));
      out.print((happyDays));
      out.print((SystemEnv.getHtmlLabelName(1925,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      out.print((reportManager.getReportIndexStar(moodIndex)));
      out.write(_jsp_string37, 0, _jsp_string37.length);
      out.print((moodIndex));
      out.write(_jsp_string65, 0, _jsp_string65.length);
      out.print((attentionid));
      out.write(_jsp_string39, 0, _jsp_string39.length);
      out.print((year));
      out.write(_jsp_string40, 0, _jsp_string40.length);
      out.print((ResourceComInfo.getLastname(attentionid)));
      out.print((SystemEnv.getHtmlLabelName(26769 ,user.getLanguage())+SystemEnv.getHtmlLabelName(15101,user.getLanguage())));
      out.write(_jsp_string66, 0, _jsp_string66.length);
      
	    	  }
		
      out.write(_jsp_string67, 0, _jsp_string67.length);
      out.print((SystemEnv.getHtmlLabelName(523,user.getLanguage())));
      out.write(_jsp_string43, 0, _jsp_string43.length);
      
	 for(int i=0;i<totaldateList.size();i++){
		  if(i<isWorkdayList.size()){	 
		    boolean isWorkday=((Boolean)isWorkdayList.get(i)).booleanValue();
		    int unHappy=((Integer)((HashMap)resultCountList.get(i)).get("unhappy")).intValue();
		    int happy=((Integer)((HashMap)resultCountList.get(i)).get("happy")).intValue();
		    if(isWorkday){
	
      out.write(_jsp_string68, 0, _jsp_string68.length);
      out.print((unHappy));
      out.write(_jsp_string33, 0, _jsp_string33.length);
      out.print((unHappy+happy));
      out.write(_jsp_string45, 0, _jsp_string45.length);
       	    	
		    }else{
    
      out.write(_jsp_string46, 0, _jsp_string46.length);
      		    	
		    }
	}else{
	
      out.write(_jsp_string47, 0, _jsp_string47.length);
      	
	}
	  }
	
      out.write(_jsp_string69, 0, _jsp_string69.length);
      out.print((SystemEnv.getHtmlLabelName(26918,user.getLanguage())));
      out.print((resultMap.get("totalUnHappyDays") ));
      out.print((SystemEnv.getHtmlLabelName(1925,user.getLanguage())));
      out.print((SystemEnv.getHtmlLabelName(26917,user.getLanguage())));
      out.print((resultMap.get("totalHappyDays") ));
      out.print((SystemEnv.getHtmlLabelName(1925,user.getLanguage())));
      out.write(_jsp_string36, 0, _jsp_string36.length);
      out.print((reportManager.getReportIndexStar(((Double)resultMap.get("totalMoodIndex")).doubleValue())));
      out.write(_jsp_string49, 0, _jsp_string49.length);
      out.print((resultMap.get("totalMoodIndex") ));
      out.write(_jsp_string70, 0, _jsp_string70.length);
      } 
      out.write(_jsp_string71, 0, _jsp_string71.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("blog/attentionReportRecord.jsp"), 2118105630417622565L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
    depend = new com.caucho.vfs.Depend(appDir.lookup("page/maint/common/initNoCache.jsp"), 3270256153856711871L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string62;
  private final static char []_jsp_string66;
  private final static char []_jsp_string40;
  private final static char []_jsp_string68;
  private final static char []_jsp_string42;
  private final static char []_jsp_string28;
  private final static char []_jsp_string16;
  private final static char []_jsp_string38;
  private final static char []_jsp_string11;
  private final static char []_jsp_string47;
  private final static char []_jsp_string29;
  private final static char []_jsp_string67;
  private final static char []_jsp_string18;
  private final static char []_jsp_string36;
  private final static char []_jsp_string13;
  private final static char []_jsp_string61;
  private final static char []_jsp_string8;
  private final static char []_jsp_string21;
  private final static char []_jsp_string22;
  private final static char []_jsp_string32;
  private final static char []_jsp_string23;
  private final static char []_jsp_string12;
  private final static char []_jsp_string54;
  private final static char []_jsp_string63;
  private final static char []_jsp_string34;
  private final static char []_jsp_string15;
  private final static char []_jsp_string70;
  private final static char []_jsp_string20;
  private final static char []_jsp_string49;
  private final static char []_jsp_string17;
  private final static char []_jsp_string45;
  private final static char []_jsp_string25;
  private final static char []_jsp_string44;
  private final static char []_jsp_string65;
  private final static char []_jsp_string4;
  private final static char []_jsp_string56;
  private final static char []_jsp_string37;
  private final static char []_jsp_string39;
  private final static char []_jsp_string43;
  private final static char []_jsp_string6;
  private final static char []_jsp_string52;
  private final static char []_jsp_string1;
  private final static char []_jsp_string30;
  private final static char []_jsp_string55;
  private final static char []_jsp_string46;
  private final static char []_jsp_string24;
  private final static char []_jsp_string27;
  private final static char []_jsp_string60;
  private final static char []_jsp_string31;
  private final static char []_jsp_string3;
  private final static char []_jsp_string7;
  private final static char []_jsp_string64;
  private final static char []_jsp_string48;
  private final static char []_jsp_string35;
  private final static char []_jsp_string69;
  private final static char []_jsp_string58;
  private final static char []_jsp_string50;
  private final static char []_jsp_string71;
  private final static char []_jsp_string9;
  private final static char []_jsp_string19;
  private final static char []_jsp_string14;
  private final static char []_jsp_string53;
  private final static char []_jsp_string10;
  private final static char []_jsp_string26;
  private final static char []_jsp_string33;
  private final static char []_jsp_string59;
  private final static char []_jsp_string57;
  private final static char []_jsp_string51;
  private final static char []_jsp_string5;
  private final static char []_jsp_string0;
  private final static char []_jsp_string41;
  private final static char []_jsp_string2;
  static {
    _jsp_string62 = "\r\n                    <td align=\"center\"><span style=\"color:red\">".toCharArray();
    _jsp_string66 = "')\" style=\"text-decoration: none\"><img src=\"images/chart_wev8.png\" style=\"margin-left: 3px;border: 0px\" align=\"absmiddle\" /></a></td>\r\n	    		 </tr>\r\n	    		  \r\n	    ".toCharArray();
    _jsp_string40 = ",'1','".toCharArray();
    _jsp_string68 = "\r\n	      <td align=\"center\" style=\"width: 18px;\"><span style=\"color:red\">".toCharArray();
    _jsp_string42 = "\r\n	 <tr>\r\n	    <td align=\"center\">".toCharArray();
    _jsp_string28 = "\r\n		        <div><img src=\"images/submit-no_wev8.png\" /></div> \r\n		       ".toCharArray();
    _jsp_string16 = "\r\n	    		".toCharArray();
    _jsp_string38 = "<a href=\"javascript:openChart('blog','".toCharArray();
    _jsp_string11 = "</td>\r\n	    ".toCharArray();
    _jsp_string47 = "\r\n	      <td>&nbsp;</td>\r\n	".toCharArray();
    _jsp_string29 = " \r\n		    </td>\r\n		  ".toCharArray();
    _jsp_string67 = "\r\n		<tr>\r\n	    <td align=\"center\">".toCharArray();
    _jsp_string18 = "<!-- \u8003\u52e4\u6307\u6570 -->\r\n	    	".toCharArray();
    _jsp_string36 = "\">".toCharArray();
    _jsp_string13 = "</td> <!-- \u603b\u8ba1 -->\r\n	    <td style=\"width:150px;max-width:150px;\" align=\"center\">\r\n\r\n	    	".toCharArray();
    _jsp_string61 = "\r\n	    		        <td >&nbsp;</td>\r\n	    		 ".toCharArray();
    _jsp_string8 = "\r\n		      <td class=\"tdWidth\" width=\"*\" nowrap=\"nowrap\">".toCharArray();
    _jsp_string21 = "\" attentionid=\"".toCharArray();
    _jsp_string22 = "\" class=\"condition\" /><a href=\"viewBlog.jsp?blogid=".toCharArray();
    _jsp_string32 = "\r\n        <td align=\"center\"><span style=\"color:red\">".toCharArray();
    _jsp_string23 = "\" target=\"_blank\">".toCharArray();
    _jsp_string12 = "\r\n	    <td style=\"width:75px;max-width:85px;\" align=\"center\">".toCharArray();
    _jsp_string54 = " \r\n	    		       ".toCharArray();
    _jsp_string63 = "</td>\r\n	    		    <td>\r\n	    		     <a href=\"viewBlog.jsp?blogid=".toCharArray();
    _jsp_string34 = "</td>\r\n	    <td>\r\n	     <a href=\"viewBlog.jsp?blogid=".toCharArray();
    _jsp_string15 = "<!-- \u5de5\u4f5c\u6307\u6570 -->\r\n	    	".toCharArray();
    _jsp_string70 = "</td>\r\n	</tr>\r\n		".toCharArray();
    _jsp_string20 = "\r\n	  <tr class=\"item1\">\r\n	     <td><input type=\"checkbox\" conType=\"1\" conValue=\"".toCharArray();
    _jsp_string49 = "</span>".toCharArray();
    _jsp_string17 = "<!-- \u5fc3\u60c5\u6307\u6570 -->\r\n	    	".toCharArray();
    _jsp_string45 = "</td>\r\n	".toCharArray();
    _jsp_string25 = " \r\n	       ".toCharArray();
    _jsp_string44 = "\r\n	      <td align=\"center\"><span style=\"color:red\">".toCharArray();
    _jsp_string65 = "<a href=\"javascript:openChart('mood','".toCharArray();
    _jsp_string4 = "\"/>  <!-- \u5168\u9009 -->\r\n	       </div>\r\n	       <div style=\"float: left;\">\r\n			   <button class=\"submitButton\" style=\"width:45px;\" id=\"compareBtn\" onclick=\"compareChart('blogReportDiv','".toCharArray();
    _jsp_string56 = "\r\n	    			        &nbsp;\r\n	    			       ".toCharArray();
    _jsp_string37 = "</span></a>".toCharArray();
    _jsp_string39 = "',".toCharArray();
    _jsp_string43 = "</td><!-- \u603b\u8ba1 -->\r\n	".toCharArray();
    _jsp_string6 = "')\" type=\"button\">".toCharArray();
    _jsp_string52 = "\" class=\"index\" target=\"_blank\">".toCharArray();
    _jsp_string1 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string30 = "\r\n	  ".toCharArray();
    _jsp_string55 = "\r\n	    			    <td align=\"center\">\r\n	    			       ".toCharArray();
    _jsp_string46 = "\r\n    ".toCharArray();
    _jsp_string24 = "</a></td>\r\n	  ".toCharArray();
    _jsp_string27 = "\r\n		        <div><img src=\"images/submit-ok_wev8.png\" /></div>\r\n		       ".toCharArray();
    _jsp_string60 = "\r\n	    		  ".toCharArray();
    _jsp_string31 = "\r\n	        <td >&nbsp;</td>\r\n	 ".toCharArray();
    _jsp_string3 = "\r\n	<div id=\"blogReportDiv\" class=\"reportDiv\" style=\"overflow-x: auto;width: 100%;\">\r\n	 <table id=\"reportList\" style=\"width:100%;border-collapse:collapse;margin-top: 3px;margin-bottom: 40px;table-layout:fixed;\"  border=\"1\" cellspacing=\"0\" bordercolor=\"#dfdfdf\" cellpadding=\"2\" >\r\n\r\n 	<tr style=\"\" height=\"20px\">\r\n 	\r\n	    <td  class=\"tdWidth\" style=\"width:75px;\"   nowrap=\"nowrap\"> \r\n\r\n	      <div style=\"float: left;\">\r\n	           <input type=\"checkbox\"  onclick=\"selectBox(this)\" title=\"".toCharArray();
    _jsp_string7 = "</button>\r\n		  </div>\r\n	    </td>\r\n	    ".toCharArray();
    _jsp_string64 = "\" class=\"index\" target=\"_blank\"><span title=\"".toCharArray();
    _jsp_string48 = "  \r\n         <td>&nbsp;</td>\r\n	     <td><span title=\"".toCharArray();
    _jsp_string35 = "\" class=\"index\" target=\"_blank\">\r\n	     	<span title=\"".toCharArray();
    _jsp_string69 = "  \r\n        <td>&nbsp;</td>\r\n	    <td><span title=\"".toCharArray();
    _jsp_string58 = "\" /></div> \r\n	    			       ".toCharArray();
    _jsp_string50 = "</td>\r\n	</tr>\r\n	".toCharArray();
    _jsp_string71 = "  \r\n	  \r\n	\r\n	</table>\r\n  </div>	\r\n\r\n".toCharArray();
    _jsp_string9 = "</td>\r\n		".toCharArray();
    _jsp_string19 = "\r\n	    </td>\r\n	</tr>\r\n	".toCharArray();
    _jsp_string14 = "\r\n	    	".toCharArray();
    _jsp_string53 = "</a></td>\r\n	    		  ".toCharArray();
    _jsp_string10 = "\r\n	          <td class=\"tdWidth\" width=\"*\" nowrap=\"nowrap\">".toCharArray();
    _jsp_string26 = "\r\n		    <td align=\"center\">\r\n		       ".toCharArray();
    _jsp_string33 = "</span>/".toCharArray();
    _jsp_string59 = " \r\n	    			    </td>\r\n	    			  ".toCharArray();
    _jsp_string57 = "\r\n	    			        <div><img src=\"".toCharArray();
    _jsp_string51 = "\r\n	    		  <tr class=\"item1\">\r\n	    		     <td><input type=\"checkbox\" conType=\"1\" conValue=\"".toCharArray();
    _jsp_string5 = "','".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string41 = "')\" style=\"text-decoration: none\"><img src=\"images/chart_wev8.png\" style=\"margin-left: 3px;border: 0px\" align=\"absmiddle\" /></a>\r\n	    </td>\r\n	 </tr>\r\n	 ".toCharArray();
    _jsp_string2 = "\r\n\r\n".toCharArray();
  }
}
