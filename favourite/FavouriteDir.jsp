<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="net.sf.json.*" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="com.dc.core.util.a"%>
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
	String id = Util.null2String(request.getParameter("id"));
	String favouritename = "";
	String favouritedesc = "";
	String favouriteorder = "";
	String action = "add";
	if(!"".equals(id)){   //编辑
		action = "edit";
		favouriteInfo.setFavouriteid(id);
		favouriteInfo.setUserid("" + user.getUID());
		String queryString = favouriteInfo.getFavourite();
		if(!"".equals(queryString)){
			JSONObject jsoObject = JSONObject.fromObject(queryString);
			favouritename = Util.null2String(jsoObject.getString("name"));
			favouritedesc = Util.null2String(jsoObject.getString("desc"));
			favouriteorder = Util.null2String(jsoObject.getString("order"));
		}
	}
%>
<html>
<head>
	<title></title>
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<script type="text/javascript" src="<%=jsSrc%>"></script>
	<script type="text/javascript" src="/favourite/js2/favourite_wev8.js?t=<%=randomnum%>"></script>
	<script type="text/javascript" src="/js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/favourite/css/favourite_wev8.css?t=<%=randomnum%>" type="text/css" />
</head>
<body id="favouritebody">
	<form id="favform" name="favform" class="container">
	  <input type="hidden" name="favouriteid" id="favouriteid" value="<%=id%>"> 	
	  <input type="hidden" name="action" id="action" value="<%=action%>"> 	
	  <%--目录名称 --%>
	  <div class="favline first">
	  	<div class="favtitle">
	  		<%=SystemEnv.getHtmlLabelName(24764,user.getLanguage())%>：
	  	</div>
		<div class="favfield">
			<input type="text" name="favouritename" id="favouritename" value="<%=favouritename%>" onChange="checkinput('favouritename','favouritenamespan');checkLength('favouritename','150','<%=SystemEnv.getHtmlLabelName(22426,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>','<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>')"  _noMultiLang="true"/>
			<span name="favouritenamespan" id="favouritenamespan">
				<%if("".equals(favouritename)){%>
				<img src="/images/BacoError_wev8.gif" align="absMiddle">
				<%}%>
			</span>
		</div>
	  </div>	
	  <%--描述 --%>
	  <div class="favline">
	  	<div class="favtitle">
	  		<%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%>：
	  	</div>
		<div class="favfield">
			<input type="text" name="favouritedesc" id="favouritedesc" value="<%=favouritedesc%>" maxLength=20 size=50 _noMultiLang="true"/>
		</div>
	  </div>	
	  <%--显示顺序 --%>
	  <div class="favline">
	  	<div class="favtitle"><%=SystemEnv.getHtmlLabelName(15513,user.getLanguage())%>：</div>
		<div class="favfield">
			 <input type="text" name="favouriteorder" id="favouriteorder" value="<%=favouriteorder%>" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber1(this);" _noMultiLang="true"/>
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