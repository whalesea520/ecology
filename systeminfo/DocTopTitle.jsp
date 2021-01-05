<%@ page import="weaver.general.Util,weaver.general.BaseBean"%>
<%@ page import="java.net.*"%>
<%
	isIncludeToptitle = 1;
	String gopage = "";
	String hostname = request.getServerName();
	String uri = request.getRequestURI();
	String querystring = "";
	titlename = Util.null2String(titlename);
	String ajaxs = "";
	for (Enumeration En = request.getParameterNames(); En.hasMoreElements();)
	{
		String tmpname = (String) En.nextElement();

		if (tmpname.equals("ajax"))
		{
			ajaxs = tmpname;
			continue;
		}
		String tmpvalue = Util.toScreen(request.getParameter(tmpname), user.getLanguage(), "0");
		querystring += "^" + tmpname + "=" + tmpvalue;
	}
	if (!querystring.equals(""))
		querystring = querystring.substring(1);

    querystring=Util.StringReplace(querystring,"\"", "&quot;");
	
	session.setAttribute("fav_pagename", titlename);
	session.setAttribute("fav_uri", uri);
	session.setAttribute("fav_querystring", querystring);
	int addFavSuccess = Util.getIntValue(session.getAttribute("fav_addfavsuccess") + "");
	session.setAttribute("fav_addfavsuccess", "");
%>
<SPAN id=BacoTitle style="display:none;"><%=titlename%></SPAN>
<!-- bpf start 2013-10-23  -->	
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript">
	function setFavPageName()
	{
		var BacoTitle = document.getElementById("objName");
		var pagename = "";
		if(BacoTitle)
		{
			pagename = BacoTitle.innerText;
		}
		var favpagename = pagename;
		favpagename = jQuery.trim(favpagename);
		return favpagename;
	}
	function setFavUri()
	{
		var favuri = "<%=uri %>";
		try
		{
			var e8tabcontainer = jQuery("div[_e8tabcontainer='true']",parent.document);
			if(e8tabcontainer.length > 0) 
			{
				favuri = escape(parent.window.location.pathname);
			}
			//alert(fav_uri+"  "+fav_querystring)
		}
		catch(e)
		{
			
		}
		favuri = escape(favuri); 
		return favuri;
	}
	function setFavQueryString()
	{
		var favquerystring = "<%=querystring %>";
		try
		{
			var e8tabcontainer = jQuery("div[_e8tabcontainer='true']",parent.document);
			if(e8tabcontainer.length > 0) 
			{
				favquerystring = escape(parent.window.location.search);
			}
			//alert(fav_uri+"  "+fav_querystring)
		}
		catch(e)
		{
			
		}
		favquerystring = escape(favquerystring); 
		return favquerystring;
	}
</script>
