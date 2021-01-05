<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="weaver.favourite.FavouriteInfo"%>
<jsp:useBean id="favouriteInfo" class="weaver.favourite.FavouriteInfo" scope="page"/>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=UTF-8");
	
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;
	favouriteInfo.setUserid("" + user.getUID());
	String action = Util.null2String(request.getParameter("action"));
	if("edit".equals(action)){   //编辑，手机端暂不需要
		String favouritename =  Util.null2String(request.getParameter("favouritename"));
		String favouritedesc =  Util.null2String(request.getParameter("favouritedesc"));
		String favouriteorder =  Util.null2String(request.getParameter("favouriteorder"));
		if("".equals(favouriteorder)){
			favouriteorder = null;
		}
		String favouriteid =  Util.null2String(request.getParameter("favouriteid"));
		favouriteInfo.setFavouritename(favouritename);
		favouriteInfo.setFavouritedesc(favouritedesc);
		favouriteInfo.setFavouriteorder(favouriteorder);
		favouriteInfo.setFavouriteid(favouriteid);
		String result = favouriteInfo.editFavourite();
		JSONObject jsObject = JSONObject.fromObject(result);
		out.clear();
		out.println(jsObject);
	}else if("add".equals(action)){   //新增
		String favouritename =  Util.null2String(request.getParameter("favouritename"));
		String favouritedesc =  Util.null2String(request.getParameter("favouritedesc"));
		String favouriteorder =  Util.null2String(request.getParameter("favouriteorder"));
		favouriteInfo.setFavouritename(favouritename);
		favouriteInfo.setFavouritedesc(favouritedesc);
		favouriteInfo.setFavouriteorder(favouriteorder);
		String result = favouriteInfo.addFavourite();
		JSONObject jsObject = JSONObject.fromObject(result);
		out.clear();
		out.println(jsObject);
	}else if("delete".equals(action)){   //删除，手机端暂不需要
		String dirId = Util.null2String(request.getParameter("id"));
		favouriteInfo.setFavouriteid(dirId);
		boolean result = favouriteInfo.deleteFavourite();
		out.clear();
		out.println(result);
	}else if("query".equals(action)){
		favouriteInfo = new FavouriteInfo();
		favouriteInfo.setUserid("" + user.getUID());
		String queryResult = favouriteInfo.queryFavourites();
		JSONObject jsonObject = JSONObject.fromObject(queryResult);
		out.clear();
		out.println(jsonObject);
	}
%>