
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.blog.BlogManager"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.blog.BlogDao"%><html>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(26469,user.getLanguage())%></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">var languageid=<%=user.getLanguage()%>;</script>
<script type="text/javascript" src="/weaverEditor/kindeditor_wev8.js"></script>
<script type='text/javascript' src='js/highlight/jquery.highlight_wev8.js'></script>
<link rel=stylesheet href="/css/Weaver_wev8.css" type="text/css" />
<link href="js/weaverImgZoom/weaverImgZoom_wev8.css" rel="stylesheet" type="text/css">
<script src="js/weaverImgZoom/weaverImgZoom_wev8.js"></script>

<script type="text/javascript" src="js/raty/js/jquery.raty_wev8.js"></script>

<!-- 微博便签 -->
<script type="text/javascript" src="/blog/js/notepad/notepad_wev8.js"></script>

<link rel="stylesheet"  href="css/blog_wev8.css">
<jsp:include page="blogUitl.jsp"></jsp:include>
<style>
  .reportItem .reportContent p{margin:0px}
</style>
<%
	String userid=""+user.getUID();
    String blogType = Util.null2String(request.getParameter("blogType"));
    String name = Util.null2String(request.getParameter("name"));
    String startDate=Util.null2String(request.getParameter("startDate"));
    String endDate=Util.null2String(request.getParameter("endDate"));
    BlogManager blogManager=new BlogManager(user);
    SimpleDateFormat datefrm=new SimpleDateFormat("yyyy-MM-dd");
    SimpleDateFormat frmYYR=new SimpleDateFormat("M月dd日");  
    SimpleDateFormat dayFormater=new SimpleDateFormat("dd");
    SimpleDateFormat yearMonthFormater=new SimpleDateFormat("yyyy-MM");
    
    String from = Util.null2String(request.getParameter("from"));

    BlogDao blogDao=new BlogDao();
    
    if("".equals(startDate)){
    	Date startDateTem=new Date();
        startDateTem.setDate(startDateTem.getDate()-30);
    	startDate=datefrm.format(startDateTem);
    }
    if("".equals(endDate)||datefrm.parse(endDate).getTime()>new Date().getTime())
    	endDate=datefrm.format(new Date());
    String enableDate=blogDao.getSysSetting("enableDate");
    if(datefrm.parse(enableDate).getTime()>datefrm.parse(startDate).getTime()){
    	startDate=enableDate;
    }
    List list = blogManager.getAttentionDiscussCount(""+user.getUID(),startDate,endDate);
    
    Iterator itr=list.iterator();
    Date today=new Date();
    //周日 周一 周二 周三 周四 周五 周六 
    String []week={SystemEnv.getHtmlLabelName(16106,user.getLanguage()),SystemEnv.getHtmlLabelName(16100,user.getLanguage()),SystemEnv.getHtmlLabelName(16101,user.getLanguage()),SystemEnv.getHtmlLabelName(16102,user.getLanguage()),SystemEnv.getHtmlLabelName(16103,user.getLanguage()),SystemEnv.getHtmlLabelName(16104,user.getLanguage()),SystemEnv.getHtmlLabelName(16105,user.getLanguage())}; 
	
%>
</head>
<body style="<%=from.equals("myblog")?"overflow:hidden;":""%>width: 100%;background:#fff">

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div id="warn">
	<div class="title"></div>
</div>

<div id="blogLoading" class="loading" align='center'>
	<div id="loadingdiv">
		<div id="loadingMsg">
			<div><%=SystemEnv.getHtmlLabelName(81558,user.getLanguage())%></div>
		</div>
	</div>
</div>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
		<td></td>
	</tr>
</table>

