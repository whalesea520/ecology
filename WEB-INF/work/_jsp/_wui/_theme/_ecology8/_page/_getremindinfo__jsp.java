/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._wui._theme._ecology8._page;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import weaver.general.Util;
import java.sql.Timestamp;
import java.util.*;
import weaver.systeminfo.menuconfig.LeftMenuConfigHandler;
import weaver.systeminfo.menuconfig.LeftMenuInfo;
import weaver.systeminfo.menuconfig.LeftMenuConfig;
import weaver.systeminfo.menuconfig.MenuMaint;
import weaver.hrm.HrmUserVarify;
import weaver.hrm.User;
import weaver.conn.RecordSet;
import java.util.ArrayList;
import java.lang.reflect.Method;
import weaver.hrm.*;
import weaver.general.*;
import weaver.systeminfo.menuconfig.*;
import weaver.systeminfo.*;
import weaver.login.LicenseCheckLogin;
import weaver.hrm.settings.ChgPasswdReminder;
import weaver.hrm.settings.RemindSettings;
import weaver.file.Prop;

public class _getremindinfo__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  private String getRemindMenu(User user) {
      if(user == null) {
          return null;
      }
      String s = "";
  
      int bgcnt = 4;
      int bgindex = 4;
  
      String[] sbgPostions = new String[]{"0 -28", "0 -84", "0 0", "0 -56"};
      
      RecordSet rs = new RecordSet();
      
      String sql="";
      int userid=user.getUID();
      int usertype= Util.getIntValue(user.getLogintype(),1)-1;   
  	String userID = String.valueOf(user.getUID());
  		//int userid=user.getUID();
  		String belongtoshow = "";				
  		rs.executeSql("select * from HrmUserSetting where resourceId = "+userID);
  		if(rs.next()){
  			belongtoshow = rs.getString("belongtoshow");
  		}
  		String userIDAll = String.valueOf(user.getUID());	
  String Belongtoids =user.getBelongtoids();
  int Belongtoid=0;
  String[] arr2 = null;
  ArrayList<String> userlist = new ArrayList();
  userlist.add(userid + "");
  if(!"".equals(Belongtoids)){
  userIDAll = userID+","+Belongtoids;
  arr2 = Belongtoids.split(",");
  for(int i=0;i<arr2.length;i++){
  Belongtoid = Util.getIntValue(arr2[i]);
  userlist.add(Belongtoid + "");
  }
  }
      //Remind
      //sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" group by a.type";
  		if("1".equals(belongtoshow)){
      if(rs.getDBType().equals("oracle")){
          sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid in ("+userIDAll+") and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid in ("+userIDAll+") AND usertype='"+usertype+"' and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where t1.status=1))or (a.type=15 and a.requestid in(select id from mailresource where folderid=0 and status='0' and canview=1 and resourceid in("+userIDAll+")))  or type in (2,3,4,6,7,8,11,12,13,21,25)) group by a.type";
      } else {
          sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid in ("+userIDAll+") and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid in ("+userIDAll+") and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid in ("+userIDAll+") AND usertype='"+usertype+"' and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1)) or (a.type=15 and a.requestid in(select id from mailresource where folderid=0 and status='0' and canview=1 and resourceid in("+userIDAll+"))) or type in (2,3,4,6,7,8,11,12,13,21,25)) group by a.type";
      }
  		}else{
  		  if(rs.getDBType().equals("oracle")){
          sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid="+userid+" AND usertype='"+usertype+"' and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where t1.status=1)) or  (a.type=15 and a.requestid in(select id from mailresource where folderid=0 and status='0' and canview=1 and resourceid ="+userid+")) or  type in (2,3,4,6,7,8,11,12,13,21,25)) group by a.type";
      } else {
          sql = "select a.type, sum(a.counts) as count, (select statistic from SysPoppupinfo where type=a.type) as statistic, (select typedescription from SysPoppupinfo where type=a.type) as typedescription, (select link from SysPoppupinfo where type=a.type) as link from SysPoppupRemindInfoNew a where  a.userid="+userid+" and a.usertype='"+usertype+"'  and ( (a.type=0 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and isremark in ('0','1','8','9','7') ) )   or (a.type=1 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid and currentnodetype=3) ) ) or (a.type=14 and a.requestid in (select requestid from workflow_currentoperator where userid="+userid+" and usertype='"+usertype+"' and islasttimes=1 and workflowid in (select id from workflow_base where isvalid='1' or isvalid='3') and exists (select 1 from workflow_requestbase where workflow_requestbase.requestid=workflow_currentoperator.requestid) ) ) or (type=10 and requestid in (select requestid from workflow_currentoperator where ((isremark='0' and (isprocessed='2' or isprocessed='3' or isprocessed is null))  or isremark='5') and userid="+userid+" AND usertype='"+usertype+"' and islasttimes=1)) or (a.type=9 and a.requestid in (select id from cowork_items t1 where  t1.status=1)) or (a.type=15 and a.requestid in(select id from mailresource where folderid=0 and status='0' and canview=1 and resourceid ="+userid+")) or type in (2,3,4,6,7,8,11,12,13,21,25)) group by a.type";
      }
  		}
      rs.executeSql(sql);
      
      ChgPasswdReminder reminder = new ChgPasswdReminder();
      RemindSettings settings = reminder.getRemindSettings();
      //int index=0;
      while(rs.next()){
      	if("2".equals(rs.getString("type"))){//\u751f\u65e5
      		
              String birth_valid = settings.getBirthvalid();
              String birth_remindmode = settings.getBirthremindmode();
              
              if (birth_valid != null && birth_valid.equals("1")) {
                  if (birth_remindmode != null && birth_remindmode.equals("1")){
                  }else{
                  	continue;
                  }
              }else{
                  	continue;
              }
      	}
      	bgindex++;
          if(rs.getString("statistic").equals("y")) {   
             int count=rs.getInt("count");
             StringBuffer sfcm = new StringBuffer();
             //sfcm.append("<li><div   style='width:100%;'>");
             sfcm.append("<li url='"+rs.getString("link")+"'>");
            // sfcm.append("<a class='lfMenuItem' href='");
            // sfcm.append(rs.getString("link"));
             //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\"");
  		   sfcm.append(SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage()));
  		   sfcm.append("<span>"+count+"</span>");
             //sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
            // sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
             sfcm.append("</li>");
             s += sfcm.toString();
          } else {
              StringBuffer sfcm = new StringBuffer();
               //sfcm.append("<li><div   style='width:100%;'>");
               sfcm.append("<li url='"+rs.getString("link")+"'>");
              //sfcm.append("<a class='lfMenuItem' href='");
             // sfcm.append(rs.getString("link"));
              //sfcm.append("' style=\"background:url('").append(abgs[bgindex%4]).append("') no-repeat;\"");
              //sfcm.append("' _bgPosition='" + sbgPostions[bgindex%4] + "'");
              //sfcm.append(" target=\"" + "mainFrame" + "\" >");
              //sfcm.append("<div class=\"leftMenuItemLeft\" style=\"background-position: " + sbgPostions[bgindex%4] + ";\"></div>");
              //sfcm.append("<div class=\"leftMenuItemCenter\"; style=\"\">");
  			sfcm.append(SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage()));
  			// sfcm.append("</div>");
            //  sfcm.append("<div class=\"leftMenuItemRight\" style=\"\"></div>");
             // sfcm.append("<div style='width:4px;display:none;'></div></a></div>");
              sfcm.append("</li>");
              s += sfcm.toString();
              //s += "<tree text=\""+SystemEnv.getHtmlLabelName(rs.getInt("typedescription"),user.getLanguage())+"\" icon=\"/images_face/ecologyFace_2/LeftMenuIcon/level3_wev8.gif\" action=\""+rs.getString("link")+"\" />";
          }
      }
      if(s.equals("")){
      	s="<span class='nodata'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</span>";
      }
      //s +="</ul>";
      return s;
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
      weaver.general.BaseBean BaseBean;
      BaseBean = (weaver.general.BaseBean) pageContext.getAttribute("BaseBean");
      if (BaseBean == null) {
        BaseBean = new weaver.general.BaseBean();
        pageContext.setAttribute("BaseBean", BaseBean);
      }
      out.write(_jsp_string1, 0, _jsp_string1.length);
      


