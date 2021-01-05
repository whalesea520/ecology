<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" isELIgnored="true"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="com.inet.pool.i"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%
User user = HrmUserVarify.getUser (request , response) ;
%>
<!DOCTYPE HTML>
<html>
<head>
	<title>E-cology 知识树</title>
	<link rel="stylesheet" href="/formmode/js/jquery/zTree3.5.15/css/zTreeStyle/zTreeStyle_wev8.css" type="text/css">
	<link rel="stylesheet" href="css/index_wev8.css" type="text/css">
	<style>
		html, body{overflow:hidden;}
	</style>
	<script type="text/javascript" src="/formmode/js/jquery/jquery-1.8.3.min_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/zTree3.5.15/js/jquery.ztree.all-3.5.min_wev8.js"></script>
	<script type="text/javascript" src="/formmode/js/jquery/nicescroll/jquery.nicescroll.min_wev8.js?<%=System.currentTimeMillis()%>"></script>
	<script type="text/javascript" src="js/index_wev8.js"></script>
	<script type="text/javascript" src="js/function_tree_wev8.js"></script>
</head>
<body>
	<div id="cover">
		<div class="divCoverTitle">欢迎使用泛微e-cology产品知识树</div>
		<div class="divCoverMemo">
			您可以在这里了解各个版本的功能、设计和修改；<br/>
			你可以在这里了解各个功能模块的目前开发情况和接下来开发的功能计划；<br/>
			你可以在这里对各个功能模块进行建议和意见；
		</div>
		<div class="divCommentBox">
			<div id="divComment">
				<ul>
					<%
						RecordSet.executeSql("select top(10) * from uf_ktree_discussion order by createdate desc,createtime desc");
						while(RecordSet.next()){
							String hrmImg = "/images/messageimages/temp/man_wev8.gif";
							String creator = Util.null2String(RecordSet.getString("creator"));
							rs.executeSql("select resourceimageid,sex from HrmResource where id="+creator);
							String imagefileid = Util.null2String(rs.getString("resourceimageid"));
							String sex = Util.null2String(rs.getString("sex"));
							if("1".equals(sex)) hrmImg = "/images/messageimages/temp/women_wev8.gif";
					%>
						<li>
							<%if(!StringHelper.isEmpty(imagefileid) && !"0".equals(imagefileid)){%>
								<img class="imgAvator" src="/weaver/weaver.file.FileDownload?fileid=<%=imagefileid%>" />
							<%}else{%>
								<img class="imgAvator" src="<%=hrmImg%>" />
							<%}%>
							<span class="spanUsername"><%=Util.null2String(ResourceComInfo.getResourcename(creator))%></span>
							<span class="spanDate"><%=RecordSet.getString("createdate").replace("-","/")%>&nbsp;<%=RecordSet.getString("createtime")%></span>
							<br/>
							<%=Util.null2String(RecordSet.getString("content"))%>
						</li>
					<%}%>
				</ul>
			</div>
			<div class="divCount">
				<%
					int countFunctionDesc = 0;
					rs.executeSql("select COUNT(*) from uf_ktree_functionModifyLog where updatedatetime>(select MAX(visitdatetime) from uf_ktree_visitlog where userId="+user.getUID()+")");
					if(rs.next()){
						countFunctionDesc = rs.getInt(1);
					}
				%>
				<%if(countFunctionDesc>0){%>
					从上次您进入到现在有<span class="spanCount"><%=countFunctionDesc%></span>功能的描述进行了修正您未读；<br/>
				<%}%>
				从上次您进入到现在有<span class="spanCount">122</span>功能功能建议您未读；<br/>
				从上次您进入到现在有<span class="spanCount">122</span>你的建议被回复了；<br/>
				从上次您进入到现在有<span class="spanCount">122</span>功能建议被列为了标准功能开发计划；
			</div>
		</div>
		<button type="button" id="btnEnter">进入知识树 ></button>

		<div class="divSlogan">
			凝聚分散智慧、协同提升发展<br/>
			www.weaver.com.cn
		</div>
	</div>
	<table class="mainTable">
		<tr class="header">
			<td colspan="2" valign="center"></td>
		</tr>
		<tr class="center">
			<td class="center_left" valign="top">
				<div class="center_left_container">
					<div class="center_left_top">
						<ul class="version">
							<%
								String sql = "select * from uf_ktree_version order by versionNo";
								RecordSet.executeSql(sql);
								while(RecordSet.next()){
									String versionNo = Util.null2String(RecordSet.getString("versionNo"));
									String id = Util.null2String(RecordSet.getString("id"));
							 %>
							<li id="versionid_<%=id%>" onClick="changeVersion(<%=id%>)"><%=versionNo %></li>
							<%} %>
							<li class="beta">beta</li>
							
							<input type="hidden" currentversionid name="versionid" id="versionid" value=2><!-- 当前系统版本id -->
							<input type="hidden" currentfucntionid name="functionid" id="functionid" value=2><!-- 当前功能点id -->
							<input type="hidden" currenttabid name="tabid" id="tabid" value=2><!-- 当前标签id -->
						</ul>
						<div class="shownewBtn" onclick="searchNew();"></div>
						<div class="searchContainer">
							<input type="text" class="searchText" name="functionName" id="functionName"/>
							<div class="searchText_tip">Search...</div>
							<div class="searchBtn" onClick="search();"></div>
						</div>
					</div>
					<div class="ztreeContainer">
						<ul class="the_tree ztree" id="the_tree"></ul>
					</div>
				</div>
			</td>
			<td class="center_right"  valign="top">
				<div class="center_right_container">
					<div class="tabsContainer">
						<div class="tabs">
							<ul>
								<%
									int idx = 0;
									String firstid = "";
									StringBuffer str = new StringBuffer();
									StringBuffer subStr = new StringBuffer();
									RecordSet.executeSql("select * from uf_ktree_tabinfo where pid=''");
									while(RecordSet.next()){
										idx++;
										String tabid = Util.null2String(RecordSet.getString("id"));
										if(idx==1){ 
											firstid = tabid;
											str.append("<li href=\"#subtabs-"+idx+"\" _tabId="+tabid+" defaultSelected=\"true\">");
										}else{
											str.append("<li href=\"#subtabs-"+idx+"\" _tabId="+tabid+">");
										}
										str.append("<a>"+Util.null2String(RecordSet.getString("tabname"))+"</a>");
										str.append("</li>");
										
										int jdx = 0;
										rs.executeSql("select * from uf_ktree_tabinfo where pid="+tabid+" ");
										if(rs.getCounts()>0){
											subStr.append("<div id=\"subtabs-"+idx+"\" class=\"subtabs\"><ul>");
											while(rs.next()){
												jdx++;
												String subtabid = Util.null2String(rs.getString("id"));
												String tabType = Util.null2String(rs.getString("tabtype"));
												String searchid = Util.null2String(rs.getString("searchid"));
												if(jdx==1){
													subStr.append("<li tabType=\""+tabType+"\" searchid=\""+searchid+"\" onclick=\"changeFrameUrl('"+subtabid+"');\" _tabId="+subtabid+" defaultSelected=\"true\">");
												}else{
													subStr.append("<li tabType=\""+tabType+"\" searchid=\""+searchid+"\" onclick=\"changeFrameUrl('"+subtabid+"');\" _tabId="+subtabid+">");
												}
												subStr.append("<a>"+Util.null2String(rs.getString("tabname"))+"</a>");
												subStr.append("</li>");
											}
											subStr.append("</ul></div>");
										}
									}
								%>
									<% out.print(str.toString()); %>
							</ul>
					 	</div>
						<% out.print(subStr.toString()); %>
					</div>
					<div class="frameContainer">
						<iframe id="tabFrame" name="tabFrame" frameborder="0" style="width: 100%;" scrolling="no" src="" onload="whenFrameLoaded();">
								
						</iframe>
					</div>
				</div>
			</td>
		</tr>
	</table>
	
	<div id="rightCornerMenu">
		<img src="images/bookmark_wev8.png" /><img src="images/top_wev8.png" onclick="scrollPageToTop();"/>
	</div>
	
	<script type="text/javascript">
		function scrollPageToTop(){
			$(".center_right_container").scrollTop(0);
		}
		
		function resetContainer(){
			var h = $(window).height() - $("tr.header").height();
			$(".center_left_container").height(h);
			$(".center_left_top").width($(".center_left_container").width());
				
			$(".tabsContainer").width($(".center_right_container").width());
			$(".center_right_container").height(h);
		}
			
		function resetFrameWithChildPageChange(){
			var tabFrame = document.getElementById("tabFrame");
			try{	// 捕获可能存在的js跨域访问出现的异常
				var frameDoc = tabFrame.contentWindow.document;
				tabFrame.style.height = (frameDoc.body.scrollHeight + 25) + "px";
			}catch(e){}
			if(containerIsHasScroll()){
				$(".tabsContainer").width($(".center_right_container").width() - 20);
			}else{
				$(".tabsContainer").width($(".center_right_container").width());
			}
		}
		
		function whenFrameLoaded(){
			resetFrame();
		}
		
		function resetFrame(){
			var tabFrame = document.getElementById("tabFrame");
			try{	// 捕获可能存在的js跨域访问出现的异常
				tabFrame.style.height = "auto";
				var frameDoc = tabFrame.contentWindow.document;
				tabFrame.style.height = (frameDoc.body.scrollHeight + 25) + "px";
			}catch(e){}
			
			if(containerIsHasScroll()){
				$(".tabsContainer").width($(".center_right_container").width() - 20);
			}else{
				$(".tabsContainer").width($(".center_right_container").width());
			}
		}
		
		function containerIsHasScroll(){
			var obj = $(".center_right_container")[0];
			if(obj.scrollHeight>obj.clientHeight||obj.offsetHeight>obj.clientHeight){ 
				return true;
			}
			return false;
		}
		
		function changeFrameUrl(tabid){
			$("#tabid").val(tabid);
			var ktree_ptabid = $(".tabsContainer > .tabs > ul").find("li[class='selected']").attr("_tabId");
			var ktree_tab = "{\"versionid\":\""+$("#versionid").val()+"\",\"functionid\":\""+$("#functionid").val()+"\",\"ktree_ptabid\":\""+ktree_ptabid+"\",\"ktree_stabid\":\""+tabid+"\"}";
			FormmodeUtil.writeCookie("ktree_tab", ktree_tab);
			var liobj = $(".tabsContainer > .subtabs > ul").find("li[_tabId="+tabid+"]");
			var tabType = $(liobj).attr("tabType");
			var searchid = $(liobj).attr("searchid");
			var tabFrame = document.getElementById("tabFrame");
			var url = "";
			if(tabType==1){
				url = "/formmode/apps/ktree/viewdocument.jsp?newDate="+(new Date()).getTime()+"&versionid="
				+$("#versionid").val()+"&functionid="+$("#functionid").val()+"&tabid="+$("#tabid").val();
			}else{
				url = "/formmode/apps/ktree/viewcustomsearch.jsp?searchid="+searchid
				+"&newDate="+(new Date()).getTime()+"&versionid="
				+$("#versionid").val()+"&functionid="+$("#functionid").val()+"&tabid="+$("#tabid").val();
			}
			tabFrame.src = url;
		}
	</script>
</body>
</html>
