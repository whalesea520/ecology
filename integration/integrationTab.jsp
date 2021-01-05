
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.interfaces.workflow.browser.BaseBrowser" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<script type="text/javascript" src="banBackSpace.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FormActionBase" class="weaver.workflow.dmlaction.commands.bases.FormActionBase" scope="page" />
<jsp:useBean id="wsFormActionManager" class="weaver.workflow.action.WSFormActionManager" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<%
	String navName = "";
	String urlType = Util.null2String((String)request.getParameter("urlType"));
//		QC334358[80]Cas集成-E9已经完成CAS集成功能，整合到E8
    if("28".equals(urlType)) {
        if(!HrmUserVarify.checkUserRight("CAS:ALL",user)&&!"5".equals(urlType)) {
            response.sendRedirect("/notice/noright.jsp") ;
            return ;
        }
    } else {
        if(!HrmUserVarify.checkUserRight("SystemSetEdit:Edit",user)&&!"5".equals(urlType) ) {
            response.sendRedirect("/notice/noright.jsp") ;
            return ;
        }
    }



	String url = "/interface/outter/OutterSys.jsp?"+request.getQueryString();
	if("1".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(33717,user.getLanguage());
		url = "/integration/webserivcesettingList.jsp?"+request.getQueryString();
	}
	else if("2".equals(urlType))
	{
		navName = "LDAP";//集成
		url = "/integration/ldapsetting.jsp?"+request.getQueryString();
	}
	else if("3".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(32264,user.getLanguage());
		url = "/servicesetting/datasourcesetting.jsp?"+request.getQueryString();
	}
	else if("4".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(33719,user.getLanguage());//同步集成";
		url = "/integration/hrsetting.jsp?"+request.getQueryString();
	}
	else if("5".equals(urlType))
	{
		BaseBrowser browser=new BaseBrowser();
		String showtypeid = Util.null2String(request.getParameter("showtypeid"));//增加文件名
		browser.initBaseBrowser(showtypeid,"2","2");//增加文件名
		navName = browser.getName();//增加文件名
		url = "/integration/integrationCommonSearch.jsp?"+request.getQueryString();
	}
	else if("6".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(20961,user.getLanguage());
		url = "/interface/outter/OutterSys.jsp?"+request.getQueryString();
	}
	else if("7".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(16539,user.getLanguage());
		url = "/servicesetting/schedulesetting.jsp?"+request.getQueryString();
	}
	else if("8".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(32265,user.getLanguage());
		url="/integration/financelist.jsp?"+request.getQueryString();
	}
	else if("9".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(33720,user.getLanguage());
		url="/workflow/automaticwf/automaticsetting.jsp?"+request.getQueryString();
	}
	else if("10".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(32303,user.getLanguage());
		url="/integration/WsShowEditSetList.jsp?"+request.getQueryString();
	}
	else if("11".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(82 ,user.getLanguage())+SystemEnv.getHtmlLabelName(18076,user.getLanguage());
		url="/servicesetting/datasourcesettingnew.jsp?"+request.getQueryString();
	}
	else if("12".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelNames("82,16539",user.getLanguage());
		url="/servicesetting/schedulesettingnew.jsp?"+request.getQueryString();
	}
	else if("13".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(68,user.getLanguage())+SystemEnv.getHtmlLabelName(18596,user.getLanguage());
		url="/integration/hrsettingimport.jsp?"+request.getQueryString();
	}
	else if("14".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(27236 ,user.getLanguage());
		url="/interface/HrmManualSyn.jsp?"+request.getQueryString();
	}
	else if("15".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(17743 ,user.getLanguage());
		url="/hrm/resource/ExportHrmFromLdap.jsp?"+request.getQueryString();
	}
	else if("16".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(82 ,user.getLanguage())+SystemEnv.getHtmlLabelName(20960 ,user.getLanguage());
		url="/interface/outter/OutterSysAdd.jsp?"+request.getQueryString();
	}
	else if("17".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(93 ,user.getLanguage())+SystemEnv.getHtmlLabelName(20960 ,user.getLanguage());
		url="/interface/outter/OutterSysEdit.jsp?"+request.getQueryString();
	}
	else if("18".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(33387,user.getLanguage());//集成
		url = "/integration/rtxsetting.jsp?"+request.getQueryString();
	}else if("100".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(83203,user.getLanguage());//流程归档集成
		url = "/integration/exp/ExpWorkflowList.jsp?"+request.getQueryString();
	}
	else if("19".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelNames("82986",user.getLanguage());// 注册DML接口
		url = "/workflow/dmlaction/FormActionSettingAdd.jsp?"+request.getQueryString();
	}
	else if("20".equals(urlType))
	{
		int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
		if(actionid>0){
			FormActionBase.setActionid(actionid);
			FormActionBase.initDMLAction();
			navName = FormActionBase.getActionname();
		}else{
			navName = SystemEnv.getHtmlLabelNames("82986",user.getLanguage());// DML接口
		}
		url = "/workflow/dmlaction/FormActionSettingEdit.jsp?"+request.getQueryString();
	}
	else if("21".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelNames("82987",user.getLanguage());// 注册webservice接口
		url = "/workflow/action/WsFormActionEditSet.jsp?"+request.getQueryString();
	}
	else if("22".equals(urlType))
	{
		int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
		if(actionid>0){
			wsFormActionManager.setActionid(actionid);
			String formid = Util.null2String(request.getParameter("formid"));
			int isbill = Util.getIntValue(request.getParameter("isbill"),0);
			ArrayList wsActionList = wsFormActionManager.doSelectWsAction(Util.getIntValue(formid),isbill);
			if(wsActionList.size() > 0){
				ArrayList wsAction = (ArrayList)wsActionList.get(0);
				navName = Util.null2String((String)wsAction.get(1));
			}
		}else{
			navName = SystemEnv.getHtmlLabelNames("82987",user.getLanguage());// webservice接口
		}
		url = "/workflow/action/WsFormActionEditSet.jsp?"+request.getQueryString();
	}
	else if("23".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelNames("82988",user.getLanguage());// 自定义接口
		url = "/servicesetting/actionsettingnew.jsp?"+request.getQueryString();
	}
	else if("24".equals(urlType))
	{
		int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
		if(actionid>0){
			rs.executeSql("select * from actionsetting where id="+actionid);
			if(rs.next()){
				navName = Util.null2String(rs.getString("actionshowname"));
			}
		}else{
			navName = SystemEnv.getHtmlLabelNames("82988",user.getLanguage());// 自定义接口
		}
		url = "/servicesetting/actionsettingnew.jsp?"+request.getQueryString();
	}
	else if("25".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelNames("83319",user.getLanguage());// 新建流程接口部署
		url = "/workflow/action/WorkflowActionEditSet.jsp?"+request.getQueryString();
	}
	else if("26".equals(urlType))
	{
		int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);
		if(workflowid>0){
			navName = Util.null2String(WorkflowComInfo.getWorkflowname("" + workflowid));
		}else{
			navName = SystemEnv.getHtmlLabelNames("83319",user.getLanguage());// 流程接口部署
		}
		url = "/workflow/action/WorkflowActionEditSet.jsp?"+request.getQueryString();
