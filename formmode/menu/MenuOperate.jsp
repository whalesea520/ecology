
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="java.net.*" %>
<%@ page import="org.json.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="MenuCenterCominfo" class="weaver.page.menu.MenuCenterCominfo" scope="page"/>

<%
	boolean HeadMenuhasRight = HrmUserVarify.checkUserRight("HeadMenu:Maint", user);	//总部菜单维护权限 
	boolean SubMenuRight = HrmUserVarify.checkUserRight("SubMenu:Maint", user);			//分部菜单维护权限  
	String menuflag = Util.null2String(request.getParameter("menuflag"));//表单建模新增菜单地址
	boolean hasRight = false;
	if(HeadMenuhasRight || SubMenuRight)
		hasRight = true;
	if(!hasRight){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String method = Util.null2String(request.getParameter("method"));	
	String subCompanyId = Util.null2String(request.getParameter("subCompanyId"));
	if("add".equals(method)){
		String menuname = Util.null2String(request.getParameter("menuname"));	
		String menudesc = Util.null2String(request.getParameter("menudesc"));	
		String menutype = Util.null2String(request.getParameter("menutype"));
		String sql="";
		
		long now = System.currentTimeMillis();

		//insert data to menu center
		sql="insert into menucenter(id,menuname,menudesc,menutype,subcompanyid) values ('"+now+"','"+menuname+"','"+menudesc+"','"+menutype+"','"+subCompanyId+"')";
		rs.executeSql(sql);
		//update menu center cache
		//MenuCenterCominfo.updateCache(""+now);
		MenuCenterCominfo.clearCominfoCache();
		sql="insert into menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue) values (1,'"+ SystemEnv.getHtmlLabelName(22834, user.getLanguage()) +"','','','mainiframe','0','1','"+now+"','','','5','1')";
		
		rs.executeSql(sql);
		
		response.getWriter().println("<script type=\"text/javascript\">parent.closeDialogAndRefreshWin();</script>");
		//response.sendRedirect("/formmode/menu/MenuEdit.jsp?menuflag="+menuflag+"&menutype="+menutype+"&id="+now+"&subCompanyId="+subCompanyId+"&isclose=1");
	} else if("del".equals(method)){
		String menuid = Util.null2String(request.getParameter("menuid"));	
		String menutype = Util.null2String(request.getParameter("menutype"));
		String sql="";
		sql="delete menucenter where id='"+menuid+"'";
		rs.executeSql(sql);

		sql="delete menucustom where menutype='"+menuid+"'";
		rs.executeSql(sql);
		
		//MenuCenterCominfo.updateCache(""+menuid);
		MenuCenterCominfo.clearCominfoCache();
		
		response.getWriter().println("<script type=\"text/javascript\">parent.closeDialogAndRefreshWin();</script>");
		//response.sendRedirect("/formmode/menu/MenuCenter.jsp?menuflag="+menuflag+"&menutype="+menutype+"&subCompanyId="+subCompanyId);
	}else if("edit".equals(method)){
		String menuid = Util.null2String(request.getParameter("menuid"));	
		String menuname = Util.null2String(request.getParameter("menuname"));	
		String menudesc = Util.null2String(request.getParameter("menudesc"));	
		String menutype = Util.null2String(request.getParameter("menutype"));	
		String txtNodes = Util.null2String(request.getParameter("txtNodes"));	
		String sql="";
		sql="update menucenter set menuname='"+menuname+"',menudesc='"+menudesc+"',menutype='"+menutype+"' where id='"+menuid+"'";
		
		rs.executeSql(sql);

		//修改子菜单
		//out.println(txtNodes);

		rs.executeSql("delete menucustom where menutype='"+menuid+"'");
		JSONArray jsonArray=new JSONArray(txtNodes);
		ArrayList idList=new ArrayList();
		for(int i=0;i<jsonArray.length();i++){
			JSONObject oJson=jsonArray.getJSONObject(i);
			String id=oJson.optString("id");
			idList.add(id);

			String name=oJson.optString("name");
			String menuicon=oJson.optString("menuicon");
			String menuhref=oJson.optString("menuhref");
			String menutarget=oJson.optString("menutarget");
			String menuindex=oJson.optString("menuindex");
			String menuparentid=oJson.optString("menuparentid");
			String menurighttype = oJson.optString("menurighttype");
			String menurightvalue=oJson.optString("menurightvalue");
			String sharevalue =oJson.optString("sharevalue");
			String sharetype=oJson.optString("sharetype");
			if(!menutype.equals("2")){
				sharevalue = "1";
				sharetype = "5";
			}
			
			int index = menuhref.indexOf("selectedContent");
			int _index = menuhref.indexOf("|");
			int indexStart = index+"selectedContent=".length();
			
			String sqlTemp="insert into menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue) values ("+(i+1)+",'"+name+"','"+menuicon+"','"+menuhref+"','"+menutarget+"','"+(idList.indexOf(menuparentid)+1)+"','"+(i+1)+"','"+menuid+"','"+menurighttype+"','"+menurightvalue+"','"+sharetype+"','"+sharevalue+"') ";
			
			//out.println(sqlTemp+"<br>");
			if(index!=-1 && _index!=-1){
				rs.executeSql("delete menuResourceNode where contentindex = '"+menuid+(i+1)+"'");
				
				String tempStr = menuhref.substring(indexStart);
				String[] nodestr = tempStr.split("\\|");
				for(int j=0;j<nodestr.length;j++){
					sqlTemp="insert into menuResourceNode(contentindex,txtNode) values ('"+menuid+(i+1)+"','"+nodestr[j]+"') ";
					
					rs.executeSql(sqlTemp);
				}
				
				menuhref = menuhref.substring(0,indexStart)+ "key_"+ menuid+(i+1);
				sqlTemp="insert into menucustom(id,menuname,menuicon,menuhref,menutarget,menuparentid,menuindex,menutype,righttype,rightvalue,sharetype,sharevalue,selectnodes) values ("+(i+1)+",'"+name+"','"+menuicon+"','"+menuhref+"','"+menutarget+"','"+(idList.indexOf(menuparentid)+1)+"','"+(i+1)+"','"+menuid+"','"+menurighttype+"','"+menurightvalue+"','"+sharetype+"','"+sharevalue+"','"+menuid+(i+1)+"') ";
			}
			
			rs.executeSql(sqlTemp);
		}
		//MenuCenterCominfo.updateCache(menuid);
		MenuCenterCominfo.clearCominfoCache();
		//response.sendRedirect("/formmode/menu/MenuCenter.jsp?menuflag="+menuflag+"&menutype="+menutype+"&subCompanyId="+subCompanyId+"&msg=1");
		response.getWriter().println("<script type=\"text/javascript\">parent.closeDialogAndRefreshWin();</script>");
	}else if("tran".equals(method)){
		String srcSubId = Util.null2String(request.getParameter("srcSubid"));
		String targetSubId = Util.null2String(request.getParameter("targetSubid"));
		String tranMenuId = Util.null2String(request.getParameter("tranMenuId"));
		//String fromSubid = Util.null2String(request.getParameter("fromSubid"));
		
		rs.execute("update menucenter set subCompanyId="+targetSubId+" where id = '"+tranMenuId+"'");
		
		//MenuCenterCominfo.updateCache(tranMenuId);
		MenuCenterCominfo.clearCominfoCache();
		response.sendRedirect("/formmode/menu/MenuCenter.jsp?menuflag="+menuflag+"&menutype=2&subCompanyId="+srcSubId);
	}else if("checkMenuName".equals(method)){ //菜单名称重复性验证
		String menuname = Util.null2String(request.getParameter("menuname"));
		String menutype = Util.null2String(request.getParameter("menutype"));
		String sql="select id from menucenter where subcompanyid='"+subCompanyId+"' and menutype='"+menutype+"' and menuname='"+menuname+"'";
		rs.executeSql(sql);
		if(rs.next())
			out.print("true"); //菜单名称重复
		else
			out.print("false");
	}

	
%>