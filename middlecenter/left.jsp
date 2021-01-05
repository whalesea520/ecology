<%@page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.Util,java.sql.Timestamp"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfigHandler"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuInfo"%>
<%@ page import="weaver.systeminfo.menuconfig.LeftMenuConfig"%>
<%@ page import="weaver.systeminfo.menuconfig.MenuMaint"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.conn.RecordSet"%>
<%@ page import="java.util.ArrayList,java.lang.reflect.Method" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.systeminfo.menuconfig.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@page import="weaver.rdeploy.portal.PortalUtil"%>
<%
    /*用户验证*/
    User user = HrmUserVarify.getUser(request, response);
    if (user == null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
    
    int parentid = Util.getIntValue(request.getParameter("parentid"));
    
    String menuStr = getSettingMenu(user,parentid+"");
	out.clearBuffer();
   	out.println(menuStr);
    
    	
%>

<%!
private String getSettingMenu(User user, String parentid) {
    if(user == null) {
        return null;
    }
    String s = "<ul id='submenu'>";
  //---------------------------
    // 菜单项背景图片随机显示
    // bgcnt   : 左侧菜单背景图片个数
    // bgindex : 左侧菜单背景图片随机用下标
    // abgs    : 左侧菜单背景图片数组
    //---------------------------
    int bgcnt = 4;
    int bgindex = 4;
  	
    String emServer = Util.null2String( new BaseBean().getPropValue("emserver","server"));
    String[] sbgPostions = new String[]{"0 -28", "0 -84", "0 0", "0 -56"};
    
    String sql="";
    String visibility="";
    //parentid=Util.null2String(request.getParameter("parentid"));
    
    MenuUtil mu=new MenuUtil("top", 3,user.getUID(),user.getLanguage()) ;
    //===============================================
    //TD4425 避免重复执行脚本造成菜单重复
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
    RecordSet rs=mu.getMenuRsWithShareRight(Util.getIntValue(parentid,0));
    while(rs.next()){
        boolean hasSubMenu = false;
        int infoid=rs.getInt("infoid");
        int needResourcetype=rs.getInt("resourcetype");
		int needResourceid=rs.getInt("resourceid");
		//if(!mu.hasShareRight(infoid,needResourceid,needResourcetype)){
			//continue;
		//}
        if(infoid==1 || infoid==10  || infoid==26 ||  infoid==27 ||  infoid==19) continue;
     
        //TD4425=========================================
        if(menuIds.contains(String.valueOf(infoid))) continue;
        menuIds.add(String.valueOf(infoid));
        //===============================================
        
        int labelId = rs.getInt("labelId");
        
        //我的报表、系统设置、设置中心 模块屏蔽
        if("".equals(parentid)||"10".equals(parentid)||"11".equals(parentid)){
           String module = Util.null2String(rs.getString("module"));
           if(!"".equals(module)){
                MouldStatusCominfo msc=new MouldStatusCominfo();
                String status=Util.null2String(msc.getStatus(module));
                if("0".equals(status))      continue;
            }
        }
        
   		if(infoid==10078){
   			continue;
   		}
	
   		if(emServer.equals("")){
   			if(infoid==10127||infoid==10128||infoid==10129||infoid==10130){
   				continue;
   			}
   		}
   		
   		//快速部署，屏蔽一些不常用的功能
   		//邮件
   		if (!PortalUtil.isShowEMail() && infoid == 1381) {
   		    continue;
   		}
   		//通信
   		if (!PortalUtil.isShowMessage() && infoid == 1329) {
   		    continue;
   		}
   		//调查
   		if (!PortalUtil.isShowSurvey() && infoid == 10086) {
   		    continue;
   		}
	
        boolean useCustomName = rs.getInt("useCustomName") == 1 ? true: false;
        String customName = rs.getString("customName");
        String customName_e = rs.getString("customName_e");
        String customName_t = rs.getString("customName_t");
        
        boolean infoUseCustomName = rs.getInt("infoUseCustomName") == 1 ? true  : false;
        String infoCustomName = rs.getString("infoCustomName");
        String infoCustomName_e = rs.getString("infoCustomName_e");
        String infoCustomName_t = rs.getString("infoCustomName_t");
        String baseTarget = rs.getString("baseTarget");
        if("".equals(baseTarget)) baseTarget="mainFrame";
        
        String text = mu.getMenuText(labelId, useCustomName, customName, customName_e, customName_t, infoUseCustomName, infoCustomName, infoCustomName_e,infoCustomName_t,user.getLanguage());           
        
        //System.out.println("text=" +text + ", infoid=" + infoid + ", parentid=" + parentid);
        //text = text+"_"+infoid;
        RecordSet rs2 = new RecordSet();
        sql = "SELECT id FROM MainMenuInfo WHERE parentid="+infoid;
        rs2.executeSql(sql);
        if(rs2.next()) hasSubMenu=true;
        
        boolean _needRightToVisible = rs.getString("needRightToVisible").equals("1") ? true : false;
        boolean _needSwitchToVisible = rs.getString("needSwitchToVisible").equals("1") ? true : false;
        String _rightDetailToVisible = rs.getString("rightDetailToVisible");
        String _switchMethodNameToVisible = rs.getString("switchMethodNameToVisible");
        int _relatedModuleId = rs.getInt("relatedModuleId");
        String linkAddress = "";
        
        try {
            linkAddress = Util.replace(rs.getString("linkAddress"), "&", "&#38;", 0);
        } catch (Exception e) {
            
        }
        
    
        visibility = isDisplay(_needRightToVisible,_needSwitchToVisible,_rightDetailToVisible,_switchMethodNameToVisible,_relatedModuleId,user);
        
        
        s+="<li class='menuitem' menuid='"+infoid+"' target='"+baseTarget+"' url='"+linkAddress+"' parentid='"+parentid+"'>"+text+"</li>";
    }
    s += "</ul>";
    return s;
}
%>

<%!
//visibility: visible,noright,hidden
String visibility = "";

private String isDisplay(boolean needRightToVisible,boolean needSwitchToVisible,String rightDetailToVisible,String switchMethodNameToVisible,int relatedModuleId,User user){
    visibility = "visible";
    //通过开关控制可见
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
              //System.err.println(e);
			  new BaseBean().writeLog(e);
         }
    }
    //通过权限控制菜单可见
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
%>