//		QC334358[80]Cas集成-E9已经完成CAS集成功能，整合到E8
	}else if("28".equals(urlType)) {
        navName = SystemEnv.getHtmlLabelNames("128653",user.getLanguage());// WebSEAL集成
        url = "/integration/sso/cas/casSetting.jsp?"+request.getQueryString();
    }else if("101".equals(urlType))
	{
		navName = SystemEnv.getHtmlLabelName(127060,user.getLanguage());//统一待办中心
		url = "/integration/ofs/OfsInfoList.jsp?"+request.getQueryString();
	}
	else {
		response.sendRedirect("/integration/noMenu.jsp");
		return ;
	}
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("integration")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"<%=navName%>"
    });
}); 
</script>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
				 <%if("2".equals(urlType)){ %>
					  <ul class="tab_menu">
						<li class='current'>
					    	<a href="<%=url %>" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(32783,user.getLanguage()) %>
					    	</a>
					    </li>
					    <li>
					    	<a href="/hrm/resource/ExportHrmFromLdap.jsp" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(82923,user.getLanguage()) %>
					    	</a>
					    </li>
					    <li>
					    	<a href="/hrm/resource/LdapUserList.jsp" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(82924,user.getLanguage()) %>
					    	</a>
					    </li>
					  
					    <li>
					    	<a href="/ldap/LdapDesignateDepartment.jsp" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(82389,user.getLanguage()) %>
					    	</a>
					    </li>
					    
					    </ul>
				<%
					}
				 	else if("4".equals(urlType)){ %>
					  <ul class="tab_menu">
						<li class='current'>
					    	<a href="<%=url %>" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(32783,user.getLanguage()) %>
					    	</a>
					    </li>
					    <li>
					    	<a href="/interface/HrmManualSyn.jsp" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(82923,user.getLanguage()) %>
					    	</a>
					    </li>
					    </ul>
				<%
					}else if("18".equals(urlType)){ %>
					  <ul class="tab_menu">
						<li class='current'>
					    	<a href="<%=url %>" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage()) %>
					    	</a>
					    </li>
					    <li>
					    	<a href="/integration/imSynList.jsp" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(125928,user.getLanguage()) %>
					    	</a>
					    </li>
					    </ul>
				<%
					}else if("100".equals(urlType)){    //流程归档集成
					%>
					  <ul class="tab_menu">
						<li class='current'>
					    	<a href="<%=url%>" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(83253,user.getLanguage()) %>
					    	</a>
					    </li>
					    <li>
					    	<a href="/integration/exp/ExpSetting.jsp?_fromURL=1" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(83254,user.getLanguage()) %>
					    	</a>
					    </li>
					    <li>
					    	<a href="/integration/exp/ExpLogList.jsp" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(83255,user.getLanguage()) %>
					    	</a>
					    </li>
					    
					    </ul>
				<%
					}else if("101".equals(urlType)){    //统一待办中心
						%>
						  <ul class="tab_menu">
							<li class='current'>
						    	<a href="<%=url%>" target="tabcontentframe">
						    		<%=SystemEnv.getHtmlLabelName(31694,user.getLanguage()) %>
						    	</a>
						    </li>
						    <li>
						    	<a href="/integration/ofs/OfsToDodataList.jsp" target="tabcontentframe">
						    		<%=SystemEnv.getHtmlLabelName(126871,user.getLanguage()) %>
						    	</a>
						    </li>
						    <li>
						    	<a href="/integration/ofs/OfslogList.jsp" target="tabcontentframe">
						    		<%=SystemEnv.getHtmlLabelName(31695,user.getLanguage()) %>
						    	</a>
						    </li>
						     <li>
						    	<a href="/integration/ofs/OfsSetting.jsp" target="tabcontentframe">
						    		<%=SystemEnv.getHtmlLabelName(126873,user.getLanguage()) %>
						    	</a>
						    </li>
						    
						    </ul>
					<%
					}
					else if("6".equals(urlType)){ 
						%>
						  <ul class="tab_menu">
							 <ul class="tab_menu">
						<li class='current'>
					    	<a href="/interface/outter/OutterSys.jsp?<%=request.getQueryString()%>" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(125405,user.getLanguage()) %>
					    	</a>
					    </li>
					    <li>
					    	<a href="/interface/outter/outter_encryptclass.jsp?<%=request.getQueryString()%>" target="tabcontentframe">
					    		<%=SystemEnv.getHtmlLabelName(125409,user.getLanguage()) %>
					    		
					    	</a>
					    </li>
					    
				 </ul>
						    
						    </ul>
					<%
						}
				 	else{
				 %>
				    <ul class="tab_menu">
				    	<li class="defaultTab">
							<a href="#" onclick="return false;" target="tabcontentframe">
						        <%=TimeUtil.getCurrentTimeString() %>
							</a>
						</li>
				    </ul>
				    <%} %>
				    <div id="rightBox" class="e8_rightBox">
				    </div>
				    </div>
		</div>
	</div>
				    
				    <div class="tab_box">
				        <div>
				            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				        </div>
				    </div>
	</div>
</body>
</html>