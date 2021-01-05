
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="favouriteActiveInfo" class="weaver.favourite.FavouriteActiveInfo"
	scope="page" />

<%
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;
	String action = Util.null2String(request.getParameter("action"));
	//System.out.println("FavouriteActive action : "+action);
	String activeid = Util.null2String(request.getParameter("activeid"));
	String activetitle = Util.null2String(request.getParameter("activetitle"));
	String activetype = Util.null2String(request.getParameter("activetype"));
	favouriteActiveInfo.setUserid("" + user.getUID());
	
	StringBuffer resultStr = new StringBuffer();
	String result = "";
	if ("save".equals(action))
	{
		favouriteActiveInfo.setActiveid(activeid);
		favouriteActiveInfo.setActivetitle(activetitle);
		favouriteActiveInfo.setActivetype(activetype);
		favouriteActiveInfo.saveLastActive();
		resultStr.append(result);
	}
	else
	{
		result = favouriteActiveInfo.queryLastActive();
		//System.out.println("result : "+result);
		resultStr.append(result);
	}
	//System.out.println("resultStr : "+resultStr.toString());
	out.print(resultStr.toString());
%>