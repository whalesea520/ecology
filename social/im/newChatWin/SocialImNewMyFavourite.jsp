<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
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
	String favtype = Util.null2String(request.getParameter("favtype"));
	String isshowrepeat = "0";
	if("6".equals(favtype)){
		isshowrepeat = "1";
	}
%>
<html>
<head>
	<title></title>
	<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/highslide/highslide-full_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/simplehrm_wev8.js"></script>
	<script type="text/javascript" src="/js/messagejs/messagejs_wev8.js"></script>
	<script type="text/javascript" src="/qrcode/js/jquery.qrcode-0.7.0_wev8.js"></script>
	<script type="text/javascript" src="<%=jsSrc%>"></script>
	<script type="text/javascript" src="/social/im/newChatWin/js/NewWinMyfavourite_wev8.js?t=<%=randomnum%>"></script>
	<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
	<link type="text/css" href="/favourite/css/myfavourite_wev8.css?t=<%=randomnum%>" rel="Stylesheet">
	<!-- 样式表 -->
	<link rel="stylesheet" href="/social/css/base_public_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/social/css/base_wev8.css" type="text/css" />
	<link rel="stylesheet" href="/social/css/im_wev8.css" type="text/css" />
	<script type="text/javascript">
		var operatingMsg = "<%=SystemEnv.getHtmlLabelName(20240,user.getLanguage())%>";
		var loaddingMsg = "<%=SystemEnv.getHtmlLabelName(82275,user.getLanguage())%>";
		var multiDeleteMsg = "<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>";
	</script>
</head>
<body id="favouritebody">
<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>

<input type="hidden" name="isshowrepeat" id="isshowrepeat" value="<%=isshowrepeat%>">
<%--编辑重要程度的菜单 --%>
<div id="levelPanel" name="levelPanel">
	<div class="levelitem <%if(langid == 8){%>levelitem_enus<%}%>"  data-options="level:3,text:'<%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>'">
		<div class="icon"><img src="/favourite/images2/important_level_wev8.png"></div>
		<div class="text"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></div>
	</div>
	<div class="levelitem <%if(langid == 8){%>levelitem_enus<%}%>" data-options="level:2,text:'<%=SystemEnv.getHtmlLabelName(25436,user.getLanguage())%>'">
		<div class="icon"><img src="/favourite/images2/middle_level_wev8.png"></div>
		<div class="text"><%=SystemEnv.getHtmlLabelName(25436,user.getLanguage())%></div>
	</div>
	<div class="levelitem <%if(langid == 8){%>levelitem_enus<%}%>" data-options="level:1,text:'<%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>'">
		<div class="icon"><img src="/favourite/images2/normal_level_wev8.png"></div>
		<div class="text"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></div>
	</div>
</div>

<%--移动时，要显示的所有目录 --%>

<div id="movePanel">
	<div class="top"></div>
	<div class="moveto">
		<li><%=SystemEnv.getHtmlLabelName(81298,user.getLanguage())%>:</li>
	</div>
	<%--<div id="moveScrollContainer" style="overflow:hidden;height:250px;width:100px;">--%>
		<div class="main">
		<jsp:include page="/favourite/FavDirOperation.jsp">
			<jsp:param value="getExcludeDir" name="action"/>
		</jsp:include>
		</div>
	<%--</div>--%>
	<div class="bottom"></div>
