<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="sysFavourite" class="weaver.favourite.SysFavourite" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
		User user = HrmUserVarify.getUser(request, response);
		if (user == null) return;
		String action = Util.null2String(request.getParameter("action"));
		if("editLevel".equals(action)){   //编辑重要程度
			sysFavourite.setUser(user);
			sysFavourite.setRequest(request);
			Map result = sysFavourite.editFavouriteLevel();
			JSONObject jsonObject = JSONObject.fromObject(result);
			out.print(jsonObject.toString());
		}else if("delete".equals(action)){  //删除
			sysFavourite.setUser(user);
			sysFavourite.setRequest(request);
			Map result = sysFavourite.deleteFavourite();
			JSONObject jsonObject = JSONObject.fromObject(result);
			out.print(jsonObject.toString());
		}else if("add".equals(action)){
			sysFavourite.setUser(user);
			sysFavourite.setRequest(request);
			Map result = sysFavourite.addFavourites();
			JSONObject jsonObject = JSONObject.fromObject(result);
			out.print(jsonObject.toString());
		}else if("move".equals(action)){
			sysFavourite.setUser(user);
			sysFavourite.setRequest(request);
			Map result = sysFavourite.moveFavourites();
			JSONObject jsonObject = JSONObject.fromObject(result);
			out.print(jsonObject.toString());
		}else if("edit".equals(action)){
			sysFavourite.setUser(user);
			sysFavourite.setRequest(request);
			Map result = sysFavourite.editFavourite();
			JSONObject jsonObject = JSONObject.fromObject(result);
			out.print(jsonObject.toString());
		}
%>