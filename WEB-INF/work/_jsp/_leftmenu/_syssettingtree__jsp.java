/*
 * JSP generated by Resin-3.1.8 (built Mon, 17 Nov 2008 12:15:21 PST)
 */

package _jsp._leftmenu;
import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import java.util.ArrayList;
import java.lang.reflect.Method;
import weaver.cpcompanyinfo.ProManageUtil;
import com.weaver.integration.util.IntegratedSapUtil;
import weaver.hrm.*;
import weaver.general.*;
import weaver.systeminfo.*;
import weaver.systeminfo.menuconfig.*;

public class _syssettingtree__jsp extends com.caucho.jsp.JavaPage
{
  private static final java.util.HashMap<String,java.lang.reflect.Method> _jsp_functionMap = new java.util.HashMap<String,java.lang.reflect.Method>();
  private boolean _caucho_isDead;

  
  //visibility: visible,noright,hidden
  String visibility = "";
  String isDisplay(boolean needRightToVisible,boolean needSwitchToVisible,String rightDetailToVisible,String switchMethodNameToVisible,int relatedModuleId,User user){
  	visibility = "visible";
  	//\u901a\u8fc7\u5f00\u5173\u63a7\u5236\u53ef\u89c1
  	if(needSwitchToVisible){
  		 try {
  			  Class cls = Class.forName("weaver.systeminfo.menuconfig.MenuSwitch");
  			  //some error here, modify by xiaofeng
  			  Method meth = cls.getMethod(switchMethodNameToVisible,new Class[]{User.class });
  
  			  MenuSwitch methobj = new MenuSwitch();
  			  Object retobj = meth.invoke(methobj,new Object[]{user});
  			  Boolean retval = (Boolean) retobj;
  			  boolean switchToVisible = retval.booleanValue();
  			  //visible = visible&&switchToVisible;
  			  if(!switchToVisible)
  				visibility = "hidden";
  		 } catch (Throwable e) {
  			  e.printStackTrace();
  		 }
  	}
  	//\u901a\u8fc7\u6743\u9650\u63a7\u5236\u83dc\u5355\u53ef\u89c1
  	if(needRightToVisible){
  		 ArrayList rightDetails = Util.TokenizerString(rightDetailToVisible,"&&");
  		 for(int a=0;a<rightDetails.size();a++){
  			  String rightDetail = (String)rightDetails.get(a);
  			  //visible = visible&&HrmUserVarify.checkUserRight(rightDetail,user);
  			  if(!HrmUserVarify.checkUserRight(rightDetail,user)){
  				  break;
  			  }
  		 }
  		 visibility = "noright";
  	}
  	return visibility;
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
    response.setContentType("text/xml ; charset=UTF-8");
    request.setCharacterEncoding("UTF-8");
    try {
      weaver.general.BaseBean baseBean;
      baseBean = (weaver.general.BaseBean) pageContext.getAttribute("baseBean");
      if (baseBean == null) {
        baseBean = new weaver.general.BaseBean();
        pageContext.setAttribute("baseBean", baseBean);
      }
      weaver.conn.RecordSet rs;
      rs = (weaver.conn.RecordSet) pageContext.getAttribute("rs");
      if (rs == null) {
        rs = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs", rs);
      }
      weaver.conn.RecordSet rs2;
      rs2 = (weaver.conn.RecordSet) pageContext.getAttribute("rs2");
      if (rs2 == null) {
        rs2 = new weaver.conn.RecordSet();
        pageContext.setAttribute("rs2", rs2);
      }
      User user = HrmUserVarify.getUser(request,response);
      
	if(user == null)  return ;String s = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><tree>", sql="", parentid="", visibility="";parentid=Util.null2String(request.getParameter("parentid"));//baseBean.writeLog("parentid:"+parentid);
MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage()) ;
//===============================================
//TD4425 \u907f\u514d\u91cd\u590d\u6267\u884c\u811a\u672c\u9020\u6210\u83dc\u5355\u91cd\u590d
//added by hubo,2006-07-03
ArrayList menuIds = new ArrayList();
//===============================================

//
//if(parentid.equals("")){
	//sql = "SELECT a.* FROM MainMenuInfo a,SystemModule c WHERE c.moduleReleased='1' AND c.id=a.relatedModuleId  AND  defaultParentId IS NULL ORDER BY defaultIndex";
//}else{
	//sql = "SELECT a.* FROM MainMenuInfo a,SystemModule c WHERE c.moduleReleased='1' AND c.id=a.relatedModuleId  AND   defaultParentId="+Integer.parseInt(request.getParameter("parentid"))+" ORDER BY defaultIndex";
//}
//rs.executeSql(sql);
mu.setUser(user);
rs=mu.getMenuRs(Util.getIntValue(parentid,0));
while(rs.next()){
	boolean hasSubMenu = false;
	int infoid=rs.getInt("infoid");
	
	if(infoid==1 || infoid==10  || infoid==26 ||  infoid==27 ||  infoid==19) continue;
 
	//TD4425=========================================
	if(menuIds.contains(String.valueOf(infoid))) continue;
	menuIds.add(String.valueOf(infoid));
	//===============================================
	
	int labelId = rs.getInt("labelId");
	
	//\u6211\u7684\u62a5\u8868\u3001\u7cfb\u7edf\u8bbe\u7f6e\u3001\u8bbe\u7f6e\u4e2d\u5fc3 \u6a21\u5757\u5c4f\u853d
	if("".equals(parentid)||"10".equals(parentid)||"11".equals(parentid)){
	   String module = Util.null2String(rs.getString("module"));
	   if(!"".equals(module)){
			MouldStatusCominfo msc=new MouldStatusCominfo();
			String status=Util.null2String(msc.getStatus(module));
			if("0".equals(status)) 		continue;
		}
	}
	//1163text=SAP\u6570\u636e\u6388\u6743\u8bbe\u7f6e
	//1164text=\u914d\u7f6eSAP\u6d4f\u89c8\u6309\u94ae
	//1189text=\u914d\u7f6eSAP\u8fde\u63a5
	String IsOpetype=IntegratedSapUtil.getIsHideOldSapMenu();
	if("1".equals(IsOpetype)){
	   	if(infoid==1163||infoid==1164||infoid==1189){
	   		continue;
	   	}
	}
	//1227=\u96c6\u6210\u7ba1\u7406
	/*  if("0".equals(IsOpetype)&&infoid==1227){
			continue;
	 } */
	 
	//1255text\u8bc1\u7167\u7ba1\u7406
	int isOpenCpcompanyinfo=ProManageUtil.getIsOpenCpcompanyinfo();
	if(isOpenCpcompanyinfo==0&&infoid==1255){
			continue;
	}
	
	if(infoid==10008){
		String emServer = Util.null2String( new BaseBean().getPropValue("emserver","server"));
		if(emServer.equals("")){
			continue;
		}
	}
	
	boolean useCustomName = rs.getInt("useCustomName") == 1 ? true: false;
	String customName = rs.getString("customName");
	String customName_e = rs.getString("customName_e");
	String customName_t = rs.getString("customName_t");
	
	boolean infoUseCustomName = rs.getInt("infoUseCustomName") == 1 ? true	: false;
	String infoCustomName = rs.getString("infoCustomName");
	String infoCustomName_e = rs.getString("infoCustomName_e");
	String infoCustomName_t = rs.getString("infoCustomName_t");
	String baseTarget = rs.getString("baseTarget");
	if("".equals(baseTarget)) baseTarget="mainFrame";
	
	String text = mu.getMenuText(labelId, useCustomName, customName, customName_e, customName_t, infoUseCustomName, infoCustomName, infoCustomName_e,infoCustomName_t,user.getLanguage());			 
	//baseBean.writeLog(infoid+"te"+isOpenCpcompanyinfo+"xt"+text);
	sql = "SELECT id FROM MainMenuInfo WHERE parentid="+infoid;
	rs2.executeSql(sql);
	if(rs2.next()) hasSubMenu=true;
	
	boolean _needRightToVisible = rs.getString("needRightToVisible").equals("1") ? true : false;
	boolean _needSwitchToVisible = rs.getString("needSwitchToVisible").equals("1") ? true : false;
	String _rightDetailToVisible = rs.getString("rightDetailToVisible");
	String _switchMethodNameToVisible = rs.getString("switchMethodNameToVisible");
	int _relatedModuleId = rs.getInt("relatedModuleId");
	String linkAddress=Util.replace(rs.getString("linkAddress"), "&", "&#38;", 0);

	visibility = isDisplay(_needRightToVisible,_needSwitchToVisible,_rightDetailToVisible,_switchMethodNameToVisible,_relatedModuleId,user);
	String iconUrl = rs.getString("iconUrl");
	if(iconUrl.indexOf("_wev8")<0){
		iconUrl = iconUrl.replace(".gif","_wev8.gif");
		iconUrl = iconUrl.replace(".png","_wev8.png");
	}
	if("hidden".equals(visibility)){
		continue;
	}else if("noright".equals(visibility)){
		if(hasSubMenu){
			s += "<tree text=\""+text+"\" target=\""+baseTarget+"\" icon=\""+iconUrl+"\" src=\"SysSettingTree.jsp?parentid="+infoid+"\" action=\"javascript:void(0);\">";
		}else{
			s += "<tree text=\""+text+"\"  target=\""+baseTarget+"\" icon=\""+iconUrl+"\" action=\"noright\">";
		}
	}else{
		if(hasSubMenu){
			s += "<tree text=\""+text+"\"  target=\""+baseTarget+"\" icon=\""+iconUrl+"\" src=\"SysSettingTree.jsp?parentid="+infoid+"\" action=\""+linkAddress+"\">";
		}else{
			s += "<tree text=\""+text+"\"  target=\""+baseTarget+"\" icon=\""+iconUrl+"\" action=\""+linkAddress+"\">";
		}
	}
	s += "</tree>";
}
out.clear();
out.print(s+"</tree>");

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
    depend = new com.caucho.vfs.Depend(appDir.lookup("LeftMenu/SysSettingTree.jsp"), -3670890077134296394L, false);
    com.caucho.jsp.JavaPage.addDepend(_caucho_depends, depend);
  }
}
