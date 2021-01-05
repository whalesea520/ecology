
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="java.util.*" %>
<%@page import="java.net.*"%>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.mobile.plugin.ecology.service.FullSearchConditionBean" %>
<%@ page import="weaver.mobile.plugin.ecology.service.FullSearchService" %> 
<%@ page import="weaver.systeminfo.SystemEnv" %>
<%@page import="weaver.fullsearch.MobileSchemaUtil"%>
<%@page import="weaver.fullsearch.MobileSchemaBean"%> 
<jsp:useBean id="hotkey" class="weaver.fullsearch.bean.HotKeysBean"/>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;

int userLanguage = user.getLanguage();
userLanguage = (userLanguage == 0) ? 7:userLanguage;

FileUpload fu = new FileUpload(request);
String module = Util.null2String((String)fu.getParameter("module"));
String scope = Util.null2String((String)fu.getParameter("scope"));

String titleurl = Util.null2String((String)request.getParameter("title"));
String title = URLDecoder.decode(titleurl,"UTF-8");

String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));

String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
String viewmodule = Util.null2String(fu.getParameter("viewmodule"));
//外部传入快速搜索key
String sKey = Util.null2String(fu.getParameter("sKey"));
String sType = Util.null2String(fu.getParameter("sType"));
boolean hideHead="1".equals(Util.null2String(fu.getParameter("hideHead")));
if(!"".equals(sKey)){
	sKey=URLDecoder.decode(sKey,"UTF-8");
}
Map<String,String> iconMap=new HashMap<String,String>();
iconMap.put("ALL","all_wev8.png");
iconMap.put("WF","wf_wev8.png");
iconMap.put("DOC","doc_wev8.png");
iconMap.put("WKP","wkp_wev8.png");
iconMap.put("RSC","rsc_wev8.png");
iconMap.put("EMAIL","email_wev8.png");
iconMap.put("COW","cow_wev8.png");
iconMap.put("CRM","crm_wev8.png");
iconMap.put("OTHER","other_wev8.png");

//对标准模块权限放开 start
Map<String,MobileSchemaBean > urlMap=MobileSchemaUtil.getInstance().getSchemaUrlMap();
Map<String,MobileSchemaBean > cusMap=MobileSchemaUtil.getInstance().getSchemaCusMap();

Map<String,MobileSchemaBean> pageMap = new HashMap<String,MobileSchemaBean>();
pageMap.putAll(urlMap); //深拷贝

String authModule=viewmodule;//"1,2,4,6,13,14,15";
String authModules[]=authModule.split(",");
for(int i=0;i<authModules.length;i++){
	if(Util.getIntValue(authModules[i],-1)>=-1) continue; 
	//判断有没有自定义(建模),可以替换标准模块的跳转
	if(cusMap.containsKey(authModules[i])){
		MobileSchemaBean msb=cusMap.get(authModules[i]);
		pageMap.put(msb.getSechma(),msb);
	}
}
//对标准模块权限放开 end


String contentType="ALL";
String keyword = "";
if(!"".equals(sKey)){
	keyword=sKey;
}
if(!"".equals(sType)){
	contentType=sType;
}
String pageindex="0";//指backIndex
int pagesize=10;
FullSearchService fs=new FullSearchService();
List schemas=fs.getAllSchemas(sessionkey);
schemas.add(0,"ALL:"+SystemEnv.getHtmlLabelName(332, userLanguage));
schemas.add(1,"DOC:"+SystemEnv.getHtmlLabelName(58, userLanguage));
//设置每页显示条数
fs.setPageSize(pagesize);
 
String back=Util.null2o(fu.getParameter("fromES"));
if("true".equals(back)){
	FullSearchConditionBean fsc=fs.gutSessionCondition(sessionkey);
	//如果是从其他页面返回过来,从session中获取数据
	if(fsc!=null){
		title=fsc.getTitle();
		pageindex=fsc.getPageindex();
		keyword=fsc.getKeyword();
		contentType=fsc.getContentType();
		hideHead=fsc.isHideHead();
	}
}

String promptStr=SystemEnv.getHtmlLabelName(32933,user.getLanguage());
List hotlist= hotkey.setHotKeysRk(-1, 12);
%>
<!DOCTYPE html>

