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

int showColMenuIndex = 0;

systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(32535,user.getLanguage())+",javascript:showColDialog(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
defaultMenuCount++;

/**
	检测系统配置，查看是否使用右键菜单，如果使用右键菜单，是否显示复制和黏贴的按钮
*/
BaseBean baseBeanRigthMenu = new BaseBean();
int userightmenu = 1;
int showCopyAndPaste=0;
boolean closeRightMenu = false;
try{
	userightmenu = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenu", "userightmenu"), 1);
	if(userightmenu!=1){
		userightmenu = 1;
		closeRightMenu = true;
		
		String reqstrUrl = request.getRequestURL().toString();
		//-------表单建模部分右键菜单特殊处理---start-------
		if (reqstrUrl.toLowerCase().indexOf("/formmode/")!=-1||reqstrUrl.toLowerCase().indexOf("/mobilemode/")!=-1) {
			closeRightMenu = false;
			List<String> formmodeViewPageList = new ArrayList<String>();
			formmodeViewPageList.add("/formmode/view/AddFormMode.jsp");
			formmodeViewPageList.add("/formmode/view/AddFormModeIframe.jsp");
			formmodeViewPageList.add("/formmode/interfaces/ModeDataBatchImport.jsp");
			formmodeViewPageList.add("/formmode/search/CustomSearchBySimple.jsp");
			formmodeViewPageList.add("/formmode/search/CustomSearchBySimpleIframe.jsp");
			formmodeViewPageList.add("/formmode/report/ReportConditionIframe.jsp");
			formmodeViewPageList.add("/formmode/report/ReportResult.jsp");
			formmodeViewPageList.add("/formmode/view/ModeShareAddMore.jsp");
			formmodeViewPageList.add("/formmode/view/ModeShareIframe.jsp");
			formmodeViewPageList.add("/formmode/browser/CommonMultiBrowser.jsp");
			formmodeViewPageList.add("/formmode/browser/CommonSingleBrowser.jsp");
			formmodeViewPageList.add("/formmode/tree/treebrowser/CustomTreeBrowser.jsp");
			formmodeViewPageList.add("/formmode/tree/treebrowser/CustomTreeBrowserIframe.jsp");
			formmodeViewPageList.add("/formmode/view/ModeLogView.jsp");
			formmodeViewPageList.add("/formmode/view/ModeLogViewIframe.jsp");
			for(int formmodeListIndexn=0;formmodeListIndexn<formmodeViewPageList.size();formmodeListIndexn++){
				if(reqstrUrl.indexOf(formmodeViewPageList.get(formmodeListIndexn))!=-1){
					closeRightMenu = true;
					break;
				}
			}
		}
		//-------表单建模部分右键菜单特殊处理----end--------
	}
    showCopyAndPaste = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenucopy", "showCopyAndPaste"), 0);
}catch(Exception e){
	
}

String isIEBrowser = (String)session.getAttribute("browser_isie"); //是否为IE浏览器
boolean hasSystemAdminMenu = false;
if(userightmenu == 1){
       
    String reqstrUrl = request.getRequestURL().toString();
	
    if(reqstrUrl.indexOf("/workflow/request/AddRequestIframe.jsp")!=-1
    		||reqstrUrl.indexOf("/workflow/request/ManageRequestNoFormIframe.jsp")!=-1
    		||reqstrUrl.indexOf("/workflow/request/ManageRequestNoFormModeIframe.jsp")!=-1
    		||reqstrUrl.indexOf("/workflow/request/ManageRequestNoFormBillIframe.jsp")!=-1
    		||reqstrUrl.indexOf("/workflow/request/ViewRequestIframe.jsp")!=-1){
		
        systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(28111,user.getLanguage())+",javascript:__openFavouriteBrowser(-9),_self} " ;
    	RCMenuHeight += RCMenuHeightStep ;
    	systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:parent.showHelp(),_self} " ;
    	RCMenuHeight += RCMenuHeightStep ;
		
        
    } else if (reqstrUrl.indexOf("/workflow/")!=-1) {
		
	    systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(28111,user.getLanguage())+",javascript:__openFavouriteBrowser(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:__showHelp(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
    } else {
		
        systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(28111,user.getLanguage())+",javascript:openFavouriteBrowser(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(275,user.getLanguage())+",javascript:showHelp(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		
    }

	 if(showCopyAndPaste==1&&"true".equals(isIEBrowser)){ //非IE暂不支持粘贴复制
		hasSystemAdminMenu = true;
		systemAdminMenu	 += "{__splitHR__,__hr__,_self} " ;
		RCMenuHeight += 1;
	    systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(77,user.getLanguage())+"(Ctrl+C),javascript:onRCMenu_copy(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    systemAdminMenu += "{"+SystemEnv.getHtmlLabelName(16180,user.getLanguage())+"(Ctrl+V),javascript:onRCMenu_plaster(),_self} " ;
	    RCMenuHeight += RCMenuHeightStep ;
	    defaultMenuCount=defaultMenuCount+2;
		
    }
}


if(isSysadmin>0) {  //用系统管理员sysadmin登陆系统可查看页面地址
	if(!hasSystemAdminMenu){
		systemAdminMenu	 += "{__splitHR__,__hr__,_self} " ;
		RCMenuHeight += 1;
	}
	systemAdminMenu	 += "{"+SystemEnv.getHtmlLabelName(21682,user.getLanguage())+",javascript:viewSourceUrl(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	defaultMenuCount++;
}

%>

