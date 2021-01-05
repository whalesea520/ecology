
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,weaver.general.*"%>
<%@ page import="weaver.hrm.*,org.json.*"%>
<jsp:useBean id="sf" class="weaver.favourite.SysFavouriteInfo" scope="page" />


<%
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;
	String favouriteid = request.getParameter("favouriteid");
	if("".equals(favouriteid)||null==favouriteid)
	{
		favouriteid = "-1";
	}
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String sysfavouriteid = request.getParameter("sysfavouriteid");
	
	String searchtitle = request.getParameter("title");
	String action = request.getParameter("action");
	String pagename = request.getParameter("title");
	String type = request.getParameter("favouritetype");
	String url = request.getParameter("link");
	
	String importlevel = request.getParameter("importlevel");
	String start = request.getParameter("start");
	String limit = request.getParameter("limit");
	//System.out.println("start : "+start+"  -- limit : "+limit);
	if("".equals(start)||null==start)
	{
		start = "0";
	}
	if("".equals(limit)||null==limit)
	{
		limit = "10";
	}
	String result = "";
	int userid = user.getUID();
	//System.out.println("action : "+action);
	if ("add".equals(action))
	{
		String jsonvalues = new String(request.getParameter("jsonvalues"));
		sf.setFavouriteid(favouriteid);
		sf.setImportlevel(importlevel);
		sf.setUserid(userid);
		sf.setType(type);
		result = sf.saveFavourites(jsonvalues);
		
	}
	else if("addpage".equals(action))
	{
		sf.setFavouriteid(favouriteid);
		sf.setPagename(pagename);
		sf.setUrl(url);
		sf.setImportlevel(importlevel);
		sf.setUserid(userid);
		sf.setType(type);
		result = sf.saveFavouritesFromPage();
	}
	else if ("edit".equals(action))
	{
		sf.setSysfavouriteid(sysfavouriteid);
		sf.setPagename(pagename);
		sf.setImportlevel(importlevel);
		sf.setUserid(userid);
		//System.out.println("type : "+type);
		sf.setType(type);
		result = sf.editFavourites();
	}
	else if ("delete".equals(action))
	{
		sf.setSysfavouriteid(sysfavouriteid);
		sf.setUserid(userid);
		result = sf.deleteFavourites();
	}
	else if ("batchdelete".equals(action))
	{
		
	}
	else if ("append".equals(action))
	{
		sf.setFavouriteid(favouriteid);
		sf.setUserid(userid);
		sf.setSysfavouriteid(sysfavouriteid);
		//System.out.println("favouriteid : "+favouriteid+"  -- sysfavouriteid : "+sysfavouriteid);
		result = sf.appendFavourites();
	}
	else if ("appendanddel".equals(action))
	{
		sf.setFavouriteid(favouriteid);
		sf.setUserid(userid);
		sf.setSysfavouriteid(sysfavouriteid);
		//System.out.println("favouriteid : "+favouriteid+"  -- sysfavouriteid : "+sysfavouriteid);
		result = sf.appendFavourites();
		
		sf.setSysfavouriteid(sysfavouriteid);
		sf.setUserid(userid);
		sf.deleteFavourites();
	}
	else
	{
		//System.out.println("searchtitle : "+searchtitle);
		//System.out.println("favouriteid : "+favouriteid);
		sf.setUserid(userid);
		sf.setStart(Integer.valueOf(start).intValue());
		sf.setLimit(Integer.valueOf(limit).intValue());
		if(!"-2".equals(favouriteid))
		{
			sf.setFavouriteid(favouriteid);
			result = sf.querySysFavourites();
		}
		else if(null!=searchtitle)
		{
			//System.out.println("favouriteid : "+favouriteid);
			sf.setSearchtitle(searchtitle);
			result = sf.searchSysFavourites();
		}
		
		
	}
	if("1".equals(isDialog))
    {
    %>
    <script language=javascript>
    try
    {
		var parentWin = parent.parent.getParentWindow(parent);
		try
		{
			parentWin._table.reLoad();
		}
		catch(ex)
		{
		}
		parentWin.closeDialog();
	}
	catch(e)
	{
	}
	</script>
    <%
    }
	else
	{
		if("add".equals(action))
		{
			out.print(result);
		}
		else if("delete".equals(action))
		{
			response.sendRedirect("/favourite/FavouriteList.jsp?favouriteid="+favouriteid);
			return;
		}
		else
		{
			out.print(result);
		}
	}
%>