<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no" />
	<title><%=title%></title>
	<script type='text/javascript' src='/js/jquery/jquery_wev8.js'></script>
	<script type="text/javascript" src="/mobile/plugin/fullsearch/js/script_wev8.js"></script>
	<script type="text/javascript" src="/mobilemode/js/fastclick/fastclick.min_wev8.js"></script>
	<style type="text/css">
	html,body {
		height:100%;
		margin:0;
		padding:0;
		font-size:9pt;
		
		
	}
	a {
		text-decoration: none;
	}
	table {
		border-collapse: none;
		border-spacing: 0px;
	}
	#page {
		width:100%;
		height:100%;
		margin:0;
		padding:0;
	}
	
	#header {
		width: 100%;
		filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF',
			endColorstr='#ececec' );
		background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF),
			to(#ECECEC) );
		background: -moz-linear-gradient(top, white, #ECECEC);
		border-bottom: #CCC solid 1px;
		/*
			filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;
			*/
	}
	
	#header #title {
		color: #333333;
		font-size: 20px;
		font-weight: bold;
		text-align: center;
	}
	
	#loading {
		width: 250px;
		height: 65px;
		line-height: 65px;
		position: absolute;
		background: url("/images/loading_bg_wev8.png");
		top: 50%;
		left: 50%;
		display: block;
		text-align: center;
		margin-top: -32px;
		margin-left: -125px;
		z-index: 1002;
	}
	
	#loadingmask {
		width: 100%;
		height: 100%;
		z-index: 1001;
		display:block;
		position:absolute;
		top:0px;
		left:0px;
		background:url("/images/bg_w_65_wev8.png");
	}
	
	/* 搜索区域 */
	.search {
		padding: 5px;
		height: 40px;
		text-align: center;
		position: relative;
		background: #017BFD;
		
	}
	
	/* 搜索区域 */
	.search1 {
		margin-left:5px;
		margin-right:10px;
		height: 40px;
		text-align: center;
		position: absolute;
		background: #3496FC;
		-moz-border-radius: 5px 5px 5px 5px;
		-webkit-border-radius: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		
	}  

	/* 搜索类型选择 */
	.searchType{
		width:70px;
		padding: 2px;
		margin-left: auto;
		margin-right: auto;
		background: #3496FC;
		cursor: pointer;
	}
	.searchType a{
		color: #D6EBFF !important;
	}
	
	/* 搜索图标 */
	.searchImg {
		width: 25px;
		padding: 2px;
		margin-left: auto;
		margin-right: auto;
	}
	
	/* 搜索text */
	.searchText {
		width: 100%;
		margin-left: auto;
		margin-right: auto;
		overflow:hidden;
		 
	}
	
	.prompt {
		color: #D6EBFF;
	}
	
	/* 列表区域 */
	.list {
		width: 100%;
		background: url(/images/bg_w_75_wev8.png);
	}
	/* 列表项*/
	.listitem {
		width: 100%;
		height: 80px;
		background: url(/images/bg_w_25_wev8.png);
		border-bottom: 1px solid #c8c7cc;
	}
	/* 列表项后置导航 */
	.itemnavpoint {
		height: 100%;
		width: 26px;
		text-align: center;
	}
	/* 列表项后置导航图  */
	.itemnavpoint img {
		width: 10px;
		heigth: 14px;
	}
	/* 流程创建人头像区域  */
	.itempreview {
		height: 100%;
		width: 50px;
		text-align: center;
	}
	/* 流程创建人头像  */
	.itempreview img {
		width: 40px;
		height: 40px;
		margin-top: 4px;
	}
	
	/* 列表项内容区域 */
	.itemcontent {
		width: *;
		height: 100%;
		font-size: 14px;
	}

	/* 列表项内容名称 */
	.itemcontenttitle {
		width: 100%;
		height: 23px;
		overflow-y: hidden;
		line-height: 23px;
		font-weight: bold;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
		font-size: 14px;
		color: #333333;
		
	}
	/* 列表项标题 */
	.ictwz {
		width: *;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}

	/* 列表项内容详情 */
	.itemcontents {
		width: 100%;
		height: 20px;
		overflow-y: hidden;
		line-height: 20px;
		font-size: 12px;
		color: #666666;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}
	/* 关键字高亮 */
	.itemcontents b {
		color:#CC0000;
	}

	/* 列表项内容简介 */
	.itemcontentitdt {
		width: 100%;
		height: 20px;
		overflow-y: hidden;
		line-height: 20px;
		font-size: 12px;
		color: #666666;
		word-break: keep-all;
		text-overflow: ellipsis;
		white-space: nowrap;
		overflow: hidden;
	}

	/* 更多 */
	.listitemmore {
		height: 50px;
		text-align: center;
		line-height: 50px;
		font-weight: bold;
		color: #666666;
		background-color:#F1F1F1;
	}
	
	.listitemmore label{
		color: #0AD9E2;
	}
	 
	/* 间隔 */
	.blankLines {
		width: 100%;
		height: 1px;
		overflow: hidden;
	}
	
	/* new */
	.ictnew {
		width: 20px;
	}
	
	.searchResult {
		width: 100%;
		background: url(/images/bg_w_75_wev8.png);
		color:#848484;
		text-align: center;
		margin-top: 15px;
	}

	</style>
	<style type="text/css"> 
	
	#btnNavParent {
		background-color: rgba(0,0,0,0.1) !important;
		filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='#01000000',endcolorstr = '#01000000');
		
	}
	
	#btnNav {
		font-size: 16px; 
		margin:0;
		padding:0;
		border:0; 	
		background-color: rgba(0,0,0,0) !important;
		filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='#00000000',endcolorstr = '#00000000');
		
	}
	
	#btnNav div a{ display: block;font-weight:bold;}

	.typeDiv{
		border:0;
		line-height: 40px;
		border-bottom: 1px solid #37536B; 
		color: #D6EBFF;
		padding-bottom: 5px;
	}

	.navTabDiv{
		-moz-border-radius: 5px 5px 5px 5px;
		-webkit-border-radius: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		-webkit-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		-moz-box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		box-shadow: inset 0px 1px 0px 0px #BCBFC3;
		max-height: 300px;
	}
	 

	.noselect{
		color: #D6EBFF !important;
	}

	.noselect:hover{
		color:#007CFF;
	}

	.select{
		color:#007CFF;
	}

	.none{
		display:none;
	}

	/*点击进行选择查询类型*/
	#showBtn { margin:0;padding:0;border:0;width:50px;height:26px;text-align:center;line-height:26px;color:#000; }
	#showBtn a {font-size: 16px;color:#333333; display: block;font-weight:bold;white-space: nowrap;
