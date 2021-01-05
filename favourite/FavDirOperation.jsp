<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*" %>
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="weaver.favourite.FavouriteInfo"%>
<jsp:useBean id="favouriteInfo" class="weaver.favourite.FavouriteInfo" scope="page"/>

<%
	User user = HrmUserVarify.getUser(request, response);
	if (user == null) return;
	favouriteInfo.setUserid("" + user.getUID());
	String action = Util.null2String(request.getParameter("action"));
	if("edit".equals(action)){   //编辑
		String favouritename =  Util.null2String(request.getParameter("favouritename")).trim();
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
		if(!"".equals(result)){
			JSONObject jsObject = JSONObject.fromObject(result);
			if(jsObject.has("success")){
				out.println(jsObject);
				return;
			}
		}
	}else if("add".equals(action)){   //新增
		String favouritename =  Util.null2String(request.getParameter("favouritename")).trim();
		String favouritedesc =  Util.null2String(request.getParameter("favouritedesc"));
		String favouriteorder =  Util.null2String(request.getParameter("favouriteorder"));
		favouriteInfo.setFavouritename(favouritename);
		favouriteInfo.setFavouritedesc(favouritedesc);
		favouriteInfo.setFavouriteorder(favouriteorder);
		String result = favouriteInfo.addFavourite();
		if(!"".equals(result)){
			JSONObject jsObject = JSONObject.fromObject(result);
			if(jsObject.has("success")){
				out.println(jsObject);
				return;
			}
		}
	}else if("delete".equals(action)){   //删除
		String dirId = Util.null2String(request.getParameter("id"));
		favouriteInfo.setFavouriteid(dirId);
		favouriteInfo.deleteFavourite();
	}else if("getExcludeDir".equals(action)){
		String excludeid = Util.null2String(request.getParameter("excludeid"));   //此目录不显示
		String queryResult = favouriteInfo.queryFavourites();
		JSONObject jsonObject = JSONObject.fromObject(queryResult);
		JSONArray jsArray = jsonObject.getJSONArray("databody");
		if(!excludeid.equals("-1")){
%>
	<li id="dir-1" data-options="id:'-1'"><%=SystemEnv.getHtmlLabelName(18030,user.getLanguage())%></li>
<%
		}
		if(jsArray != null && jsArray.size() > 0){
			int size = jsArray.size();
			for(int i = 0; i < size; i++){
				JSONObject jsObject = jsArray.getJSONObject(i);
				String id = jsObject.getString("id");
				String title = jsObject.getString("title");
				if(excludeid.equals(id)){
					continue;
				}
%>
	<li id="dir<%=id%>" data-options="id:'<%=id%>'" title="<%=title%>"><%=title%></li>
<%				
			}
		}
		return;
	}
	favouriteInfo = new FavouriteInfo();
	favouriteInfo.setUserid("" + user.getUID());
	String queryResult = favouriteInfo.queryFavourites();
	JSONObject jsonObject = JSONObject.fromObject(queryResult);
	JSONArray jsArray = jsonObject.getJSONArray("databody");
	if(jsArray != null && jsArray.size() > 0){
		int size = jsArray.size();
		for(int i = 0; i < size; i++){
			JSONObject jsObject = jsArray.getJSONObject(i);
			String id = jsObject.getString("id");
			String title = jsObject.getString("title");
%>
	 <div class="diritem"  data-options="id:'<%=id%>',selected:'false'">
		  <div title="<%=title%>" class="favdir">
				<%=title%>
		  </div>
	  </div>
<%			
		}
	}
%>