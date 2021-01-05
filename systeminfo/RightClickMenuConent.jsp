<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="weaver.general.BaseBean" %>

<%	
int isSysadmin=0;
RecordSet rssysadminmenu=new RecordSet();
rssysadminmenu.executeSql("select count(*) from hrmresourcemanager where id="+user.getUID());
if(rssysadminmenu.next()){
 isSysadmin=rssysadminmenu.getInt(1);
}
int RCMenuWidth = 160 ;
int RCMenuHeightStep = 24 ;
int RCMenuHeight = 0 ;
String RCMenu="" ;
String systemAdminMenu = ""; 
int hiddenmenu=1;

String RCFromPage="";    //需要屏蔽右键的页面名称，用于使用RightClickMenu1.jsp需要屏蔽右键的页面
int loadTopMenu = 1;    //关闭右键菜单后，是否加载头部操作按钮；1-加载，0-不加载，现在用于多部门选择框。
int defaultMenuCount = 0;

/**
	检测系统配置，查看是否使用右键菜单，如果使用右键菜单，是否显示复制和黏贴的按钮
*/
BaseBean baseBeanRigthMenu = new BaseBean();
int userightmenu = 1;
int showCopyAndPaste=0;
try{
	userightmenu = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenu", "userightmenu"), 1);
    showCopyAndPaste = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenucopy", "showCopyAndPaste"), 0);
}catch(Exception e){
	
}
String isIEBrowser = (String)session.getAttribute("browser_isie"); //是否为IE浏览器
if(userightmenu == 1){
    if(showCopyAndPaste==1&&"true".equals(isIEBrowser)){ //非IE暂不支持粘贴复制
	    systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+",javascript:onRCMenu_copy(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(16180,user.getLanguage())+",javascript:onRCMenu_plaster(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    defaultMenuCount=defaultMenuCount+2;
    }
}

if(isSysadmin>0) {  //用系统管理员sysadmin登陆系统可查看页面地址
	systemAdminMenu	 += "{"+SystemEnv.getHtmlLabelName(21682,user.getLanguage())+",javascript:viewSourceUrl(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	defaultMenuCount++;
}

%>