overflow: hidden;
text-overflow: ellipsis;
-o-text-overflow: ellipsis;  } 
	
	.typeTable{
		background: rgba(0, 29, 60, 0.8)!important;
		filter: progid:DXImageTransform.Microsoft.gradient(GradientType=0,startColorstr='#08001d3c',endcolorstr = '#08001d3c');
		color: #D6EBFF !important;
		-moz-border-radius: 5px 5px 5px 5px;
		-webkit-border-radius: 5px 5px 5px 5px;
		border-radius: 5px 5px 5px 5px;
		
		max-height: 330px;
		margin-top: 11px;
	}
	
	.typeTable label{
		cursor: pointer
	}
	/*向上箭头*/
	div.arrow-up { 
		width: 0; 
		height: 0; 
		border-left: 12px solid transparent; /* 左边框的宽 */ 
		border-right: 12px solid transparent; /* 右边框的宽 */ 
		border-bottom: 12px solid #324962; /* 下边框的长度|高,以及背景色 */ 
		font-size: 0; 
		line-height: 0;
		position: absolute;
		top: 0px;
		left: 35px;
	}
	/*热点样式*/
	.hottd div{
		border: 1px solid #848484;
		color:#848484;
		height: 35px;
		line-height:35px;
		text-align :center;
		width: 70px;
		-moz-border-radius: 10px 10px 10px 10px;
		-webkit-border-radius: 10px 10px 10px 10px;
		border-radius: 10px 10px 10px 10px;
		margin-bottom: 15px;
	} 
	
	.hottd a{
	 	display: block; 
	 	white-space: nowrap;
		overflow: hidden;
		text-overflow: ellipsis;
		-o-text-overflow: ellipsis;
	}	
	
	.emptytd{
	 width:10px;
	}
	
	.nosearchResult{
		text-align: center;
		margin-top: 60px;
		margin-bottom: 15px;
		display: none;
	}
	</style> 
