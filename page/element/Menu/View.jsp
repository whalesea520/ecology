
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/element/loginViewCommon.jsp"%>
<%@ include file="common.jsp" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="mu" class="weaver.page.maint.MenuUtil" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hStyle" class="weaver.page.style.MenuHStyleCominfo" scope="page" />
<jsp:useBean id="vStyle" class="weaver.page.style.MenuVStyleCominfo" scope="page" />

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
	String menuIds = (String)valueList.get(nameList.indexOf("menuIds"));
	String menuStyle = (String)valueList.get(nameList.indexOf("menuTypeId"));
	String menuType = (String)valueList.get(nameList.indexOf("menuType"));	
	if(!"".equals(menuIds))
	rs.executeSql("select menutype from menucenter where id = '" + menuIds+"'");
	//System.out.println("select menutype from menucenter where id = '" + menuIds+"'");
	String loginMenuType = "";
	if(rs.next())
 		loginMenuType = Util.null2String(rs.getString("menutype"));
if(!"1".equals(loginMenuType)){//1 登陆前自定义菜单元素
%>
<%

if(menuType.equals("menuh")) {
	String returnStr= mu.getMenuTableStr_H(menuIds,0,Util.getIntValue(linkmode),loginuser);
	if(!"".equals(returnStr)){
%>
	
	<div id="menu_<%=eid%>" cornerTop='<%=hStyle.getCornerTop(menuStyle) %>'  cornerTopRadian='<%=hStyle.getCornerTopRadian(menuStyle) %>'  cornerBottom='<%=hStyle.getCornerBottomRadian(menuStyle) %>'  cornerBottomRadian='<%=hStyle.getCornerBottomRadian(menuStyle) %>'>
	<span id="spanMenu_<%=eid%>" class="menuh">	
	<%
		
	    out.println(returnStr);
	%>	
		<br style="clear: left" />
		<script type="text/javascript">
		if("<%=hStyle.getCornerTop(menuStyle)%>"=="Round"){
			$("#menu_<%=eid%>").corner("Round top <%=hStyle.getCornerTopRadian(menuStyle)%>"); 
		}
		if("<%=hStyle.getCornerBottom(menuStyle)%>"=="Round"){
			$("#menu_<%=eid%>").corner("Round bottom <%=hStyle.getCornerBottomRadian(menuStyle)%>"); 
		}
		menuh.init({
			mainmenuid: "spanMenu_<%=eid%>", 
			contentsource: "markup"
		})	
		</script>
	</span>
	</div>
<%
	}
} else if(menuType.equals("menuv")) {

	String returnStr= mu.getMenuTableStr_V(menuIds,Util.getIntValue(linkmode),loginuser);
	if(!"".equals(returnStr)){
		%>
	<div id="menu_<%=eid%>" class="sdmenu">	  
	 <%
		
	    out.println(returnStr);
	%>
	</div>	
	<script type="text/javascript">
	var mymenu = new SDMenu("menu_<%=eid%>");
	mymenu.init();
	</script>
	<%} 
}
}else{
	if(menuType.equals("menuh")) {
		String returnStr= mu.getMenuTableStr_H(menuIds,0,Util.getIntValue(linkmode));
		if(!"".equals(returnStr)){
	%>
		
		<div id="menu_<%=eid%>" cornerTop='<%=hStyle.getCornerTop(menuStyle) %>'  cornerTopRadian='<%=hStyle.getCornerTopRadian(menuStyle) %>'  cornerBottom='<%=hStyle.getCornerBottomRadian(menuStyle) %>'  cornerBottomRadian='<%=hStyle.getCornerBottomRadian(menuStyle) %>'>
		<span id="spanMenu_<%=eid%>" class="menuh">	
		<%
			
		    out.println(returnStr);
		%>	
			<br style="clear: left" />
			<script type="text/javascript">
			if("<%=hStyle.getCornerTop(menuStyle)%>"=="Round"){
				$("#menu_<%=eid%>").corner("Round top <%=hStyle.getCornerTopRadian(menuStyle)%>"); 
			}
			if("<%=hStyle.getCornerBottom(menuStyle)%>"=="Round"){
				$("#menu_<%=eid%>").corner("Round bottom <%=hStyle.getCornerBottomRadian(menuStyle)%>"); 
			}
			menuh.init({
				mainmenuid: "spanMenu_<%=eid%>", 
				contentsource: "markup"
			})
			</script>
		</span>
		</div>
	<%
		}
	} else if(menuType.equals("menuv")) {

		String returnStr= mu.getMenuTableStr_V(menuIds,Util.getIntValue(linkmode));
		if(!"".equals(returnStr)){
			%>
		<div id="menu_<%=eid%>" class="sdmenu">	  
		 <%
			
		    out.println(returnStr);
		%>
		</div>	
		<script type="text/javascript">
		var mymenu = new SDMenu("menu_<%=eid%>");
		mymenu.init();
		</script>
		<%} 
	}	
}
%>