</div>

 
<div id="container">
	<%--左侧目录 --%>
	<div id="scrollcontainer" style="overflow:hidden;height:565px;width:147px; position: absolute;background-color: #ededed;z-index: 1">
	<div id="leftdir">
	  <input type="hidden" name="dirId" id="dirId">	
	  <%--根目录 --%>
	  <div class="diritem" data-options="id:'-1000',selected:'false'">
		  <div id="rootdir">
				<span style="font-size: 16px;">◢</span>
				<span><%=SystemEnv.getHtmlLabelName(332,user.getLanguage()) + SystemEnv.getHtmlLabelName(92,user.getLanguage())%></span>
		  </div>
	  </div>
	  <%--默认的目录 --%>
	  <div class="diritem" data-options="id:'-1',selected:'false'">
		  <div class="favdir" title="<%=SystemEnv.getHtmlLabelName(18030,user.getLanguage())%>">
				<%=SystemEnv.getHtmlLabelName(18030,user.getLanguage())%>
		  </div>
	  </div>
	  <%--查询目录 --%>
	  <div id="custdirs">
	  <jsp:include page="/favourite/FavDirOperation.jsp">
	  </jsp:include>
	  </div>
	  <%--新建目录 --%>
	  <div class="diritem">
	  	  <div id="newdir" class="favdir" <%if(langid == 8){%>style="left: 20px !important; width: 120px !important;"<%}%>>
				<span class="icon">
					<img src="/favourite/images2/newdir_wev8.png">
				</span>
				<%
					String newdirTxt = SystemEnv.getHtmlLabelName(82,user.getLanguage()) + SystemEnv.getHtmlLabelName(92,user.getLanguage());
				%>
				<span class="text" title="<%=newdirTxt%>"><%=newdirTxt%></span>
		  </div>
	  </div>
	</div>
	</div>
	<%--右上方的搜索区域 --%>
	<div id="searchbar">
		<%--操作的按钮 --%>
		 	<%--添加 --%>
		<div id="addbtn" <%if("6".equals(favtype)){%>style="display: none;"<%}%>>
		  <div>
		   <ul class="abtn">
		   	  <li>
			     <img src="/favourite/images2/addfav_wev8.png">
			     <span class="text"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></span>
			  </li>   
		   </ul>
		   <ul id="addItems" class="<%if(langid == 8){%>enui<%}%>">
			   <li class="addItem" title="<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%>">
					<span class="text"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></span>   <%--文档 --%>
			   </li>
			   <li class="addItem" title="<%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%>">
					<span class="text"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></span>   <%--流程 --%>
			   </li>
			   <li class="addItem" title="<%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%>">
					<span class="text"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></span>    <%--客户 --%>
			   </li>
			   <li class="addItem" title="<%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%>">
					<span class="text"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></span>    <%--项目 --%>
			   </li>
		   </ul>
		   <div class="bottom" style="height: 15px;display: none;"></div>
		   </div>
		</div> 
		<%--收藏的类型--%>
		<div class="favtype" <%if("6".equals(favtype)){%>style="display: none;"<%}%>>
		   <select id="favtype" name="favtype" >
		      <option value=""><%=SystemEnv.getHtmlLabelName(21979,user.getLanguage())%></option>
		      <option value="1"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>  <%--文档 --%>
		      <option value="2"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></option>   <%--流程 --%>
		      <option value="3"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>   <%--项目 --%>
		      <option value="4"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>  <%--客户 --%>
		      <option value="6" <%if("6".equals(favtype)){%>selected="selected"<%}%>><%=SystemEnv.getHtmlLabelName(24532,user.getLanguage())%></option>   <%--消息 --%>
		      <%-- <option value="7"><%=SystemEnv.getHtmlLabelName(74,user.getLanguage())%></option>--%>  <%--图片 --%>
		      <option value="5"><%=SystemEnv.getHtmlLabelName(375,user.getLanguage())%></option>  <%--其他 --%>
		   </select>
		</div>
		<%--标题搜索 --%>
		<div class="searchinput <%if("6".equals(favtype)){%>searchinput2<%}%>"  >
			<div>
				<input type="text" name="pagename" id="pagename" _noMultiLang="true"/>
			</div>
			<div class="icon">
				<img src="/favourite/images2/search_wev8.png">
			</div>
		</div>
		<%--操作的按钮 --%>
		<div class="opbtns">
			<div id="movebtn"><%=SystemEnv.getHtmlLabelName(78,user.getLanguage())%></div>  <%--移动 --%>
			<div id="deletebtn"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></div>  <%--删除 --%>
		</div>
	</div>
	<%--右下方的收藏夹内容区域 --%>
	<div style="overflow:hidden;height:515px;left: 147px;position: absolute;z-index: 1" id="contentDiv">
	<div id="content" style="height: 100%;">
	  <div id="favContents">
		<jsp:include page="/favourite/FavouriteQuery.jsp">
			<jsp:param value="<%=favtype%>" name="favtype"/>
			<jsp:param value="<%=isshowrepeat%>" name="isshowrepeat"/>
			<jsp:param value="-1" name="dirId"/>  <%--默认加载我的收藏目录 --%>
		</jsp:include>
	  </div>	
	  <div id="loadingDiv" class="loadingmsg" data-options="loadingmsg:'<%=SystemEnv.getHtmlLabelName(82275,user.getLanguage())%>',nodata:'<%=SystemEnv.getHtmlLabelName(83781,user.getLanguage())%>',nomoredata:'<%=SystemEnv.getHtmlLabelName(126120,user.getLanguage())%>'"></div>
	</div>
	</div>
</div>

<%--全屏的加载中的遮罩 --%>
<div id="loaddingCover">
<div class="loaddingContainer">
<div class="loadingmsg">
<div class="icon"></div>
<div class="text">
	<%=SystemEnv.getHtmlLabelName(82275,user.getLanguage())%>
</div>
</div>

</div>
</div>
<iframe id="msgCover" frameborder="0" style="width: 100%;height: 100%;position: absolute;left: 147px;top: 50px;z-index: 10;display: none;"></iframe>
</body>
</html>