</head>
<body style="overflow: hidden">
<div onclick="hideNavType()" style="height:100%;overflow: hidden">
	<table id="page"><tr><td width="100%" height="100%" valign="top" align="left" style="padding: 0px">
		<div class="topHeader" style="position: fixed;top: 0px;background-color:#017BFD;width:100%;z-index:95;overflow: hidden">
		<div id="header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
			<table style="width: 100%; height: 40px;">
				<tr>
					<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>
						</div>
					</a>
					</td>
					<td align="center" valign="middle">
						<div id="title"><%=title%></div>
					</td>
					<td width="10%" align="right" valign="middle" style="padding-right:5px;">
						
					</td>
				</tr>
			</table>
		</div>

		<div class="search" style='<%=hideHead?"display:none":"" %>'>
			<div class="search1">
				<table style="width:100%;height: 40px;">
					<tr>
						<td>&nbsp;</td>
						<td id="searchType" class="searchType" onClick="openChangeType()">
							<div style="width: 80px;">
								<div id="showBtn" style="float:left">
									<a id="typeshow" href="javascript:void(0)" ></a>
								</div>
								<div style="float:left">
									<img id="downshow" src="/mobile/plugin/fullsearch/img/down_wev8.png">
								</div>
							</div>
						</td>
						<td class="searchText"><input type="text" id="keyword" name="keyword" class="prompt" style="font-size: 16px;background-color: #3496FC;border: none;width: 100%;height: 30px;" value="<%=!"".equals(keyword)?keyword:promptStr%>"></td>
						<td class="searchImg" onclick="searchClick()"><img src="/mobile/plugin/fullsearch/img/search_wev8.png"></td>
						<td>&nbsp;</td>
					</tr>
				</table>
			</div>
		</div>
		</div>
		 	<div id="btnNavParent" style="width:100%; height:80%; z-index:199;display:none;position:absolute;">
				<div id="btnNav" style="width:180px;display:none;position:absolute;z-index:100;margin-left: 10px;overflow:hidden">
					  <div class="typeTable" style="overflow:auto">
							<table style="width:100%;cellspacing:0;cellpadding:0;table-layout:fixed;" >
									<tr><td style="height:5px;border:0;"></td></tr>
									<%
									for(Object obj:schemas){
										if(obj != null && ((String)obj).indexOf(":") > 0){
											String str = (String)obj;
											String key = str.substring(0, str.indexOf(":"));
											String content = str.substring(str.indexOf(":")+1);
											
											if(true||key=="ALL"){
												String icon=iconMap.containsKey(key)?iconMap.get(key):iconMap.get("OTHER");
									%>
												<tr><td class="typeTd" align="left" onclick="changeType(this)" tvalue="<%=key%>" tname="<%=content%>">
												<div class="typeDiv">
												<a class="noselect" id="typeA_<%=key%>" href="javascript:void(0)">
													<div style="float:left;margin-top: 7px;width: 30px;margin-right: 15px;margin-left: 15px;"><img src="/mobile/plugin/fullsearch/img/<%=icon %>"></div>
													<label><%=content%></label>
													<div id="typeImg_<%=key%>"  class="typeImgDiv none"> <img border ="0" style="margin-top: 10px;" src="/mobile/plugin/fullsearch/img/check_wev8.png"> </div>
												</a></div></td>
												</tr>
									<%		}
										}
									}
									%>								
									<tr><td style="height:5px;border:0"></td></tr>
							</table>
						</div>
						<div class="arrow-up"></div>					
				</div>
			</div>
		
		<div id="resultDiv" style='z-index:1;overflow-y:auto;-webkit-overflow-scrolling: touch;overflow-x:hidden;<%=hideHead?"margin-top: 51px;":"" %>'>	
			<div id="hotPoint" style='position:relative;z-index:19;margin: 0px 15px 0px 15px;'>
				<table width="100%">
					<COL width="25%">
		    		<COL width="25%">
		    		<COL width="25%">
		    		<COL width="25%">
					<tr><td colspan="4">
						<div style="height: 60px;margin-top: 10px;">
							<div style="height: 40px;border-bottom: 1px solid #f0f0f0;line-height: 40px;">
								<div style="float: left;color: #4d4d4d;font-size: 24px;font-weight: bold;"><%=SystemEnv.getHtmlLabelName(81783,user.getLanguage()) %></div>
								<div style="margin-left: 15px;float: left;font-size: 16px;color: #888888;"><%=SystemEnv.getHtmlLabelName(83445,user.getLanguage()) %></div>
							</div>
						</div>
					</td></tr>
					
					
					
					<%
					
					if(hotlist != null && hotlist.size() > 0){
						int col=4;
						for(int i=0;i<hotlist.size();i++){
							String str=hotlist.get(i).toString();
							if(i==0){
								out.println("<tr>");
							}
							
							out.println("<td class=\"hottd\" title=\""+str+"\" ><div><a onclick=\"javascript:checkHot(this)\">"+str+"</a></div></td>");
							
							if((i+1)%col==0){
								out.println("</tr>");
								if((i+1)<hotlist.size()){
									out.println("<tr>");
								}
							}
						} 
						
						int hotsize=hotlist.size();
						int levesize=(col-hotsize%col);
						if(levesize<col){
							for(int i=0;i<levesize;i++){
								out.print("<td ></td>");
								if((i+1)==levesize){
									out.print("</tr>");
								}
							}
						}
					}else{%>
						<tr><td colspan="4">
						<div style="height: 40px;">
								<div style="margin-left: 80px;float: left;font-size: 16px;color: #888888;"><%=SystemEnv.getHtmlLabelName(81790,user.getLanguage()) %></div>
							</div>
						</td></tr>
					<%}
					%>
					 
				</table>
			</div> 
		 	
			<div class="list" id="list" style="position:relative;z-index:19;">
			</div>
			<div class="listitem listitemmore" id="listItemMore"></div>
			<div class="nosearchResult" id="nosearchResult"><img id="downshow" src="/mobile/plugin/fullsearch/img/noresult_wev8.png"></div>
			<div class="searchResult" id="searchResult"></div>
		 </div>
	</td></tr></table>