<iframe id="downloadFrame" style="display: none"></iframe>
<div id="myBlogdiv" style="height: 100%;width:100%;">

	<div id="reportBody">
		<%
		 if(list.size()>0){
		  for(int i=list.size()-1;i>=0; i--){
			HashMap titleInfoMap=(HashMap)list.get(i);
			int unsubmit=((Integer)titleInfoMap.get("unsubmit")).intValue();
			int submited=((Integer)titleInfoMap.get("submited")).intValue();
		%>
		<div class="attentionStateBody">
			<div class="attentionStateTitle" style="cursor: pointer;"
				onclick="hideDetail('#details_<%=titleInfoMap.get("workdate") %>',this,'<%=titleInfoMap.get("workdate") %>');">
				<div class="sortInfo" >
					<span class="date" style="width:75px;display: inline;color: black;font-weight: normal">
					<img src="/wui/theme/ecology8/templates/default/images/groupHead_wev8.png" align="top">
					<%=frmYYR.format(datefrm.parse((String)titleInfoMap.get("workdate")))%>
					</span>
					<span class="date" style="color: #adadad"><%=week[datefrm.parse((String)titleInfoMap.get("workdate")).getDay()] %> 
					</span>&nbsp;&nbsp; 
					<%if(unsubmit>0){%>
						
					 <span> 
					 <img src="/blog/images/icon_point_wev8.png" align="bottom">
					 <font color="#ee5d38"><%=titleInfoMap.get("unsubmit") %><%=SystemEnv.getHtmlLabelName(127,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%></font>
					 </span>
					<%} %>
				</div><!-- 已提交 未提交 -->
				<div class="coBar coBarClose"><div style="margin-left: 28px"></div></div><!-- 收缩 -->
				<div style="float:right;" class="remindAll" onclick="unSumitRemindAll(this,<%=user.getUID()%>,'<%=titleInfoMap.get("workdate") %>')"></div>
			</div>
			<div id="details_<%=titleInfoMap.get("workdate") %>" forDate="<%=titleInfoMap.get("workdate") %>"  class="details"> </div>
		</div>
		<%}}else
			out.println("<div class='norecord'>"+SystemEnv.getHtmlLabelName(22521,user.getLanguage())+"</div>");
		%>
	</div>
</div>
</body>
</html>
<script>
	jQuery(function(){
		jQuery(".attentionStateBody:first .attentionStateTitle").click();
	});
	
	function hideDetail(tm,th,workDate){
		var t=false;
		var openDetail=undefined;
		jQuery(".attentionStateBody .details").each(function(obj){
			if(jQuery(this).is(":visible")){
				openDetail=jQuery(this).hide();
				t=workDate==jQuery(this).attr("forDate");
				jQuery(this).parent().find(".coBar").removeClass("coBarOpen").addClass("coBarClose");//展开
				changeIframeHeight();
				return;
			}
		});
		if(t)return;
		if(jQuery(tm).is(":visible")){
			jQuery(tm).hide();
			jQuery(th).find(".coBar").removeClass("coBarOpen").addClass("coBarClose"); //展开
			changeIframeHeight();
		}else{
			jQuery(tm).show();
			jQuery(th).find(".coBar").removeClass("coBarClose").addClass("coBarOpen"); //收缩
			if(jQuery.trim(jQuery(tm).html())==""){
			    displayLoading(1,"data");
			    //attentionList.jsp
				jQuery(tm).load("discussList.jsp?requestType=attentionList",{'workDate':workDate},function(){
				
				    //初始化处理图片
			       jQuery(tm).find('.reportContent img').each(function(){
						initImg(this);
				   });
					
				   //上级评分初始化
				   jQuery(tm).find(".blog_raty").each(function(){
					   managerScore(this);
				   });
				   
					changeIframeHeight();
					
					displayLoading(0);
				});
			}
		}
	}
   
   //添加到收藏夹
    function openFavouriteBrowser(){
	   var url=window.location.href;
	   fav_uri="/blog/blogView.jsp?item=attention&";
	   fav_uri = escape(fav_uri); 
	   var fav_pagename=jQuery("title").html();
	   fav_pagename = encodeURI(fav_pagename); 
	   window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/favourite/FavouriteBrowser.jsp&fav_pagename="+fav_pagename+"&fav_uri="+fav_uri+"&fav_querystring=&mouldID=doc");
    }	
	//显示帮助
    function showHelp(){
        var pathKey = this.location.pathname;
	    if(pathKey!=""){
	        pathKey = pathKey.substr(1);
	    }
       var operationPage = "http://help.e-cology.com.cn/help/RemoteHelp.jsp";
       var screenWidth = window.screen.width*1;
       var screenHeight = window.screen.height*1;
       var isEnableExtranetHelp = <%=isEnExtranetHelp%>;
	   if(isEnableExtranetHelp==1){
	    	//operationPage = "/formmode/apps/ktree/ktreeHelp.jsp";
	    	operationPage = '<%=KtreeHelp.getInstance().extranetUrl%>';
	   }
       window.open(operationPage+"?pathKey="+pathKey,"_blank","top=0,left="+(screenWidth-800)/2+",height="+(screenHeight-90)+",width=900,status=no,scrollbars=yes,toolbar=yes,menubar=no,location=no");
    }
    
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>

