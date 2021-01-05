
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<%
	String type=Util.null2String(request.getParameter("type"));
	String showtype=Util.null2String(request.getParameter("showtype"));
%>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<body scroll="no" >
<%
if("21".equals(showtype)) {
	if(!HrmUserVarify.checkUserRight("CoreMail:ALL",user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}
	String loadurl="";
	String navName = "";
	if(showtype.equals("1"))
	{
		navName = SystemEnv.getHtmlLabelName(26968 ,user.getLanguage());//SAP集成
		if("1".equals(type)){
			loadurl="/integration/downloadDriveFile.jsp";
		}else if("0".equals(type)){
			loadurl="/integration/dataInterlist.jsp";
		}else if("2".equals(type)){
			String typename = "";
 			if(showtype.equals("2"))
	 		{
	 			typename = "1";
	 		}
	 		else if(showtype.equals("3"))
	 		{
	 			typename = "2";
	 		}
	 		else if(showtype.equals("4"))
	 		{
	 			typename = "3";
	 		}
	 		else if(showtype.equals("5"))
	 		{
	 			typename = "4";
	 		}
			loadurl="/servicesetting/datasourcesettingnew.jsp?typename="+typename;
		}else if("3".equals(type)){
			loadurl="/integration/serviceReg/serviceRegMain.jsp?showtype=1";
		}else if("4".equals(type)){
			loadurl="/integration/serviceReg/serviceRegMain.jsp?showtype=2";
		}else if("5".equals(type)){
			loadurl="/integration/sapLog/logMainDetail.jsp";
		}
		else if("6".equals(type)){
			loadurl="/workflow/automaticwf/automaticsettingView.jsp";
		}
		else if("7".equals(type)){
			loadurl="/integration/Monitoring/FieldSystem.jsp";
		}
		else if("8".equals(type)){
			loadurl="/integration/Monitoring/JarSystem.jsp";
		}
		else if("9".equals(type)){
			loadurl="/integration/Monitoring/WfSystem.jsp";
		}
	}
	else if(showtype.equals("2")||showtype.equals("3")||showtype.equals("4")||showtype.equals("5"))
	{
		String typename = "";
		if(showtype.equals("2"))
 		{
			navName = "NC";
 			typename = "1";
 		}
 		else if(showtype.equals("3"))
 		{
 			navName = "EAS";
 			typename = "2";
 		}
 		else if(showtype.equals("4"))
 		{
 			navName = "U8";
 			typename = "3";
 		}
 		else if(showtype.equals("5"))
 		{
 			navName = "K3";
 			typename = "4";
 		}
		if("1".equals(type)){
			loadurl="/interface/outter/OutterSys.jsp?typename="+typename;
		}else if("2".equals(type)){
			loadurl="/integration/heteProductslist.jsp";
		}else if("3".equals(type)){
			loadurl="/integration/serviceReg/serviceRegMain.jsp?showtype=1";
		}else if("4".equals(type)){
			loadurl="/integration/serviceReg/serviceRegMain.jsp?showtype=2";
		}else if("5".equals(type)){
			loadurl="/integration/sapLog/logMainDetail.jsp";
		}
		else if("6".equals(type)){
			loadurl="/integration/Monitoring/FunSystem.jsp";
		}
		else if("7".equals(type)){
			loadurl="/integration/Monitoring/FieldSystem.jsp";
		}
		else if("8".equals(type)){
			loadurl="/integration/Monitoring/JarSystem.jsp";
		}
		else if("9".equals(type)){
			loadurl="/integration/Monitoring/WfSystem.jsp";
		}
	}
	else if(showtype.equals("6"))
	{
		navName = SystemEnv.getHtmlLabelName(23082,user.getLanguage());
		if("2".equals(type)){
			loadurl="/docs/change/DocChangeSystemSet.jsp";
		}
		else
			loadurl="/docs/change/DocChangeSetting.jsp";
	}
	else if(showtype.equals("7"))
	{
		loadurl="/servicesetting/schedulesetting.jsp";
	}
	else if(showtype.equals("8"))
	{
		navName = SystemEnv.getHtmlLabelName(33720,user.getLanguage());
		loadurl="/workflow/automaticwf/automaticsetting.jsp";
	}
	else if(showtype.equals("9"))
	{
		navName = SystemEnv.getHtmlLabelName(32265,user.getLanguage());
		loadurl="/integration/financelist.jsp";
	}
	else if(showtype.equals("10"))
	{
		navName = SystemEnv.getHtmlLabelName(32338,user.getLanguage());
		loadurl="/integration/formactionlist.jsp";
	}
	else if(showtype.equals("11"))
	{
		navName = SystemEnv.getHtmlLabelName(32303,user.getLanguage());
		loadurl="/integration/WsShowEditSetList.jsp";
	}
	else if(showtype.equals("12"))
	{
		navName = SystemEnv.getHtmlLabelName(33720,user.getLanguage());
		loadurl="/workflow/automaticwf/automaticsetting.jsp";
	}
	else if(showtype.equals("13"))
	{
		navName = SystemEnv.getHtmlLabelName(83316,user.getLanguage());//注册DML接口
		loadurl="/workflow/dmlaction/FormActionSettingAdd.jsp?"+request.getQueryString();
	}
	else if(showtype.equals("14"))
	{
		navName = SystemEnv.getHtmlLabelName(83317,user.getLanguage());//注册Webservice接口
		loadurl="/workflow/action/WsFormActionEditSet.jsp?"+request.getQueryString();
	}
	else if(showtype.equals("15"))
	{
		navName = SystemEnv.getHtmlLabelName(83318,user.getLanguage());//注册自定义接口
		loadurl="/servicesetting/actionsettingnew.jsp?"+request.getQueryString();
	}
	else if(showtype.equals("21")) {// coremail邮箱
		navName = SystemEnv.getHtmlLabelName(129787,user.getLanguage());// CoreMail集成
		
		if("1".equals(type)) {// 基础信息
			loadurl = "/integration/coremail/coremailsetting.jsp";
		}
		else if("2".equals(type)) {// 集成登录
			loadurl = "/interface/outter/OutterSys.jsp?typename=8";
		}
		else if("3".equals(type)) {// 同步日志
			loadurl = "/integration/coremail/coremailSynLog.jsp";
		}
	}
%>
	<script type="text/javascript">
		$(function(){
		    $('.e8_box').Tabs({
		        getLine:1,
		        iframe:"tabcontentframe",
		        mouldID:"<%=MouldIDConst.getID("integration")%>",
		        staticOnLoad:true,
		        notRefreshIfrm:true,
		        objName:"<%=navName%>
				",
						hideSelector : "#automaticbox"
					});
				});
	</script>
<div class="e8_box demo2">
<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
		<%if(showtype.equals("1")){ %>
			<ul class="tab_menu">
				<!-- add by wshen -->
				<li <%if("1".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/downloadDriveFile.jsp" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(82620 ,user.getLanguage()) %><!--驱动下载-->
			    	</a>
				</li><!-- 驱动下载 -->
				<li <%if("0".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/dataInterlist.jsp" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(30681,user.getLanguage())%><!-- 交互方式 -->
			    	</a>
			    </li>
				<li <%if("2".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/heteProductslist.jsp" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(31694,user.getLanguage())%>
			    	</a>
			    </li>
	
				<li <%if("3".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/serviceReg/serviceRegMain.jsp?showtype=1" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(18076,user.getLanguage())%>
			    	</a>
			    </li>
	
				<li <%if("4".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/serviceReg/serviceRegMain.jsp?showtype=2" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(30624,user.getLanguage())%>
			    	</a>
			    </li>

				<li <%if("5".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/sapLog/logMainDetail.jsp" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(31695,user.getLanguage())%>
			    	</a>
			    </li>
	
				<li <%if("6".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/Monitoring/FunSystem.jsp" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(31696,user.getLanguage())%>
			    	</a>
			    </li>
	
				<li <%if("7".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/Monitoring/FieldSystem.jsp" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(31632,user.getLanguage())%>
			    	</a>
			    </li>
	
	
				<li <%if("8".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/Monitoring/JarSystem.jsp" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(31697,user.getLanguage())%>
			    	</a>
			    </li>
	
	
				<li <%if("9".equals(type)){out.print("class='current'");}%>>
			    	<a href="/integration/Monitoring/WfSystem.jsp" target="tabcontentframe">
			    		<%=SystemEnv.getHtmlLabelName(31698,user.getLanguage())%>
			    	</a>
			    </li>
  			</ul>
<%
}
else
{
	if(showtype.equals("2")||showtype.equals("3")||showtype.equals("4")||showtype.equals("5")){ %>
	
	  <ul class="tab_menu">
		<li <%if("1".equals(type)){out.print("class='current'");}%>>
	    	<a href="/interface/outter/OutterSys.jsp?typename=<%=(Util.getIntValue(showtype,2)-1) %>" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(20960,user.getLanguage())%><!-- 集成登录 -->
	    	</a>
	    </li>
	    <li <%if("2".equals(type)){out.print("class='current'");}%>>
	    	<a href="/servicesetting/datasourcesettingnew.jsp?typename=<%=(Util.getIntValue(showtype,2)-1) %>" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(32264,user.getLanguage())%><!-- 数据源设置 -->
	    	</a>
	    </li>
	    <li <%if("3".equals(type)){out.print("class='current'");}%>>
	    	<a href="/integration/hrsetting.jsp" target="tabcontentframe">
	    		HR<%=SystemEnv.getHtmlLabelName(18240,user.getLanguage())%><!-- HR同步 -->
	    	</a>
	    </li>
	    <li <%if("4".equals(type)){out.print("class='current'");}%>>
	    	<a href="/integration/financelist.jsp?typename=<%=(Util.getIntValue(showtype,2)-1) %>" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(32265,user.getLanguage())%><!-- 财务凭证 -->
	    	</a>
	    </li>
	    <li <%if("5".equals(type)){out.print("class='current'");}%>>
	    	<a href="/integration/WsShowEditSetList.jsp?typename=<%=(Util.getIntValue(showtype,2)-1) %>" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(32266,user.getLanguage())%><!-- 数据展现 -->
	    	</a>
	    </li>
	    <li <%if("6".equals(type)){out.print("class='current'");}%>>
	    	<a  href="/workflow/automaticwf/automaticsetting.jsp?typename=<%=(Util.getIntValue(showtype,2)-1) %>" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(32267,user.getLanguage())%><!-- 流程创建 -->
	    	</a>
	    </li>
	    <li <%if("7".equals(type)){out.print("class='current'");}%>>
	    	<a  href="/integration/dmllist.jsp?typename=<%=(Util.getIntValue(showtype,2)-1) %>" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(32268,user.getLanguage())%><!-- 业务驱动 -->
	    	</a>
	    </li>
	    </ul>
<%
	}
	else if(showtype.equals("6")){ %>
	  <ul class="tab_menu">
		<li <%if("1".equals(type)){out.print("class='current'");}%>>
	    	<a href="/docs/change/DocChangeSetting.jsp" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(22876,user.getLanguage())%><!-- 公文交换流程设置 -->
	    	</a>
	    </li>
	    <li>
	    	<a href="/docs/change/DocChangeSystemSet.jsp" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(23098,user.getLanguage())%><!-- 公文交换设置 -->
	    	</a>
	    </li>
	    </ul>
<%
	}
	else if(showtype.equals("10")){ %>
	  <ul class="tab_menu">
	   <li class='current'>
	    	<a href="/integration/formactionlist.jsp" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(83002 ,user.getLanguage())%><!-- 流程接口注册 -->
	    	</a>
	    </li>
	   <li>
	    	<a href="/integration/dmllist.jsp" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(83319,user.getLanguage())%><!-- 流程接口部署 -->
	    	</a>
	    </li>
	  </ul>
<%
	}
	else if(showtype.equals("11")){ %>
	  <ul class="tab_menu">
	   <li class='current'>
	    	<a href="/integration/WsShowEditSetList.jsp" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(32301,user.getLanguage())%><!-- 数据展示集成列表 -->
	    	</a>
	    </li>
	    <li>
	    	<a href="/servicesetting/browsersetting.jsp?type=2" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(32302,user.getLanguage())%><!-- 数据展示浏览框列表 -->
	    	</a>
	    </li>
	  </ul>
<%
	}
	else if(showtype.equals("12")){ %>
	  <ul class="tab_menu">
	   <li class='current'>
	    	<a onmouseover="javascript:showSecTabMenu('#automaticbox','tabcontentframe');" href="/workflow/automaticwf/automaticsetting.jsp" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(32366,user.getLanguage())%><!-- 流程触发集成列表 -->
	    	</a>
	    </li>
	    <li>
	    	<a href="/workflow/automaticwf/automaticperiodsetting.jsp" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(23112,user.getLanguage())%><!-- 触发周期设置 -->
	    	</a>
	    </li>
	  </ul>
<%
	}
	else if(showtype.equals("13")){ %>
	  <ul class="tab_menu">
	   <li class='current'>
	    	<a href="/integration/formactionlist.jsp" target="tabcontentframe">
	    		<%=SystemEnv.getHtmlLabelName(83002 ,user.getLanguage())%><!-- 流程接口注册 -->
	    	</a>
	    </li>
	  </ul>
<%
	}
	else if (showtype.equals("21")) {
		%>
		<ul class="tab_menu">
			<li <%if ("1".equals(type)) {
			out.print("class='current'");
		}%>>
				<a href="/integration/coremail/coremailsetting.jsp"
				target="tabcontentframe"> <%=SystemEnv.getHtmlLabelName(82743, user.getLanguage())%>
			</a>
			</li>
			<li <%if ("2".equals(type)) {
			out.print("class='current'");
		}%>>
				<a href="/interface/outter/OutterSys.jsp?typename=8"
				target="tabcontentframe"> <%=SystemEnv.getHtmlLabelName(20960, user.getLanguage())%>
			</a>
			</li>
			<li <%if ("3".equals(type)) {
			out.print("class='current'");
		}%>>
				<a href="/integration/coremail/coremailSynLog.jsp"
				target="tabcontentframe"> <%=SystemEnv.getHtmlLabelName(125928, user.getLanguage())%>
			</a>
			</li>
		</ul>
		<%
	}
	else{//计划任务等 %>
	  <ul class="tab_menu">
	  </ul>
<%
	}
	//System.out.println("loadurl : "+loadurl);
%>
	
<%
}
%>
	<div id="rightBox" class="e8_rightBox">
	</div>
  </div>
 </div>
</div>
	
	<div class="tab_box">
	    <div>
	        <iframe src="<%=loadurl%>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	    </div>
	</div>
</div>
</body>
<script type="text/javascript">
	
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("integration")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"<%=navName%>",
        hideSelector:"#automaticbox"
    });
});
	
</script>
</html>