</div>
</body> 
</html>

	<input type="hidden" id="sessionkey" name="sessionkey" value="">
	<input type="hidden" id="module" name="module" value="<%=module %>">
	<input type="hidden" id="scope" name="scope" value="<%=scope %>">
	<input type="hidden" id="pageindex" name="pageindex" value="1">
	<input type="hidden" id="pagesize" name="pagesize" value="">
	<input type="hidden" id="ishavepre" name="ishavepre" value="">
	<input type="hidden" id="count" name="count" value="">
	<input type="hidden" id="pagecount" name="pagecount" value="">
	<input type="hidden" id="ishavenext" name="ishavenext" value="">
	<input type="hidden" id="contentType" name="contentType" value="<%=contentType%>">
	 
	<script type="text/javascript">
	

	var defval="<%=promptStr%>";
	var backIndex=<%=pageindex%>;
	var openTypeDiv=false;//默认关闭
	$(document).ready(function() {
		var topHeaderH=$('.topHeader').height();
		var bodyH=$('body').height();
		$('#resultDiv').css("margin-top",topHeaderH);
		$('#resultDiv').height(bodyH-topHeaderH);
		
		$('#btnNavParent').css("top",topHeaderH);
		$('#btnNavParent').height(bodyH-topHeaderH-5);
		
		
		$('#keyword').focus(function(){ 
			var thisval = $(this).val();
			if(thisval==defval){ 
				$(this).val(""); 
			} 
		});
		$('#keyword').blur(function(){
			var thisval = $(this).val(); 
			if(thisval==""){ 
				$(this).val(defval); 
			} 
		});

	
		$("#listItemMore").css("display","none");
		$.ajaxSetup({ cache: false });
		 
		loadList(1);
		
		$('#keyword').keypress(function(e) {
	        if(e.which == 13) {
	            jQuery(this).blur();
	            loadList(1);
	        }
	    });
	    
	    var sliding = startClientY = startPixelOffset = pixelOffset = 0;
	    
		$('.labwin').bind('mousedown touchstart', function slideStart(event) {
			if (event.originalEvent.touches)
			event = event.originalEvent.touches[0];
			if (sliding == 0) {
				sliding = 1;
				startClientY = event.clientY;
			}
		});

		$('.labwin').bind('mousemove mousedown touchmove', function slide(event) {
			event.preventDefault();
			if (event.originalEvent.touches)
				event = event.originalEvent.touches[0];
			var deltaSlide = event.clientY - startClientY;
			if (sliding == 1 && deltaSlide != 0) {
				sliding = 2;
				startPixelOffset = pixelOffset;
			}
			if (sliding == 2) {
				pixelOffset = startPixelOffset + deltaSlide;
				if(pixelOffset < 0 && pixelOffset > $(".labwin").height() - $("#slide").height()) {
					$("#slide").css('top',pixelOffset +'px');
				}
			}
		});
		
		$('.labwin').bind('mouseup mousestop touchend', function slideEnd(event) {
			if (sliding == 2) {
				sliding = 0;
				pixelOffset = $("#slide").offset().top-$(".labwin").offset().top;
			}
		});

		//给页面查询类型赋值
		var contentType=$('#contentType').val();
		var objs = $("td.typeTd"); 
		for (var i=0; i<objs.length; i++) {
			if($(objs[i]).attr("tvalue")==contentType){ 
				$('#typeshow').html($(objs[i]).attr("tname"));
				break;
			}
		} 
		selectType();

	});
	
	function searchClick() {
		//点击条件查找, 返回index置0.重新计算
		backIndex=0;
		loadList(1);
	}
	
	function loadList(type) {
		
		var title="<%=title%>";
		var pagesize="<%=pagesize%>";
		var sessionkey = $("#sessionkey").val();
		var module = $("#module").val();
		var scope = $("#scope").val();
		var pageindex = $("#pageindex").val();
		var keyword = $("#keyword").val();
		var pagecount = $("#pagecount").val();
		var contentType = $("#contentType").val();
		if(keyword==defval){
			$("#searchResult").html("");
			$("#listItemMore").css("display","none");
			$("#list").html("");
			$('#nosearchResult').hide();
			if("<%=hideHead%>"!="true"){
				$("#hotPoint").show();
			}else{
				$("#hotPoint").hide();
			}
			return;
		}
		
		keyword = encodeURIComponent(keyword);
		title= encodeURIComponent(title);
		var pagesize=pagesize*((backIndex>0&&backIndex>pageindex)?backIndex:1);
		if(keyword==""){
			return;
		}
		if(type==1) { //refresh
			pageindex = 1;
			$("#list").html("");
		} else if(type==2) { //add
			pageindex = parseInt(pageindex+"") + 1;
		}
		$('#nosearchResult').hide();
		$("#hotPoint").hide();
		$("#searchResult").html("");
		$("#listItemMore").css("display","");
		$("#listItemMore").html("<img src='/mobile/plugin/fullsearch/img/ajax-loader_wev8.gif' style='vertical-align:middle;'>&nbsp;<%=SystemEnv.getHtmlLabelName(81558,user.getLanguage()) %>").unbind("click");
		
		util.getData({
	    	loadingTarget : document.body,
    		paras : "hideHead=<%=hideHead%>&noauth=&title="+title+"&contentType="+contentType+"&pagesize="+pagesize+"&pageindex="+pageindex+"&keyword="+keyword,//得数据的URL,
    		callback : function (data){	
    
				var errormsg = data.err;
				if(errormsg<0) {
					$("#listItemMore").html(data.msg);
				}
				if(data.list) {
					if($("#page_"+data.pageindex).length>0) {
						$("#page_"+data.pageindex).html("");
					} else {
						$("#list").append('<div id="page_'+data.pageindex+'"></div>');
					}
					$("#pagesize").val(data.pagesize);
					$("#ishavepre").val(data.ishavepre);
					$("#count").val(data.count);
					$("#pagecount").val(data.pagecount);
					$("#pageindex").val(backIndex>data.pageindex?backIndex:data.pageindex);
					$("#ishavenext").val(data.ishavenext);
					
					if(data.ishavenext=="0") {
						if(data.count==0){
							$("#listItemMore").css("display","none");
							$('#nosearchResult').show();
						}else{
							$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(23631,user.getLanguage()) %> <label>"+data.count+"</label> <%=SystemEnv.getHtmlLabelName(18256,user.getLanguage()) %>");
						}					
					} else {
						$("#listItemMore").html("<%=SystemEnv.getHtmlLabelName(83447,user.getLanguage()) %>").bind("click", function(){
							loadList(2);
						});
					}
					
					$.each(data.list,function(j,item){
						var itemstr =
								"<a href='javascript:goPage(\""+item.id+"\",\""+item.schema+"\",\""+item.url+"\")'>"+		
								"<div class='listitem' id='id_"+item.id+"' onclick='goPage(\""+item.id+"\",\""+item.schema+"\",\""+item.url+"\")'>"+
								"	<table  style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>"+
								"		<tbody>"+
								"			<tr>"+
								"				<td class='emptytd'></td>"+
								"				<td class='itemcontent'>"+
								"				<div class='itemcontenttitle'>"+
								"	 				<table style='width:100%;height:100%;border:0;cellspacing:0;cellpadding:0;table-layout:fixed;'>"+
								"	 					<tbody>"+
								"							<tr>"+
								"								<td class='ictwz'>"+item.title+"</td>"+
								"							</tr>"+
								"						</tbody>"+
								"					</table>"+
								"				</div>"+
								"				<div class='itemcontents'>"+item.content+"</div>"+
								"				<div class='itemcontentitdt'>"+item.description+"</div>"+
								"				</td>"+
								"				<td style='vertical-align: top;width:2px;'>"+
								"				</td>"+
								"				<td class='itemnavpoint'>"+
								"					<img src='/mobile/plugin/fullsearch/img/right_wev8.png'>"+
								"				</td>"+
								"				<td class='emptytd'></td>"+
								"			</tr>"+
								"		</tbody>"+
								"	</table>"+
								"</div>"+
								"<div class='blankLines'></div>"+
								"</a>";
						$("#page_"+pageindex).append(itemstr);
					});	
					
					$("#searchResult").html(data.result);
				}
			}
	    });
	}
	
	function checkHot(obj){
		var hotkey=$(obj).html();
		if(!!hotkey){
			$("#keyword").val(hotkey);
			loadList(1);
		}
	}
	
	function goPage(detailid,schema,url) {
		var type=1;
		var module = $("#module").val();
		var scope = $("#scope").val();
		var pageindex= $("#pageindex").val();
		var keyword = $("#keyword").val();
		var url="";
		
		<%
			Iterator<String> it=pageMap.keySet().iterator();
			while(it.hasNext()){
				String key=it.next();
				String url=pageMap.get(key).getUrl();
				url=url.replaceAll("\\{ID\\}","\"+detailid+\"");
		%>
			if(schema=="<%=key%>"){
				location="<%=url%>";
				return;
			}
		<% }
		
		%>
	}
	
	function goBack() {
		location = "/home.do";
	}

	function changeType(obj){
		//选中
		$('#typeshow').html($(obj).attr("tname"));
		$('#contentType').val($(obj).attr("tvalue"));
		var contentType=$(obj).attr("tvalue");
		loadList(1);
		selectType();
	}

	//给选中的变色和加勾
	function selectType(){
		var contentType=$('#contentType').val();
		//给选中的变颜色
		$("#btnNav").find('A').each(function(){
			$(this).removeClass("select");			 
		});
		//去除所有√
		$("div.typeImgDiv").each(function(){
			$(this).addClass("none");
			 
		});
		//选中字体变色
		$("#typeA_"+contentType).addClass("select");
		//选中加√
		//$("#typeImg_"+contentType).removeClass("none");
	}

	 

	function openChangeType(){
		openTypeDiv=!openTypeDiv;
		if(openTypeDiv){
			//var contentType=$('#contentType').val();
			//给选中的变颜色
			//$("#btnNav").find('A').each(function(){
			//	$(this).removeClass("select");			 
			//});
			//去除所有√
			//$("div.typeImgDiv").each(function(){
			//	$(this).addClass("none");
			//	 
			//});
			//选中字体变色
			//$("#typeA_"+contentType).addClass("select");
			//选中加√
			//$("#typeImg_"+contentType).removeClass("none");
			 
			$("#btnNavParent").slideDown();
			$("#btnNav").slideDown();
			//$("#btnNav").show('fast');
			
		}else{
			$("#btnNavParent").hide();
			$("#btnNav").hide();
			//$("#btnNav").slideUp();
		}
		
	}

	function hideNavType(){
		var e = arguments[0] || window.event;
		var eventSource = e.srcElement||e.target;
		if(eventSource.id!="typeshow"&&eventSource.id!="downshow"&&eventSource.id!="searchType"){
			openTypeDiv=false;
			$("#btnNavParent").hide();
			$("#btnNav").hide();
			//$("#btnNav").slideUp();
		}
		
	}
	
	</script>

</body>
</html>
