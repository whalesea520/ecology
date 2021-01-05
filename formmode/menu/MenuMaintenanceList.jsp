
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.systeminfo.systemright.CheckSubCompanyRight"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="scc" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%

String type = Util.null2String(request.getParameter("type"));// top left 
String mode = Util.null2String(request.getParameter("mode"));  //visible hidden 默认为hidden
int resourceId = Util.getIntValue(request.getParameter("resourceId"),0);
String resourceType = Util.null2String((String)request.getParameter("resourceType"));
String isCustom = Util.null2String(request.getParameter("isCustom"));
String menuflag = Util.null2String(request.getParameter("menuflag"));//表单建模新增菜单地址


String saved = Util.null2String(request.getParameter("saved"));
int companyid = Util.getIntValue(request.getParameter("companyid"),0);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
int sync = Util.getIntValue(request.getParameter("sync"),0);

int userId = 0;
userId = user.getUID();


//判断总部菜单维护权限
if(!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)){
	if(companyid>0||"1".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
} else {
	if(companyid==0&&subCompanyId==0&&resourceId==0&&"".equals(resourceType)) companyid = 1;
}
//判断分部菜单维护权限
if(!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
	if(subCompanyId>0||"2".equals(resourceType)){
		response.sendRedirect("/notice/noright.jsp");
        return;
	}
} else {
	CheckSubCompanyRight newCheck = new CheckSubCompanyRight();
	int[] subcomids = newCheck.getSubComByUserRightId(userId,"SubMenu:Maint",0);
	if(subCompanyId==0&&companyid==0&&resourceId==0&&"".equals(resourceType)){
    	if(subcomids!=null&&subcomids.length>0) subCompanyId = subcomids[0];
    	else {
    		response.sendRedirect("/notice/noright.jsp");
            return;
    	}
	}
	//for TD.4374
	if(subCompanyId>0&&companyid==0){
    	boolean tmpFlag = false;
    	for(int i=0;i<subcomids.length;i++){
    		if(subCompanyId == subcomids[i]){
    			tmpFlag = true;
    			break;
    		}
    	}
    	if(!tmpFlag) {
    		response.sendRedirect("/notice/noright.jsp");
            return;
    	}
	}
}

if(companyid>0||subCompanyId>0){
	resourceId = (companyid>0?companyid:subCompanyId);
	resourceType = (companyid>0?"1":"2");
}


String titlename="";
if("left".equals(type))		titlename=SystemEnv.getHtmlLabelName(33675,user.getLanguage());//前段菜单（原左侧）
else if("top".equals(type))		titlename=SystemEnv.getHtmlLabelName(33676,user.getLanguage());//后端菜单（原顶部）
	
String menuTitle="";
if(resourceType.equals("1")) {
	menuTitle= (Util.toScreen(CompanyComInfo.getCompanyname(""+resourceId), user.getLanguage()));
} else if(resourceType.equals("2")){
	menuTitle = (Util.toScreen(SubCompanyComInfo.getSubCompanyname(""+resourceId), user.getLanguage()));
} else if(resourceType.equals("3")) {
	menuTitle = user.getLastname();
}

menuTitle=menuTitle+titlename;



if(!HrmUserVarify.checkUserRight("SystemTemplate:Edit", user)
		&&!HrmUserVarify.checkUserRight("HeadMenu:Maint", user)
		&&!HrmUserVarify.checkUserRight("SubMenu:Maint", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}


String url="/formmode/menu/MenuMaintenanceListIframe.jsp?type="+type+"&mode="+mode+"&resourceId="+resourceId+"&resourceType="+resourceType+"&isCustom="+isCustom+"&menuflag="+menuflag+"&saved="+saved+"&companyid="+companyid+"&subCompanyId="+subCompanyId+"&sync="+sync;

	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <ul class="tab_menu">
			    </ul>
			    <div id="rightBox" class="e8_rightBox"></div>
    		</div>
		</div>
	</div>
    
    <div class="tab_box">
        <div>
            <iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
    </div>
</div>
</body>
</html>

<script language="javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("portal")%>",
        objName:"<%=menuTitle%>"
    });
    
});

function refreshTab(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
		}else{ 
			window.parent.oTd1.style.display='';
			window.parent.wfleftFrame.setHeight();
		}
	}
}
</script>