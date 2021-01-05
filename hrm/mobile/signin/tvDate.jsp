<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- Added by wcd 2015-04-02 [移动签到-时间视图] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="signIn" class="weaver.hrm.mobile.signin.SignInManager" scope="page" />
<jsp:useBean id="resourceInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%!
	public Map getMap(String id, String title, String param){
		Map map = new HashMap();
		map.put("id", id);
		map.put("title", title);
		map.put("target","_self"); 
		map.put("href", "javascript:goTo('"+id+"', '"+param+"')");
		return map;
	}
%>
 <%
	String imagefilename = "/images/hdHRM_wev8.gif", needfav ="1", needhelp ="";
	String titlename = SystemEnv.getHtmlLabelNames("31726,32559",user.getLanguage());
	String uid = strUtil.vString(request.getParameter("uid"), String.valueOf(user.getUID()));
	String oid = strUtil.vString(request.getParameter("oid"), uid);
	String uName = resourceInfo.getLastname(oid);
	String tid = strUtil.vString(request.getParameter("tid"));
	String tDate = strUtil.vString(request.getParameter("tDate"));
	Calendar cal = dateUtil.getCalendar();
	int curMonth = strUtil.parseToInt(dateUtil.getMonth(cal), 1);
	String tvToday = dateUtil.getCalendarDate(cal);
	String tvYesterday = dateUtil.getYesterday();
	String tvThisYear = dateUtil.getYear(cal);
	String tvLastYear = dateUtil.getYear(dateUtil.addYear(cal, -1));
	String tvBeforeLastYear = dateUtil.getYear(dateUtil.addYear(cal, -1));
	
	List mapList = new ArrayList();
	mapList.add(getMap("tv_today", SystemEnv.getHtmlLabelName(15537,user.getLanguage()), tvToday));
	mapList.add(getMap("tv_yesterday", SystemEnv.getHtmlLabelName(82640,user.getLanguage()), tvYesterday));
	int thisMaxMonth = curMonth, lastMaxMonth = 12, beforeLastMaxMonth = 12;
	for(int i=curMonth; i>0; i--) mapList.add(getMap("tv_thisMonth_"+i, i+SystemEnv.getHtmlLabelName(6076,user.getLanguage()), String.valueOf(i)));
	mapList.add(getMap("tv_thisYear", tvThisYear+SystemEnv.getHtmlLabelName(445,user.getLanguage()), tvThisYear));
	for(int i=12; i>0; i--) mapList.add(getMap("tv_lastMonth_"+i, i+SystemEnv.getHtmlLabelName(6076,user.getLanguage()), String.valueOf(i)));
	mapList.add(getMap("tv_lastYear", tvLastYear+SystemEnv.getHtmlLabelName(445,user.getLanguage()), tvLastYear));
	for(int i=12; i>0; i--) mapList.add(getMap("tv_beforeLastMonth_"+i, i+SystemEnv.getHtmlLabelName(6076,user.getLanguage()), String.valueOf(i)));
	mapList.add(getMap("tv_beforeLastYear", tvBeforeLastYear+SystemEnv.getHtmlLabelName(445,user.getLanguage()), tvBeforeLastYear));
	mapList.add(getMap("tv_cDate", SystemEnv.getHtmlLabelNames("17908,97",user.getLanguage()), ""));
