
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.page.element.ElementBaseCominfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="scc" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());
String needfav ="1";
String needhelp ="";


//add by wshen
String isshowelemflag = Util.null2String(request.getParameter("isshowelemflag"));;//0表示不显示特定的列表，1表示显示特定的列表
String elemids = Util.null2String(request.getParameter("elemids"));//存放需要显示的元素id，用,分隔
String url="";
String navName="";
HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
String _fromURL = Util.null2String((String)kv.get("_fromURL"));
String loginview = Util.null2String((String)kv.get("loginview"));
String isCustom=Util.null2String((String)kv.get("isCustom"));
String type = Util.null2String((String)kv.get("type"));// top left

String infoId=Util.null2String((String)kv.get("infoId"));
String resourceId=Util.null2String((String)kv.get("resourceId"));
String resourceType=Util.null2String((String)kv.get("resourceType"));

String openDialog=Util.null2String((String)kv.get("openDialog"));
if("hpManit".equals(_fromURL)){//门户页面
	if("0".equals(loginview)) {//登录后页面
		url = "/homepage/maint/HomepageRight.jsp?subCompanyId="+kv.get("subCompanyId");
	}else{//登录前页面
		url = "/homepage/maint/LoginPageContent.jsp";
	}
}else if("hpTheme".equals(_fromURL)){//门户主题
	url = "/systeminfo/template/templateFrame.jsp?subCompanyId="+kv.get("subCompanyId");
}else if("hpMenu".equals(_fromURL)){//门户菜单
	//String type = Util.null2String((String)kv.get("type"));
	if ("left".equals(type)||"top".equals(type)) {
		navName="left".equals(type)?SystemEnv.getHtmlLabelName(33675,user.getLanguage()):SystemEnv.getHtmlLabelName(33676,user.getLanguage()); 
		url="/page/maint/menu/SystemMenuMaintList.jsp?openDialog="+openDialog+"&type="+kv.get("type")+"&isCustom="+kv.get("isCustom")+"&resourceType="+kv.get("resourceType")+"&resourceId="+kv.get("resourceId")+"&mode=visible&subCompanyId="+kv.get("subCompanyId");
	} else if ("custom".equals(type)) {
		navName=SystemEnv.getHtmlLabelName(18773,user.getLanguage());
		url="/page/maint/menu/CustomMenuMaintList.jsp?type="+kv.get("type")+"&isCustom="+kv.get("isCustom")+"&resourceType="+kv.get("resourceType")+"&resourceId="+kv.get("resourceId")+"&subCompanyId="+kv.get("subCompanyId");
	}
	navName = scc.getSubcompanyname(kv.get("subCompanyId")+"") +" "+ navName;
}else if("menuStyle".equals(_fromURL)){//菜单样式
	url = "/page/maint/style/MenuStyleList.jsp";
}else if("pLayout".equals(_fromURL)){//门户布局
	url = "/page/maint/template/login/List.jsp";
}else if("hpLayout".equals(_fromURL)){//页面布局
	url = "/page/maint/layout/LayoutList.jsp";
}else if("pElement".equals(_fromURL)){//门户元素
	url = "/admincenter/portalEngine/PortalElements.jsp";
}else if("pImg".equals(_fromURL)){//图片素材
	String file = Util.null2String((String)kv.get("file"));
	String dirid="";
	if("".equals(file)) {
		rs.executeSql("select dirid from ImageFolder where dirname ='image' and dirrealpath='page/resource/userfile/image'");
		if(rs.next()) dirid=rs.getString("dirid");
	}else{
		rs.executeSql("select dirid from ImageFolder where and dirrealpath='"+file+"'");
		if(rs.next()) dirid=rs.getString("dirid");
	}
	url = "/page/maint/common/CustomResourceList.jsp?file="+("".equals(file)?"image":file)+"&filedirid="+dirid;
}else if("eStyle".equals(_fromURL)){//元素样式
	url = "/page/maint/style/ElementStyleList.jsp";
}else if("newsTemplate".equals(_fromURL)){//新闻模版
	url = "/page/maint/template/news/NewsTemplateList.jsp";
}else if("pReferences".equals(_fromURL)){//查看元素引用
	if("0".equals(loginview)) {//登录后页面
		url = "/admincenter/portalEngine/PortalReferencesInfo.jsp?isDialog=1&ebaseid="+kv.get("ebaseid")+"&date=" + new Date().getTime();
	}else{
		url = "/admincenter/portalEngine/PortalReferencesInfo.jsp?isDialog=1&ebaseid="+kv.get("ebaseid")+"&date=" + new Date().getTime();
	}
}else if("loginTemplate".equals(_fromURL)){
	
	url = "/systeminfo/template/loginTemplateList.jsp";
}else if("ElementRegister".equals(_fromURL)){
	
	url = "/admincenter/portalEngine/ElementRegister.jsp";
}else if("DevelopmentGuide".equals(_fromURL)){
	
	url = "/admincenter/portalEngine/DevelopmentGuide.jsp";

}
else if("ElementSetting".equals(_fromURL)){
	navName = SystemEnv.getHtmlLabelName(33434,user.getLanguage());
	rs.executeSql("select infoname from hpinfo where id="+kv.get("hpid"));
	if(rs.next()) navName=rs.getString("infoname");
	url = "/homepage/Homepage.jsp?hpid="+kv.get("hpid")+"&subCompanyId="+kv.get("subCompanyId")+"&isfromportal="+kv.get("isfromportal")+"&isfromhp="+kv.get("isfromhp")+"&isSetting="+kv.get("isSetting")+"&from="+kv.get("from")+"&pagetype="+Util.null2String(kv.get("pagetype"))+"&isshowelemflag="+isshowelemflag+"&elemids="+elemids;
}
	
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
    	<% if(("hpManit".equals(_fromURL)&&"0".equals(loginview))||"hpTheme".equals(_fromURL)
    			||("hpMenu".equals(_fromURL)&&!isCustom.equals("true"))||"pImg".equals(_fromURL)){%>
        <li class="e8_tree">
        	<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage()) %></a>
        </li>
        <%}
        if("hpManit".equals(_fromURL)){//门户页面 %>
        <%navName="0".equals(loginview)?SystemEnv.getHtmlLabelName(23018,user.getLanguage()):SystemEnv.getHtmlLabelName(23017,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("hpTheme".equals(_fromURL)){//门户主题 %>
     	<%navName=SystemEnv.getHtmlLabelName(32462,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("hpMenu".equals(_fromURL)){//门户菜单 
			if("custom".equals(type)){
		%>
			<li class="current">
				<a href="<%=url %>&menuType=2" target="tabcontentframe">
					<%=SystemEnv.getHtmlLabelName(23022,user.getLanguage()) %>
				</a>
			</li>
			<%if(isCustom.equals("false")||isCustom.equals("")){%>
			<li>
				<a href="<%=url %>&menuType=1" target="tabcontentframe">
					<%=SystemEnv.getHtmlLabelName(23021,user.getLanguage()) %>
				</a>
			</li>
			<%}
			}else{%>
			<li class="defaultTab">
				<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
			</li>
		<%	}
		}else if("menuStyle".equals(_fromURL)){//菜单样式 %>
   		<%navName=SystemEnv.getHtmlLabelName(32126,user.getLanguage()); %>
        <li class="current">
        	<a href="<%=url %>?styleType=menuh" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(22914,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="<%=url %>?styleType=menuv" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(22915,user.getLanguage()) %>
        	</a>
        </li>
        <%}else if("pLayout".equals(_fromURL)){//门户布局 %>
      	<%navName=SystemEnv.getHtmlLabelName(32464,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("hpLayout".equals(_fromURL)){//页面布局 %>
        <%navName=SystemEnv.getHtmlLabelName(24666,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("pElement".equals(_fromURL)){//门户元素 %>
        <%navName=SystemEnv.getHtmlLabelName(32465,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("ElementRegister".equals(_fromURL)){//元素注册 %>
        <%navName=SystemEnv.getHtmlLabelName(33465,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
		<%}else if("DevelopmentGuide".equals(_fromURL)){//元素 开发指南 %>
        <%navName=SystemEnv.getHtmlLabelName(33668,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("pImg".equals(_fromURL)){//图片素材 %>
        <%navName=SystemEnv.getHtmlLabelName(32467,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("eStyle".equals(_fromURL)){//元素样式 %>
        <%navName=SystemEnv.getHtmlLabelName(32466,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("newsTemplate".equals(_fromURL)){//新闻模版 %>
        <%navName=SystemEnv.getHtmlLabelName(33680,user.getLanguage()); %>
        <li class="current">
        	<a href="<%=url %>?templatetype=0" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(1994,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="<%=url %>?templatetype=1" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(1995,user.getLanguage()) %>
        	</a>
        </li>
        <%}else if("pReferences".equals(_fromURL)){//查看元素引用 %>
        <%navName=SystemEnv.getHtmlLabelName(33153,user.getLanguage()); %>
        <%
        	String ebaseid = (String)kv.get("ebaseid");
        	ElementBaseCominfo ebc = new ElementBaseCominfo();
        	if(ebc.getLoginView(ebaseid).equals("0")){
        %>
        <li class="current">
        	<a href="<%=url %>&loginview=0" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(23018,user.getLanguage()) %>
        	</a>
        </li>
        <%
        	 url += "&loginview=0";
        }else{ %>
        <li class="current">
        	<a href="<%=url %>&loginview=1" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(23017,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="<%=url %>&loginview=0" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(23018,user.getLanguage()) %>
        	</a>
        </li>
        <%} %>
        <%}else if("loginTemplate".equals(_fromURL)){%>
        <%navName=SystemEnv.getHtmlLabelName(32459,user.getLanguage()); %>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("pageContent".equals(_fromURL)){%>
        	<%navName=SystemEnv.getHtmlLabelName(83782,user.getLanguage()); %>
        	<%if("2".equals(kv.get("menutype"))){ 
        		url="/homepage/maint/LoginPageBrowser.jsp?menutype=2&menuId=weavertabs-left&type=left&resourceId=1&resourceType=1";
        	%>
        		  <li class="current">
			        	<a href="/homepage/maint/LoginPageBrowser.jsp?menutype=2&menuId=weavertabs-left&type=left&resourceId=1&resourceType=1" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(17596,user.getLanguage()) %>
			        	</a>
			        </li>
			        <li>
			        	<a href="/homepage/maint/LoginPageBrowser.jsp?menutype=2&menuId=weavertabs-top&type=top&resourceId=1&resourceType=1" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(20611,user.getLanguage()) %>
			        	</a>
			        </li>
			         <li>
			        	<a href="/homepage/maint/LoginPageBrowser.jsp?menutype=2&menuId=weavertabs-cus" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(18773,user.getLanguage()) %>
			        	</a>
			        </li>
			          <li>
			        	<a href="/homepage/maint/LoginPageBrowser.jsp?menutype=2&menuId=weavertabs-hp" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(23094,user.getLanguage()) %>
			        	</a>
			        </li>
			         <li>
			        	<a href="/homepage/maint/LoginPageBrowser.jsp?menutype=2&menuId=weavertabs-sys&infoId=<%=infoId%>&type=<%=type%>&resourceId=<%=resourceId%>&resourceType=<%=resourceType%>" target="tabcontentframe">
			        		<%=SystemEnv.getHtmlLabelName(31560,user.getLanguage()) %>
			        	</a>
			        </li>
        	<%}else if("1".equals(kv.get("menutype"))){
        		url="/homepage/maint/LoginPageBrowser.jsp?menutype=1";
        	} %>
        	
        <%} %>
    </ul>
    <div id="rightBox" class="e8_rightBox"></div>
    		</div>
		</div>
	</div>
    
    <div class="tab_box">
        <div>
            <iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" frameborder="0" height="100%" width="100%;"></iframe>
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
        objName:"<%=navName%>"
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