String result = "";


User user = HrmUserVarify.getUser (request , response) ;
String userOffline = Util.null2String((String)session.getAttribute("userOffline"));	
if(userOffline.equals("1")){
	//\u5f3a\u5236\u4e0b\u7ebf
	String loginfile = Util.getCookie(request , "loginfileweaver") ;
	Map userSessions = (Map) application.getAttribute("userSessions");
	if (userSessions != null) {
		Map logmessages = (Map) application.getAttribute("logmessages");
		if (logmessages != null)logmessages.remove("" + user.getUID());
		session.removeValue("moniter");
		session.removeValue("WeaverMailSet");
		userSessions.remove(user.getUID());
		session.invalidate();
	}
      out.write(_jsp_string2, 0, _jsp_string2.length);
      out.print((SystemEnv.getErrorMsgName(175,user.getLanguage())));
      out.write(_jsp_string3, 0, _jsp_string3.length);
      out.print(("/Refresh.jsp?loginfile="+loginfile+"&message=175"));
      out.write(_jsp_string4, 0, _jsp_string4.length);
      
  return;
}

//\u66f4\u65b0\u4eba\u5458\u5728\u7ebf\u7edf\u8ba1\u65f6\u95f4\u6233

LicenseCheckLogin onlineu = new LicenseCheckLogin();
onlineu.setOutLineDate(user.getUID());

result = getRemindMenu(user);
 
out.clearBuffer();
out.print(result);

      out.write(_jsp_string5, 0, _jsp_string5.length);
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
    depend = new com.caucho.vfs.Depend(appDir.lookup("wui/theme/ecology8/page/getRemindInfo.jsp"), 1331371851178298372L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }

  private final static char []_jsp_string4;
  private final static char []_jsp_string5;
  private final static char []_jsp_string2;
  private final static char []_jsp_string0;
  private final static char []_jsp_string3;
  private final static char []_jsp_string1;
  static {
    _jsp_string4 = "\";\r\n		});		\r\n	</script>\r\n	".toCharArray();
    _jsp_string5 = "\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string2 = "\r\n	<script language=\"javascript\">\r\n		window.top.Dialog.alert(\"".toCharArray();
    _jsp_string0 = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n".toCharArray();
    _jsp_string3 = "\",function(){\r\n			window.top.location=\"".toCharArray();
    _jsp_string1 = "\r\n\r\n".toCharArray();
  }
}