%>
<html>
	<head>
		<link href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css" />
		<link rel="stylesheet" href="/wui/common/jquery/plugin/zTree/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<style type="text/css">
		
		</style>
		<script type="text/javascript">
			var common = new MFCommon();
			var curMonth = "<%=thisMaxMonth%>";
			var lastMaxMonth = "<%=lastMaxMonth%>";
			var beforeLastMaxMonth = "<%=beforeLastMaxMonth%>";
			var curId = "<%=user.getUID()%>";
			var curName = "<%=user.getUsername()%>";
			
			function goTo(id, param){
				parent.setHeight($("ul.ztree").height());
				if(id === "tv_thisYear"){
					hideEle("tv_lastMonth_");
					hideEle("tv_beforeLastMonth_");
					showEle("tv_thisMonth_");
					showContent("tv_thisMonth_"+curMonth, curMonth);
				} else if(id === "tv_lastYear"){
					hideEle("tv_thisMonth_");
					hideEle("tv_beforeLastMonth_");
					showEle("tv_lastMonth_");
					showContent("tv_lastMonth_"+lastMaxMonth, lastMaxMonth);
				} else if(id === "tv_beforeLastYear"){
					showEle("tv_beforeLastMonth_");
					hideEle("tv_thisMonth_");
					hideEle("tv_lastMonth_");
					showContent("tv_beforeLastMonth_"+beforeLastMaxMonth, beforeLastMaxMonth);
				} else if(id === "tv_cDate"){
					parent.openDate(id);
				} else {
					showContent(id, param);
				}
			}
			
			function hideEle(id){
				var len = document.weaver.elements.length;
				var obj;
				for(var i=1; i<=12; i++){
					obj = document.all(id+i);
					if(obj) obj.style.display = "none";
				}
			}
			
			function showEle(id){
				var obj;
				for(var i=1; i<=12; i++){
					obj = document.all(id+i);
					if(obj) obj.style.display = "block";
				}
			}
			
			function showContent(cmd, date){
				parent.showContent(cmd, date);
			}
			
			function doChange(id){
				var lSpans = jQuery("#ztreeObjTime").children(".li");
				lSpans.each(function(i, obj){
					obj = jQuery(obj).find("span.liSpan");
					if(obj.hasClass("n_title")){
						obj.removeClass("n_title");
					}
				});
				var obj;
				if(id === "tv_thisYear"){
					obj = jQuery("#tv_thisMonth_"+curMonth+"_span");
				} else if(id === "tv_lastYear"){
					obj = jQuery("#tv_lastMonth_"+lastMaxMonth+"_span");
				} else if(id === "tv_beforeLastYear"){
					obj = jQuery("#tv_beforeLastMonth_"+beforeLastMaxMonth+"_span");
				} else {
					obj = jQuery("#"+id+"_span");
				}
				obj.addClass("n_title");
			}
		</script>
	</head>
	<body style="overflow:none;">
		<form name="weaver" method="post">
			<input type="hidden" id="uid" name="uid" value="<%=uid%>">
			<input type="hidden" id="oid" name="oid" value="<%=oid%>">
			<input type="hidden" id="tid" name="tid" value="<%=tid%>">
			<input type="hidden" id="tDate" name="tDate" value="<%=tDate%>">
			<input type="hidden" id="slg" name="slg" value="i">
			<div style="height: 100%; width:100%;">
				<div style="overflow: hidden; height: 100%; position: relative; outline: none;">
					<ul id="ztreeObjTime" class="ztree" style="margin-top:10px">
						<%
							Map map = null;
							String id = "", title = "", href = "";
							for(int i=0; i<mapList.size(); i++){
								map = (Map)mapList.get(i);
								id = strUtil.vString(map.get("id"));
								title = strUtil.vString(map.get("title"));
								href = strUtil.vString(map.get("href"));
						%>
						<li id="<%=id%>" class="li level0 e8_z_toplevel" style="display:<%=id.startsWith("tv_lastMonth_") || id.startsWith("tv_beforeLastMonth_") ? "none" : "block"%>">
							<div class="e8HoverZtreeDiv" style="padding-left:0px;float:right;padding-right:20px;">
								<a id="<%=id%>_a" class="level0" onclick="<%=href%>;doChange('<%=id%>')" target="_self" title="<%=title%>">
									<span id="<%=id%>_span" class="liSpan"><%=title%></span>
								</a>
							</div>
						</li>
						<%	}%>
					</ul>
				</div>
			</div>
		</form>
	</body>
</html>