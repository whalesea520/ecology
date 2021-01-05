<%@ page language="java" contentType="text/xml ; charset=UTF-8" %><%@ page import="java.util.ArrayList,java.lang.reflect.Method" %><%@page import="weaver.cpcompanyinfo.ProManageUtil"%><%@page import="com.weaver.integration.util.IntegratedSapUtil"%><%@ page import="weaver.hrm.*,weaver.general.*,weaver.systeminfo.*,weaver.systeminfo.menuconfig.*" %><jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page" /><jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/><jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page"/><%User user = HrmUserVarify.getUser(request,response);%><%
	if(user == null)  return ;String s = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><tree>", sql="", parentid="", visibility="";parentid=Util.null2String(request.getParameter("parentid"));//baseBean.writeLog("parentid:"+parentid);
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
	
	//我的报表、系统设置、设置中心 模块屏蔽
	if("".equals(parentid)||"10".equals(parentid)||"11".equals(parentid)){
	   String module = Util.null2String(rs.getString("module"));
	   if(!"".equals(module)){
			MouldStatusCominfo msc=new MouldStatusCominfo();
			String status=Util.null2String(msc.getStatus(module));
			if("0".equals(status)) 		continue;
		}
	}
	//1163text=SAP数据授权设置
	//1164text=配置SAP浏览按钮
	//1189text=配置SAP连接
	String IsOpetype=IntegratedSapUtil.getIsHideOldSapMenu();
	if("1".equals(IsOpetype)){
	   	if(infoid==1163||infoid==1164||infoid==1189){
	   		continue;
	   	}
	}
	//1227=集成管理
	/*  if("0".equals(IsOpetype)&&infoid==1227){
			continue;
	 } */
	 
	//1255text证照管理
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
%><%!
//visibility: visible,noright,hidden
String visibility = "";
String isDisplay(boolean needRightToVisible,boolean needSwitchToVisible,String rightDetailToVisible,String switchMethodNameToVisible,int relatedModuleId,User user){
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
			  e.printStackTrace();
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