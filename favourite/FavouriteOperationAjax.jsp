
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="favouriteInfo" class="weaver.favourite.FavouriteInfo"
	scope="page" />

<%
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;
	String action = Util.null2String(request.getParameter("action"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	//System.out.println("action : "+action);
	String favouriteid = Util.null2String(request.getParameter("favouriteid"));
	String favouritename = Util.null2String(request.getParameter("favouritename"));
	String favouritedesc = Util.null2String(request.getParameter("favouritedesc"));
	String favouriteorder = Util.null2String(request.getParameter("favouriteorder"));
	if("".equals(favouriteorder)){
		favouriteorder = "0";
	}
	favouriteInfo.setUserid("" + user.getUID());
	favouriteInfo.setFavouriteid(favouriteid);
	favouriteInfo.setFavouritename(favouritename);
	favouriteInfo.setFavouritedesc(favouritedesc);
	favouriteInfo.setFavouriteorder(favouriteorder);
	StringBuffer resultStr = new StringBuffer();
	boolean result = false;
	if ("delete".equals(action))
	{
		result = favouriteInfo.deleteFavourite();
		//resultStr.append(result);
	}
	else if("add".equals(action))
	{
		session.removeAttribute("fav_pagename");
		session.removeAttribute("fav_uri");
		session.removeAttribute("fav_pagename");
		resultStr.append(favouriteInfo.addFavourite());
	}
	else if("edit".equals(action))
	{
		resultStr.append(favouriteInfo.editFavourite());
	}
	else if("editname".equals(action))
	{
		resultStr.append(favouriteInfo.editFavouriteName());
	}
	else
	{
		String queryResult = favouriteInfo.queryFavourites();
		resultStr.append(queryResult);
	}
	if(result){
		String queryResult = favouriteInfo.queryFavourites();
		resultStr.append(queryResult);
	}
	if("1".equals(isDialog))
    {
    %>
    <script language=javascript >
    try
    {
		//var parentWin = parent.getParentWindow(window);
		var parentWin = parent.parent.getParentWindow(parent);
		//parentWin.location.href="/favourite/ManageFavourite.jsp";
		parentWin.reloadTree();
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
		//System.out.println("resultStr : "+resultStr.toString());
		out.print(resultStr.toString());
	}
%>