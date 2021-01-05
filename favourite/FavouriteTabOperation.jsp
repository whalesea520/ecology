
<%@ page language="java" contentType="application/x-json;charset=utf-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.util.*"%>

<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.systeminfo.*"%>
<%@ page
	import="weaver.general.StaticObj,weaver.general.Util"%>
<%@ page import="weaver.hrm.settings.RemindSettings"%>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<jsp:useBean id="favouriteTabInfo" class="weaver.favourite.FavouriteTabInfo"
	scope="page" />

<%
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;
	String action = request.getParameter("action");
	String tabid = request.getParameter("tabid");
	String tabname = request.getParameter("tabname");
	String tabdesc = request.getParameter("tabdesc");
	String displayorder = request.getParameter("displayorder");
	String favouriteid = request.getParameter("favouriteid");
	String sysfavouriteid = request.getParameter("sysfavouriteid");
	String favourite_tabid = request.getParameter("favourite_tabid");
	String type = request.getParameter("type");
	String jsonvalues = request.getParameter("jsonvalues");
	String importlevel = request.getParameter("importlevel");
	String favouriteAlias = request.getParameter("favouriteAlias");
	String favouritePageSize = request.getParameter("favouritepagesize");
	String favouriteTitleSize = request.getParameter("favouritetitlesize");
	String showFavouriteTitle = request.getParameter("showfavouritetitle");
	String showFavouriteLevel = request.getParameter("showfavouritelevel");
	favouriteTabInfo.setUserid(""+user.getUID());
	favouriteTabInfo.setUserlanguage(user.getLanguage());
	//System.out.println("action : "+action);
	StringBuffer resultStr = new StringBuffer();
	boolean result = false;
	if ("delete".equals(action))
	{
		favouriteTabInfo.setTabid(tabid);	
		resultStr.append(favouriteTabInfo.deleteFavouriteTab());
	}
	else if("edit".equals(action))
	{
		favouriteTabInfo.setTabid(tabid);	
		favouriteTabInfo.setTabname(tabname);
		favouriteTabInfo.setTabdesc(tabdesc);
		favouriteTabInfo.setTaborder(displayorder);
		resultStr.append(favouriteTabInfo.editFavouriteTab());
	}
	else if("add".equals(action))
	{		
		favouriteTabInfo.setTabname(tabname);
		favouriteTabInfo.setTabdesc(tabdesc);
		favouriteTabInfo.setTaborder(displayorder);
		resultStr.append(favouriteTabInfo.addFavouriteTab());
	}
	else if("deletefe".equals(action))
	{
		favouriteTabInfo.setFavourite_tabid(Integer.valueOf(favourite_tabid).intValue());	
		resultStr.append(favouriteTabInfo.deleteFavouriteTabElement());
	}
	else if("addsysfa".equals(action))
	{
		favouriteTabInfo.setFavourite_tabid(Integer.valueOf(favourite_tabid).intValue());
		favouriteTabInfo.setFavouriteid(Integer.valueOf(favouriteid).intValue());
		favouriteTabInfo.setImportlevel(importlevel);
		favouriteTabInfo.setType(type);
		resultStr.append(favouriteTabInfo.addSysFavouriteFromTabs(jsonvalues));
	}
	else if("addfe".equals(action))
	{
		favouriteTabInfo.setTabid(tabid);
		favouriteTabInfo.setFavouriteid(Integer.valueOf(favouriteid).intValue());
		String results = favouriteTabInfo.addFavouriteTabElement();
		resultStr.append(results);
	}
	else if("editfe".equals(action))
	{		
		favouriteTabInfo.setFavouriteid(Integer.valueOf(favouriteid).intValue());
		favouriteTabInfo.setFavourite_tabid(Integer.valueOf(favourite_tabid).intValue());
		favouriteTabInfo.setFavouriteAlias(favouriteAlias);
		favouriteTabInfo.setFavouritePageSize(Integer.valueOf(favouritePageSize).intValue());
		favouriteTabInfo.setShowFavouriteTitle(Integer.valueOf(showFavouriteTitle).intValue());
		favouriteTabInfo.setFavouriteTitleSize(Integer.valueOf(favouriteTitleSize).intValue());
		favouriteTabInfo.setShowFavouriteLevel(Integer.valueOf(showFavouriteLevel).intValue());
		resultStr.append(favouriteTabInfo.setFavouriteTabElement());
	}
	else if("deletesysfa".equals(action))
	{
		//System.out.println("favourite_tabid : "+favourite_tabid);
		favouriteTabInfo.setFavourite_tabid(Integer.valueOf(favourite_tabid).intValue());
		favouriteTabInfo.setFavouriteid(Integer.valueOf(favouriteid).intValue());
		favouriteTabInfo.setSysfavouriteid(Integer.valueOf(sysfavouriteid).intValue());
		resultStr.append(favouriteTabInfo.deleteSysFaAndReloadElement());
	}
	else if("saveposition".equals(action))
	{
		//System.out.println("jsonvalues : "+jsonvalues);
		resultStr.append(favouriteTabInfo.saveFavouriteTabPosition(jsonvalues));
		
	}
	else
	{
		resultStr.append(favouriteTabInfo.queryFavouriteTabs());
	}
	//System.out.println("resultStr : "+resultStr.toString());
	out.print(resultStr.toString());
%>

