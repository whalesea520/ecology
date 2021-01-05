<jsp:useBean id="esc" class="weaver.page.style.ElementStyleCominfo" scope="page"/>
<jsp:useBean id="mhsc" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="mvsc" class="weaver.page.style.MenuVStyleCominfo" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page" />

<%@page import="java.util.ArrayList"%>
<%--以下为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ include file="/page/element/settingCommon_params.jsp"%>
<%@ include file="common.jsp"%>
<wea:layout type="2Col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'class':\"e8_title e8_title_1\"}">
<%@ include file="/page/element/settingCommon_dom.jsp"%>

<%--以上，为支持JBOSS应用服务器校验语法，作出如下改动，将<wea:layout>和<wea:group>标签头移入此页面保证标签有始有终--%>

<%
	String menuIds = (String)valueList.get(nameList.indexOf("menuIds"));
	String menuType = (String)valueList.get(nameList.indexOf("menuType"));
	String menuTypeId = (String)valueList.get(nameList.indexOf("menuTypeId"));
	//菜单名称
	String menuName = "";
	//菜单样式名称
	String menuTypeName = "";
	//获取菜单样式的链接地址
	String tmenuTypeLink = "";
	String menuTypeLink = "";
	if ("element".equals(menuType)&&!"".equals(menuTypeId))
	{
		tmenuTypeLink = "ElementStyleEdit.jsp";
		esc.setTofirstRow();						
		while(esc.next())
		{
			if(menuTypeId.equals(esc.getId()))
			{
				menuTypeName = esc.getTitle();
			}
		}
	}
	else if ("menuh".equals(menuType)&&!"".equals(menuTypeId))
	{
		tmenuTypeLink = "MenuStyleEditH.jsp";
		mhsc.setTofirstRow();						
		while(mhsc.next())
		{
			if(menuTypeId.equals(mhsc.getId()))
			{
				menuTypeName = mhsc.getTitle();
			}
		}
	}
	else if ("menuv".equals(menuType)&&!"".equals(menuTypeId))
	{
		tmenuTypeLink = "MenuStyleEditV.jsp";
		mvsc.setTofirstRow();		
		while(mvsc.next())
		{
			if(menuTypeId.equals(mvsc.getId()))
			{
				menuTypeName = mvsc.getTitle();
			}
		}
	}
	
	if(!"".equals(tmenuTypeLink)&&!"".equals(menuTypeId))
	{
		menuTypeLink = "/page/maint/style/"+tmenuTypeLink+"?styleid="+menuTypeId+"&type="+menuType+"&from=list";
	}
	//获取菜单的链接地址
	String menuLink = "javascript:void(0);";
	if("hp".equals(menuIds))
	{
		menuLink = "/homepage/maint/HomepageLocation.jsp";
	}
	else if("sys".equals(menuIds))
	{
		menuLink = "/systeminfo/menuconfig/MenuMaintFrame.jsp?type="+menuIds;
	}
	else
	{
		menuLink = "/page/maint/menu/MenuEdit.jsp?id="+menuIds;
	}
	if(!"".equals(menuIds))
	{
		MenuCenterCominfo.setTofirstRow();
		while (MenuCenterCominfo.next())
		{
			
			String tmenuType = MenuCenterCominfo.getMenutype();
			if(menuIds.equals(MenuCenterCominfo.getId()))
			{
				menuName = MenuCenterCominfo.getMenuname();
			}
		}
	}
	
%>
<script type="text/javascript">
     
     
   
</script>

	<%
if("2".equals(esharelevel)){
		%>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(18773,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT id="menuIds_<%=eid%>" type=hidden value="<%=menuIds %>" name="menuIds_<%=eid%>">
		<BUTTON  type='button' class=Browser onclick=onShowMenus(menuIds_<%=eid%>,spanMenuId_<%=eid%>,<%=eid%>)></BUTTON>
		<SPAN id=spanMenuId_<%=eid%>>
			<%
			if(!"".equals(menuIds))
			{ 
			%>
			<a href="<%=menuLink %>" target="_blank"><%=menuName %></a>
			<%
			}
			%>
		</SPAN>
	</wea:item>
	<wea:item>&nbsp;<%=SystemEnv.getHtmlLabelName(22916,user.getLanguage())%></wea:item>
	<wea:item>
		<INPUT id="menuType_<%=eid%>" type="radio" <%if(menuType.equals("menuh")) out.print("checked");%>
							name="menuType_<%=eid%>" selecttype="1" value='menuh' onclick="onClickMenuType(this,'<%=eid %>');"/>&nbsp;<%=SystemEnv.getHtmlLabelName(22917,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(31501,user.getLanguage())%>)	
		<INPUT id="menuType_<%=eid%>" type="radio" <%if(menuType.equals("menuv")) out.print("checked");%>
							name="menuType_<%=eid%>" selecttype="1" value='menuv' onclick="onClickMenuType(this,'<%=eid %>');"/>&nbsp;<%=SystemEnv.getHtmlLabelName(22918,user.getLanguage())%>(<%=SystemEnv.getHtmlLabelName(31502,user.getLanguage())%>)
		</SPAN>
	</wea:item>
	<wea:item>&nbsp;</wea:item>
	<wea:item>
		<INPUT id="tempMenuTypeId_<%=eid%>" type=hidden value="<%=menuType %>" name="tempMenuTypeId_<%=eid%>">
		<INPUT id="menuTypeId_<%=eid%>" type=hidden value="<%=menuTypeId %>" name="menuTypeId_<%=eid%>">
		<BUTTON type='button' class=Browser onclick="onShowMenuTypes2(menuTypeId_<%=eid%>,spanMenuTypeId_<%=eid%>,<%=eid%>,tempMenuTypeId_<%=eid%>)"></BUTTON>
		<SPAN id=spanMenuTypeId_<%=eid%>>
			<%
			if(!"".equals(menuTypeId))
			{ 
			%>
			<a href="<%=menuTypeLink.toString() %>" target="_blank"><%=menuTypeName %></a>
			<%
			}
			%>
		</SPAN>
	</wea:item>
	<%} %>
	</wea:group>
</wea:layout>
