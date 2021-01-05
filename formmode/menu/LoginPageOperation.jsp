
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/init.jsp"%>
<%@ page import="weaver.page.menu.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>
<%
	String id = Util.null2String(request.getParameter("id"));
	String menutype = Util.null2String(request.getParameter("menutype"));
	String menuId = Util.null2String(request.getParameter("menuId"));
	StringBuffer sb = new StringBuffer();
	MenuH menuh = null;
	if("weavertabs-left".equals(id))
	{
		menuh = MenuHFactory.creatorMenuH("left");
		sb.append(menuh.getMenuStr("left", user));
	}
	else if("weavertabs-cus".equals(id))
	{
		sb.append("<ul>");
		MenuCenterCominfo.setTofirstRow();		
		
		while(MenuCenterCominfo.next())
		{
			
			String pid = MenuCenterCominfo.getId();
			String menuname = MenuCenterCominfo.getMenuname();
			String mmenutype = MenuCenterCominfo.getMenutype();
			if("sys".equals(mmenutype))
			{
				continue;
			}
			if(pid.equals(menuId))
			{
				continue;
			}
			sb.append("<li style=\"list-style-type: none;\"><img src=/images/messageimages/minus_wev8.gif><a style=\"color: #000;text-decoration: none;\" href=\"javascript:void(null);\" onclick=\"openNextUl(this);\">"+menuname+"</a>");
		
			menuh = MenuHFactory.creatorMenuH(pid);
			sb.append(menuh.getMenuStr(pid, user));
		
			sb.append("</li>");
		}
		sb.append("</ul>");
	}
	else if("weavertabs-top".equals(id))
	{
		menuh = MenuHFactory.creatorMenuH("top");
		sb.append(menuh.getMenuStr("top", user));
	}
	else if("weavertabs-hpmenus".equals(id))
	{
		menuh = MenuHFactory.creatorMenuH("hp");
		sb.append(menuh.getMenuStr("hp", user));
	}
	else if("weavertabs-hp".equals(id))
	{
		sb.append("<ul>");
		String sqlWhere = "";
		if ("sqlserver".equals(rs.getDBType()))
		{
			if (user.getUID()==1)
			{  //sysadmin
				sqlWhere = " where  (creatortype=4  or creatortype=3  ) and  infoname != ''";
			} else 
			{
				sqlWhere = " where   (creatortype=3) and  infoname != ''";
			}
		} 
		else 
		{
			if (user.getUID()==1)
			{  //sysadmin
				sqlWhere = " where  (creatortype=4  or creatortype=3) and  infoname is not null";
			} 
			else 
			{
				sqlWhere = " where   (creatortype=3) and  infoname is not null";
			}
		}
		String sql = "select *  from hpinfo "+sqlWhere;
		rs.executeSql(sql);
		while(rs.next())
		{
			String hpid = rs.getString("id");
			String subCompanyId = rs.getString("subcompanyid");
			String infoname = rs.getString("infoname");
			String htmlli = "<li><a href='/homepage/Homepage.jsp?hpid="+hpid+"&subCompanyId="+subCompanyId+"' class='main'>"+infoname+"</a>\n";
			sb.append(htmlli);
		}
		sb.append("</ul>");
	}
	else if("weavertabs-sys".equals(id))
	{
		sb.append("test");
	}
	out.println(sb.toString());
%>