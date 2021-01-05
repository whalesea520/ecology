
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/init.jsp"%>
<%@ page import="weaver.page.menu.*"%>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="weaver.conn.RecordSet" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>
<jsp:useBean id="menuUtil" class="weaver.page.maint.MenuUtil" scope="page"/>
<%
	String id = Util.null2String(request.getParameter("id"));
	String menuId = Util.null2String(request.getParameter("menuId"));
	String parentid=Util.null2String(request.getParameter("parentid"));
	String menu_type=Util.null2String(request.getParameter("menu_type"));
	StringBuffer sb = new StringBuffer();
	MenuH menuh = null;
	if("weavertabs-left".equals(id))
	{
		menuh = MenuHFactory.creatorMenuH("left");
		sb.append(menuh.getMenuStr("left", user));
	}else if("weavertabs-cus".equals(id)){
	    StringBuffer treeStr = new StringBuffer();
        treeStr.append("[");
        String sqlWhere = "";
        if(parentid.equals("0")){
            sqlWhere=" where menuparentid=0 ";
        }else if(!parentid.equals("0")&&!menu_type.equals("")){
            sqlWhere=" where menuparentid="+parentid+" and menutype="+menu_type; 
        }
        String sql = "select *  from menucustom "+sqlWhere;
         rs.executeSql(sql);
         while (rs.next()) {
             if(!menuUtil.hasShareRight(user, rs.getString("sharetype"), rs.getString("sharevalue"),rs.getInt("id"),menu_type)){
                 continue;
             }
             JSONObject json = new JSONObject ();
             String menu_id = rs.getString("id");
             String menuname = rs.getString("menuname");
             String menuhref = rs.getString("menuhref");
             String menuparentid=rs.getString("menuparentid");
             String menutype=rs.getString("menutype");
             json.put("id",menu_id);
             int count=0;
             RecordSet rst=new RecordSet();
             String sqlCount="select count(*) as count  from menucustom where menuparentid="+menu_id+" and menutype="+menutype; 
             rst.executeSql(sqlCount);
             while(rst.next()){
                 count=Integer.valueOf(rst.getString("count"));
             }
             json.put("isParent",count>0); 
             json.put("name",menuname);
             json.put("linkAddress",menuhref);
             json.put("parentId",menuparentid);
             json.put("menu_type",menutype);
             treeStr.append(json.toString());
             treeStr.append(",");
         }
         if(treeStr.length()==1){
             out.print("[]");
         }else{
             out.print(treeStr.toString().substring(0,treeStr.toString().length()-1)+"]");
         }
	}
	else if("weavertabs-cus-old".equals(id))
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
			sb.append("<li style=\"list-style-type: none;\"><a style=\"text-decoration: none;\" href=\"javascript:void(null);\" onclick=\"openNextUl(this);\">"+menuname+"</a>");
		
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
	else if("weavertabs-hp".equals(id)){
	    StringBuffer treeStr = new StringBuffer();
        treeStr.append("[");
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
         sqlWhere+=" and pid="+parentid;
         String sql = "select *  from hpinfo "+sqlWhere;
         rs.executeSql(sql);
         while (rs.next()) {
             JSONObject json = new JSONObject ();
             String hpid = rs.getString("id");
             String subCompanyId = rs.getString("subcompanyid");
             String infoname = rs.getString("infoname");
             String pid=rs.getString("pid");
             String linkAddress="/homepage/Homepage.jsp?hpid="+hpid+"&subCompanyId="+subCompanyId;
             json.put("id",hpid);
             int count=0;
             RecordSet rst=new RecordSet();
             String sqlCount="select count(*) as count  from hpinfo where pid="+hpid; 
             rst.executeSql(sqlCount);
             while(rst.next()){
                 count=Integer.valueOf(rst.getString("count"));
             }
             json.put("isParent",count>0); 
             json.put("name",infoname);
             json.put("linkAddress",linkAddress);
             json.put("parentid",pid);
             treeStr.append(json.toString());
             treeStr.append(",");
         }
         if(treeStr.length()==1){
             out.print("[]");
         }else{
             out.print(treeStr.toString().substring(0,treeStr.toString().length()-1)+"]");
         }
	}
	else if("weavertabs-hp-old".equals(id))
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