
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>

<%
	String method = Util.null2String(request.getParameter("method"));	
	if("addsubmenu".equals(method)){
		String name=Util.null2String(request.getParameter("name"));	
		String desc=Util.null2String(request.getParameter("desc"));	
		String icon=Util.null2String(request.getParameter("icon"));	
		String href=Util.null2String(request.getParameter("href"));	
		String target=Util.null2String(request.getParameter("target"));	
		String type=Util.null2String(request.getParameter("type"));	
		String parentid=Util.null2String(request.getParameter("parentid"));	

		String sql="insert into menucustom(menuname,menudesc,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype) values ('"+name+"','"+desc+"','"+icon+"','"+href+"','"+target+"',"+parentid+",'','"+type+"')";
		rs.executeSql(sql);
	
		rs.executeSql("select max(id) from menucustom where menutype='"+type+"'");
		rs.next();
		int maxid=rs.getInt(1);
		
		String nodeStr="";
		rs.executeSql("select * from menucustom where id='"+maxid+"'");
		if(rs.next()){
			int id=rs.getInt("id");
			String menuname=Util.null2String(rs.getString("menuname")); 
		
			nodeStr="new Ext.tree.TreeNode({'id':"+id+",'text':'"+menuname+"','leaf':true,'draggable':true})";
		}
		out.println(nodeStr);	
	}

%>