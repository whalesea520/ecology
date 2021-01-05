<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="sysFavourite" class="weaver.favourite.SysFavourite" scope="page"/>
<jsp:useBean id="favouriteInfo" class="weaver.favourite.FavouriteInfo" scope="page"/>
<%
	int langid = user.getLanguage();
	String jsSrc = "/favourite/js/favourite-lang-cn-gbk_wev8.js";
	if(langid == 8){
		jsSrc = "/favourite/js/favourite-lang-en-gbk_wev8.js";
	}else if(langid == 9){
		jsSrc = "/favourite/js/favourite-lang-tw-gbk_wev8.js";
	}
	long randomnum = new Date().getTime();
%>

<%
	String id = request.getParameter("id");
	sysFavourite.setUser(user);
	sysFavourite.setRequest(request);
	Map data = sysFavourite.getFavourite();
	//查询当前收藏的信息
	String pagename = Util.null2String(data.get("pagename"));
	String dirid = Util.null2String(data.get("dirid"));
	String favouritetype = Util.null2String(data.get("favouritetype"));
	int favouriteObjid = Util.getIntValue(Util.null2String(data.get("favouriteObjid")),-1);
	
	//查询目录的信息
	favouriteInfo.setUserid("" + user.getUID());
	String queryResult = favouriteInfo.queryFavourites();
	JSONObject jsonObject = JSONObject.fromObject(queryResult);
	JSONArray jsArray = jsonObject.getJSONArray("databody");
%>
<html>
<head>
	<title></title>
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<script type="text/javascript" src="<%=jsSrc%>"></script>
	<script type="text/javascript" src="/favourite/js2/sysfavourite_wev8.js?t=<%=randomnum%>"></script>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/favourite/css/sysfavourite_wev8.css?t=<%=randomnum%>" type="text/css" />
</head>
<body id="favouritebody">
	<form id="favform" name="favform" class="container">
	  <input type="hidden" name="favid" id="favid" value="<%=id%>"> 	
	  <%--收藏标题 --%>
	  <div class="favline first">
	  	<div class="favtitle">
	  		<%=SystemEnv.getHtmlLabelName(22426,user.getLanguage())%>：
	  	</div>
		<div class="favfield">
			<input type="text" name="pagename" id="pagename" value="<%=pagename%>" onChange="checkinput('pagename','pagenamespan');checkLength('pagename','150','<%=SystemEnv.getHtmlLabelName(22426,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')" _noMultiLang="true"/>
			<span id="pagenamespan" name="pagenamespan">
				<%if("".equals(pagename)){%>
				<img src="/images/BacoError_wev8.gif" align="absMiddle">
				<%}%>
			</span>
		</div>
	  </div>	
	  <%--收藏目录 --%>
	  <div class="favline">
	  	<div class="favtitle">
	  		<%=SystemEnv.getHtmlLabelName(28111,user.getLanguage())+ SystemEnv.getHtmlLabelName(33092,user.getLanguage())%>：
	  	</div>
		<div class="selectfield">
			<select id="dirid" name="dirid" onChange="checkinput('dirid','diridspan')">
				<option value="-1" <%if(dirid.equals("-1")){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(18030,user.getLanguage())%></option>  <%--我的收藏 --%>
				<%if(jsArray != null && jsArray.size() > 0){
					  int size = jsArray.size();
					  for(int i = 0; i < size; i++){
						   JSONObject jsObject = jsArray.getJSONObject(i);
						   String did = jsObject.getString("id");
						   String title = jsObject.getString("title");
				%>
				<option value="<%=did%>" <%if(dirid.equals(did)){%>selected="selected"<%}%>><%=title%></option>
				<%}}%>	   
			</select>
			<span id="diridspan" name="diridspan">
				<%if("".equals(dirid)){%>
				<img src="/images/BacoError_wev8.gif" align="absMiddle">
				<%}%>
			</span>
		</div>
	  </div>	
	  <%--类型 --%>
	  <div class="favline">
	  	<div class="favtitle"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%>：</div>
		<div class="selectfield">
			<%
				String favtypeName = "";
				if(favouriteObjid > 0 || "6".equals(favouritetype)){
					if("1".equals(favouritetype)){
						favtypeName = SystemEnv.getHtmlLabelName(58,user.getLanguage());
					}else if("2".equals(favouritetype)){
						favtypeName = SystemEnv.getHtmlLabelName(18015,user.getLanguage());
					}else if("3".equals(favouritetype)){
						favtypeName = SystemEnv.getHtmlLabelName(101,user.getLanguage());
					}else if("4".equals(favouritetype)){
						favtypeName = SystemEnv.getHtmlLabelName(136,user.getLanguage());
					}else if("6".equals(favouritetype)){
						favtypeName = SystemEnv.getHtmlLabelName(24532,user.getLanguage());
					}else if("7".equals(favouritetype)){
						favtypeName = SystemEnv.getHtmlLabelName(74,user.getLanguage());
					}else if("5".equals(favouritetype)){
						favtypeName = SystemEnv.getHtmlLabelName(375,user.getLanguage());
					}
				}
			%>
			<%if(favouriteObjid > 0 || "6".equals(favouritetype)){%>
				<%=favtypeName%>
				<input type="hidden" name="favouritetype" id="favouritetype" value="<%=favouritetype%>">
			<%}else{%>
			<select id="favouritetype" name="favouritetype" onChange="checkinput('favouritetype','favouritetypespan')">
				<option value=""></option>
			    <option value="1" <%if("1".equals(favouritetype)){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>  <%--文档 --%>
			    <option value="2" <%if("2".equals(favouritetype)){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></option>   <%--流程 --%>
			    <option value="3" <%if("3".equals(favouritetype)){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>   <%--项目 --%>
			    <option value="4" <%if("4".equals(favouritetype)){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>  <%--客户 --%>
			    <%-- <option value="6" <%if("6".equals(favouritetype)){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(24532,user.getLanguage())%></option>--%>   <%--消息 --%>
			    <%-- <option value="7" <%if("7".equals(favouritetype)){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></option>--%>  <%--图片 --%>
			    <%-- 以前老的数据，favouritetype=0表示其他 --%>
			    <option value="5" <%if("5".equals(favouritetype) || "0".equals(favouritetype)){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%></option>  <%--其他 --%>
			</select>
			<span id="favouritetypespan" name="favouritetypespan">
				<%if("".equals(favouritetype)){%>
				<img src="/images/BacoError_wev8.gif" align="absMiddle">
				<%}%>
			</span>
			<%}%>
		</div>
	  </div>	
	</form>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class="zd_btn_submit" id="btnsubmit" value="<%=SystemEnv.getHtmlLabelName(826 ,user.getLanguage()) %>" />
					<input type="button" class=zd_btn_cancle id="btncancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</body>
</html>